import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:loja_flyinghigh/app/model/bairro.dart';
import 'package:loja_flyinghigh/app/model/campanha.dart';
import 'package:loja_flyinghigh/utils/constants.dart';
import 'package:http/http.dart' as http;

class BairrosList with ChangeNotifier {
  List<Bairro> _bairros = [];

  List<Bairro> get bairros => [..._bairros];

  int get itemsCount {
    return _bairros.length;
  }



  Future<void> index() async {
    _bairros.clear();

    var url = Uri.https(
        '${Constants.API_ROOT_ROUTE}', '${Constants.API_FOLDERS}listarBairros');

    var response = await http.get(url).then((response) {
      List dados = json.decode(response.body);
      for (var bairro in dados) {
        _bairros.add(
          Bairro(
              id: bairro['id_bairro'],
              nome: bairro['nome'],
              valorFrete: double.parse(bairro['valor_frete'])
          ),
        );
      }
    });
    notifyListeners();
  }

}
