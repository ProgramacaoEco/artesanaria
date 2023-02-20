
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'pesquisar_view.dart';




class Pesquisar extends SearchDelegate {

  @override
  // TODO: implement searchFieldLabel
  String get searchFieldLabel => "Pesquisar produto";
 
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(icon: const Icon(Icons.clear),
          onPressed: () {
            query = '';
            Navigator.pop(context);
          }
        ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    resultadoPesquisa() async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('pesquisa', query);
    }
    resultadoPesquisa();
    return  Builder(
      builder: (context) {
        return TelaPesquisaView();
      }
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Container();
  }
}
