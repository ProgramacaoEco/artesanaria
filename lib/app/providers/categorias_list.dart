import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:loja_flyinghigh/app/model/roundedBox.dart';
import 'package:http/http.dart' as http;
import 'package:loja_flyinghigh/utils/constants.dart';

class CategoriasList with ChangeNotifier {
  List<Categoria> _items = [];

  List<Categoria> get items => [..._items];

   

  Future<void> index() async {
    _items.clear();

    var response = await http.get(
      Uri.parse('${Constants.API_BASIC_ROUTE}/public/api/listarCategorias'),
      headers: {
        "Accept": "application/json",
        "content-type": "application/json"
      },
    );

    var dados = jsonDecode(response.body);

    for (var dado in dados) {
      _items.add(
        Categoria(
          id_categoria: dado['id_categoria'],
          text: dado['nome_categoria'],
          imagem: dado['path'],
        ),
      );
      notifyListeners();
    }
  }
}
