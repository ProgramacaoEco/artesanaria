// ignore_for_file: file_names, import_of_legacy_library_into_null_safe
// ignore_for_file: unused_import

import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:loja_flyinghigh/app/widgets/cardDestaque.dart';
import 'package:loja_flyinghigh/utils/constants.dart';
import 'package:shared_preferences/shared_preferences.dart'
    show SharedPreferences;

import '../model/card.dart';
import '../../database/database.dart';
import '../produto/descricaoProduto_view.dart';
import 'produtosPage_view.dart' show NavegacaoProdutosView;
import '../model/produto.dart';
import 'produtosPage_view.dart';

class ProdutoState extends State<NavegacaoProdutosView> {
  final formater = NumberFormat("###0.000");

  List<Produto> produtos = [];
  List<Widget> cards = [];

  late http.Response response;
  var error;

  var categoria;

  void initState() {
    super.initState();
    gerarCards();
  }

  DatabaseHelper dbHelper = DatabaseHelper.instance;

  gerarCards() async {
    //var list = await dbHelper.queryAllRowsLogado();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(
      () {
        categoria = prefs.getString('categoria');
      },
    );
    var url = Uri.https('${Constants.API_ROOT_ROUTE}',
        '${Constants.API_FOLDERS}listarProdutosPorCategoria');
    response = await http.post(
      url,
      body: {"nome_categoria": categoria},
      headers: {"telefone": '(51)98745-9879'},
    );

    if (response.statusCode != 204) {
      List dados = json.decode(response.body);
      print(dados);

      for (int i = 0; i < dados.length; i++) {
        String valor = dados[i]['valor'];
        valor.replaceAll('.', ',');

        var data;
        if (dados[i]['imagens'].length == 0) {
          data = null;
        } else {
          data = dados[i]['imagens'][0]['path'];
        }

        produtos.add(
          Produto(
            codigoProduto: dados[i]['codigoProduto'],
            descricao_pagamento: dados[i]['descricao_pagamento'],
            id_produto: dados[i]['id_produto'],
            descricaoProduto: dados[i]['descricaoProduto'],
            imagens: data,
            valor: double.parse(valor),
            quantidades: dados[i]['quantidades'],
          ),
        );
      }

      for (var string in produtos) {
        setState(
          () {
            cards.add(
              CustomCardDestaque(string),
            );
          },
        );
      }
    } else {
      setState(
        () {
          error = const Center(
            child: Text("Não há produtos cadastrados"),
          );
          cards.add(error);
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }
}
