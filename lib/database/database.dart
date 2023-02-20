// ignore_for_file: constant_identifier_names

import 'dart:io';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class DatabaseHelper {
  static const _databaseName = "Carrinho.db";
  static const _databaseVersion = 1;
  static const table = 'carrinho';
  static const columnId_produto = 'id_produto';
  static const columnDescricaoProduto = 'descricaoProduto';
  static const columnQuantidade = 'quantidade';
  static const columnValor = 'valor';
  static const columnDescricao_pagamento = 'descricao_pagamento';
  static const columnTamanho = 'tamanho';
  static const columnImagem = 'imagem';
  static const columnCodigoProduto = 'codigoProduto';

  static const tableLogado = 'Logado';
  static const columnLogado = 'logado';
  static const columnNome = 'nome';
  static const columnEmail = 'email';
  static const columnTelefone = 'telefone';
  static const columnSenha = 'senha';

  // torna esta classe singleton
  DatabaseHelper._privateConstructor();

  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  // tem somente uma referência ao banco de dados
   late Database _database;

  Future<Database> get database async {
    _database = await _initDatabase();
    return _database;
  }

  // abre o banco de dados e o cria se ele não existir
  _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    return await openDatabase(path,
        version: _databaseVersion, onCreate: _onCreate);
  }

  // Código SQL para criar o banco de dados e a tabela
  Future _onCreate(Database db, int version) async {
    await db.execute('''
          CREATE TABLE $table (
            $columnId_produto INTEGER,
            $columnQuantidade INTEGER,
            $columnValor DECIMAL(9,2),
            $columnDescricaoProduto VARCHAR(60),
            $columnDescricao_pagamento VARCHAR(45),
            $columnTamanho VARCHAR(3),
            $columnImagem VARCHAR(200),
            $columnCodigoProduto VARCHAR(45)
          )
          ''');
    await db.execute('''
          CREATE TABLE $tableLogado (
          $columnLogado INTEGER DEFAULT 0,
          $columnNome VARCHAR(45),
          $columnEmail VARCHAR(100),
          $columnTelefone VARCHAR(14),
          $columnSenha VARCHAR(30)
          )
    ''');
  }

  Future<void> DropTableIfExistsThenReCreate(String tabela) async {
    Database db = await instance.database;
    //Aqui nós executamos uma consulta para dropar a tabela se ela existir na qual é chamada "NomeDaTabela"
    //e pode ser concedido um parametro para o método também
    await db.execute("DROP TABLE IF EXISTS $tabela");

    //e finalmente aqui recriamos a nossa amada "NomeDaTabela" novamente na qual precisa
    //de algumas colunas de inicialização
    await db.execute('''CREATE TABLE $tabela(
      $columnId_produto INTEGER,
      $columnQuantidade INTEGER,
      $columnValor DECIMAL(9,2),
      $columnDescricaoProduto VARCHAR(60),
      $columnDescricao_pagamento VARCHAR(45),
      $columnTamanho VARCHAR(3),
      $columnImagem VARCHAR(200),
      $columnCodigoProduto VARCHAR(45)
    )''');
  }

  // métodos Helper
  //----------------------------------------------------
  // Insere uma linha no banco de dados onde cada chave
  // no Map é um nome de coluna e o valor é o valor da coluna.
  // O valor de retorno é o id da linha inserida.
  Future<int?> insert(Map<String, dynamic> row) async {
    Database db = await instance.database;
    return await db.insert(table, row);
  }

  Future valorTotalCarrinho() async {
    Database db = await instance.database;
    return await db.rawQuery('select sum($columnValor) from $table');
  }

  Future<int> insertLogado(Map<String, dynamic> row) async {
    Database db = await instance.database;
    return await db.insert(tableLogado, row);
  }

  // Todas as linhas são retornadas como uma lista de mapas, onde cada mapa é
  // uma lista de valores-chave de colunas.
  Future<List<Map<String, dynamic>>> queryAllRows() async {
    Database db = await instance.database;
    return await db.query(table);
  }

  //ignore: slash_for_doc_comments
  Future<List<Map<dynamic, dynamic>>> queryAllRowsLogado() async {
    Database db = await instance.database;
    return await db.query(tableLogado);
  }

  // Todos os métodos : inserir, consultar, atualizar e excluir,
  // também podem ser feitos usando  comandos SQL brutos.
  // Esse método usa uma consulta bruta para fornecer a contagem de linhas.
  Future<int?> queryRowCount() async {
    Database db = await instance.database;
    return Sqflite.firstIntValue(
        await db.rawQuery('SELECT COUNT(*) FROM $table'));
  }

  Future<int?> queryRowCountLogado() async {
    Database db = await instance.database;
    return Sqflite.firstIntValue(
        await db.rawQuery('SELECT COUNT(*) FROM $tableLogado'));
  }

  // Assumimos aqui que a coluna id no mapa está definida. Os outros
  // valores das colunas serão usados para atualizar a linha.
  Future<int> update(Map<String, dynamic> row) async {
    Database db = await instance.database;
    int id = row[columnId_produto];
    return await db
        .update(table, row, where: '$columnId_produto = ?', whereArgs: [id]);
  }

  // Exclui a linha especificada pelo id. O número de linhas afetadas é
  // retornada. Isso deve ser igual a 1, contanto que a linha exista.
  Future<int> limparCarrinho() async {
    Database db = await instance.database;
    return await db.delete(table, where: '$columnId_produto != 0');
  }

  Future<int> removerItem(String descricaoProduto, String tamanho) async {
    Database db = await instance.database;
    return await db.delete(table,
        where: '$columnDescricaoProduto = ? and $columnTamanho = ?',
        whereArgs: [descricaoProduto, tamanho]);
  }

  Future<int> verificarItemDuplicado(int quantidade, dynamic valor,
      String descricaoProduto, String tamanho) async {
    Database db = await instance.database;
    return await db.rawUpdate('''UPDATE $table 
    set $columnQuantidade = $columnQuantidade + ?,
    $columnValor = $columnValor + (? * ?) 
    where $columnDescricaoProduto = ? and $columnTamanho = ?''',
        [quantidade, quantidade, valor, descricaoProduto, tamanho]);
  }

  Future<int> editarItem(int quantidade, dynamic valor, 
  String descricaoProduto,
      String tamanhoEdicao, String tamanhoPesquisa) async {
    Database db = await instance.database;
    return await db.rawUpdate('''UPDATE $table 
    set $columnQuantidade = ?,
    $columnValor = ?,
    $columnTamanho = ?
    where $columnDescricaoProduto = ? and $columnTamanho = ?''',
        [quantidade, valor, tamanhoEdicao, descricaoProduto, tamanhoPesquisa]);
  }

  Future<List<Map<String, dynamic>>> obterItemExistente(
      String descricaoProduto, String tamanho) async {
    Database db = await instance.database;
    return await db.rawQuery(
        "select $columnCodigoProduto, $columnDescricaoProduto, $columnTamanho from $table where $columnDescricaoProduto = ? and $columnTamanho = ?",
        [descricaoProduto, tamanho]);
  }

  Future<List<Map<String, dynamic>>> truncarLogado() async {
    Database db = await instance.database;
    return await db.rawQuery("delete from $tableLogado where logado = ?", [1]);
  }
}
