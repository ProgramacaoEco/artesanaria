// ignore_for_file: file_names, annotate_overrides
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:loja_flyinghigh/app/widgets/cardDestaque.dart';
import 'package:loja_flyinghigh/utils/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/card.dart';
import '../model/produto.dart';
import '../widgets/bottomSheet.dart';
import '../../database/database.dart';

import '../widgets/colors.dart';
import 'produtosPage_controller.dart';

Cores cor = Cores();

class NavegacaoProdutosView extends StatefulWidget {
  const NavegacaoProdutosView({Key? key}) : super(key: key);
  @override
  _NavegacaoProdutosView createState() => _NavegacaoProdutosView();
}

class _NavegacaoProdutosView extends State<NavegacaoProdutosView> {
  ProdutoState pdS = ProdutoState();
  final formater = NumberFormat("###0.000");

  List<Produto> produtos = [];
  List<Widget> cards = [];

  late http.Response response;
  var error;

  var categoria;

  @override
  void initState() {
    super.initState();
    gerarCards();
  }

  @override
  void dispose() {
    super.dispose();
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
      // headers: {"telefone": '(51)98745-9879'},
    );

    if (response.statusCode != 204) {
      List dados = json.decode(response.body);

      for (int i = 0; i < dados.length; i++) {
        String valor = dados[i]['valor'];
        valor.replaceAll('.', ',');
        int quantidadesSoma = 0;

        var data;
        if (dados[i]['imagens'].length == 0) {
          data = null;
        } else {
          data = dados[i]['imagens'][0]['path'];
        }
        print(dados);
        for (var quantidade in dados[i]['quantidades']) {
          if (quantidade['quantidade'] != null) {
            int quant = quantidade['quantidade'];
            quantidadesSoma = quantidadesSoma + quant;
          }
        }
        if (quantidadesSoma != 0) {
          produtos.add(
            Produto(
                codigoProduto: dados[i]['codigoProduto'],
                descricao_pagamento: dados[i]['descricao_pagamento'],
                id_produto: dados[i]['id_produto'],
                descricaoProduto: dados[i]['descricaoProduto'],
                imagens: data,
                valor: double.parse(valor),
                quantidades: dados[i]['quantidades']),
          );
        }
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

//corpo do aplicativo
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffffffff),
      appBar: AppBar(
        toolbarHeight: MediaQuery.of(context).size.height >= 800
            ? MediaQuery.of(context).size.height / 16
            : MediaQuery.of(context).size.height / 14,
        title: Text(categoria, style: TextStyle(color: Color(0xFF6c5c54))),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(cor.cor1),
                Color(cor.cor2),
                Color(cor.cor3),
              ],
            ),
          ),
        ),
      ),
      // bottomNavigationBar: CustomBottomsheet(),
      // pp.error != null
      //     ? pp.cards[0]
      //     :
      body: Center(
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Wrap(
                  direction: Axis.horizontal,
                  alignment: WrapAlignment.spaceAround,
                  children: cards),
            ],
          ),
        ),
      ),
    );
  }
}
