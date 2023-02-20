import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:loja_flyinghigh/app/widgets/cardDestaque.dart';
import 'package:loja_flyinghigh/utils/constants.dart';
import '../model/card.dart';
import '../model/produto.dart';
import '../../database/database.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../widgets/colors.dart';

Cores cor = Cores();

class TelaPesquisaView extends StatefulWidget {
  const TelaPesquisaView({Key? key}) : super(key: key);
  @override
  PesquisaView createState() => PesquisaView();
}

class PesquisaView extends State<TelaPesquisaView> {
  @override
  void initState() {
    super.initState();
    gerarCards();
    //ChecarInternet().checarConexao(context);
  }

  @override
  void dispose() {
    super.dispose();
    //ChecarInternet().listener.cancel();
  }

  late http.Response response;
  final formater = NumberFormat("###0.000");

  List<Produto> produtos = [];
  List<Widget> cards = [];

  var error;
  var pesquisa;

  DatabaseHelper dbHelper = DatabaseHelper.instance;

  gerarCards() async {
    //var list = await dbHelper.queryAllRowsLogado();
    SharedPreferences prefs = await SharedPreferences.getInstance();

    pesquisa = prefs.getString('pesquisa');

    var url = Uri.https('${Constants.API_ROOT_ROUTE}',
        '${Constants.API_FOLDERS}listarProdutosLike');
    response = await http.post(
      url,
      body: {"descricaoProduto": pesquisa},
      //headers: {"telefone": list[0]["telefone"],},
    );

    if (response.statusCode != 204) {
      List dados = [];
      dados = json.decode(response.body);

      for (int i = 0; i < dados.length; i++) {
        produtos.add(
          Produto(
            codigoProduto: dados[i]['codigoProduto'],
            descricao_pagamento: dados[i]['descricao_pagamento'],
            id_produto: dados[i]['id_produto'],
            descricaoProduto: dados[i]['descricaoProduto'],
            imagens: dados[i]['imagens'][0]['path'] == null
                ? null
                : dados[i]['imagens'][0]['path'],
            valor: double.parse(
              dados[i]['valor'],
            ),
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
          error = Center(
            child: Text("Não foram encontrados resultados para: $pesquisa"),
          );
          cards.add(error);
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffeeeeee),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Color(cor.tema),
        title: Center(
          child: Text(
            "Pesquisa de produtos",
            style: TextStyle(color: Colors.white),
          ),
          widthFactor: MediaQuery.of(context).size.width <= 400 &&
                      MediaQuery.of(context).size.height <= 600 ||
                  MediaQuery.of(context).size.width <= 600 &&
                      MediaQuery.of(context).size.height <= 400
              ? 2
              : 2,
        ),
      ),
      body: error != null
          ? cards[0]
          : Center(
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Wrap(
                      direction: Axis.horizontal,
                      alignment: WrapAlignment.spaceAround,
                      children: cards,
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
