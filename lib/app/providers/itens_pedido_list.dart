import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:loja_flyinghigh/app/compra/finalizar_compra.dart';
import 'package:loja_flyinghigh/app/model/itens_pedido.dart';
import 'package:http/http.dart' as http;
import 'package:loja_flyinghigh/utils/constants.dart';

class ListaItensPedido with ChangeNotifier {
  var valorTotal;
  List<ItensPedido> _items = [];

  List<ItensPedido> get items => [..._items];

  int get itemsCount {
    return _items.length;
  }

  Future<List> indexErr() async {
    _items.clear();
    List dados = await dbHelper.queryAllRows();

    for (var item in dados) {
      var value = item['valor'];
      var quant = item['quantidade'];
      double valquant = value / quant;

      _items.add(ItensPedido(
        idProduto: item['id_produto'],
        valor: valquant,
        codigoProduto: item['codigoProduto'].toString(),
        descricaoProduto: item['descricaoProduto'].toString(),
        tamanho: item['tamanho'].toString(),
        quantidade: item['quantidade'],
        imagem: '',
      ));
    }
    print(_items);
    return _items;
  }

  Future<List> indexList(idPedido) async {
    var url = Uri.parse(
        '${Constants.API_BASIC_ROUTE}${Constants.API_FOLDERS}listarItensPedido/$idPedido');

    _items.clear();
    // List dados = await dbHelper.queryAllRows();
    var response = await http.get(url);
    print('Resultado Requisição (status): ${response.statusCode}');
    print(response.body);
    var dados = jsonDecode(response.body);

    for (var item in dados) {
      _items.add(ItensPedido(
        idProduto: item['id_produto'],
        valor: double.parse(item['valor_unitario']),
        codigoProduto: item['codigoProduto'].toString(),
        descricaoProduto: item['descricaoProduto'].toString(),
        tamanho: item['tamanho'].toString(),
        quantidade: int.parse(item['quantidade']),
        imagem: '',
      ));
    }
    print(_items);
    return _items;
  }

  Future<void> carregaValorTotal() async {
    List dados = await dbHelper.queryAllRows();
    for (int i = 0; i < dados.length; i++) {
      var value = dados[i]['valor'];
      var quant = dados[i]['quantidade'];
      valorTotal = (valorTotal ?? 0 + value);
      print('CALCULATE');
      print(value);
      print(quant);
    }
    notifyListeners();
  }
}
