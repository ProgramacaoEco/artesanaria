import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:loja_flyinghigh/app/model/campanha.dart';
import 'package:loja_flyinghigh/utils/constants.dart';
import 'package:http/http.dart' as http;

class CampanhasList with ChangeNotifier {
  List<Widget> _items = [];

  List<Widget> get items => [..._items];

  int get itemsCount {
    return _items.length;
  }

  Future<void> index() async {
    _items = [];

    var url = Uri.https('${Constants.API_ROOT_ROUTE}',
        '${Constants.API_FOLDERS}listarCampanha');

    var response = await http.get(url).then((response) {
      List dados = json.decode(response.body);

      for (int i = 0; i < dados.length; i++) {
        _items.add(
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(
                  '${Constants.API_BASIC_ROUTE}/storage/app/${dados[i]['path']}',
                ),
                fit: BoxFit.cover,
              ),
            ),
          ),
        );
      }
    });
  }
}
