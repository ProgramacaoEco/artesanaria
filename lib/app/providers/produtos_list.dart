import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:loja_flyinghigh/app/model/produto.dart';
import 'package:loja_flyinghigh/app/widgets/cardDestaque.dart';
import 'package:loja_flyinghigh/utils/constants.dart';
import 'package:http/http.dart' as http;

class ProdutosList with ChangeNotifier {
  List<Produto> _items = [];

  List<Produto> get items => [..._items];

  List<CustomCardDestaque> _cards = [];

  List<CustomCardDestaque> get cards => [..._cards];

  int get itemsCount {
    return _items.length;
  }

  Future<void> editaQuantidade(id_qtde, qtde) async {}

  Future<void> index() async {
    _items.clear();
    _cards.clear();
    var url = Uri.https(Constants.API_ROOT_ROUTE,
        '${Constants.API_FOLDERS}getProdutosDestaque');
    var response = await http.get(url);
    var produtos = json.decode(response.body).reversed.toList();

    for (var produto in produtos) {
      var data;
      int quantidadesSoma = 0;
      if (produto['imagens'].length == 0) {
        data = null;
      } else {
        data = produto['imagens'][0]['path'];
      }
      for (var quantidade in produto['quantidades']) {
        if (quantidade['quantidade'] != null) {
          int quant = quantidade['quantidade'];
          quantidadesSoma = quantidadesSoma + quant;
        }
      }
      if (quantidadesSoma != 0) {
        _items.add(
          Produto(
              id_produto: produto['id_produto'],
              codigoProduto: produto['codigoProduto'],
              descricao_pagamento: produto['descricao_pagamento'],
              descricaoProduto: produto['descricaoProduto'],
              imagens: data,
              valor: double.parse(produto['valor']),
              quantidades: produto['quantidades']),
        );
      }
    }
    for (var produto in _items) {
      _cards.add(
        CustomCardDestaque(produto),
      );
    }
    notifyListeners();
  }
}
