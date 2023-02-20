import 'dart:convert';
import 'package:loja_flyinghigh/app/model/produto.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:loja_flyinghigh/utils/constants.dart';
import 'package:material_dialogs/material_dialogs.dart';
import 'package:number_inc_dec/number_inc_dec.dart';
import 'package:toast/toast.dart';
import '../widgets/colors.dart';

import '../../database/database.dart';
import '../widgets/cardCarrinho.dart';
import 'card_carrinho.dart';

//Instância da classe Cores, onde ficam as cores padrões do projeto
Cores cor = Cores();

fontes(BuildContext context) {
  if (MediaQuery.of(context).size.height >= 650) {
    return 18.0;
  } else {
    return 14.0;
  }
}

fontesBotao(BuildContext context) {
  if (MediaQuery.of(context).size.height >= 650) {
    return 24.0;
  } else {
    return 22.0;
  }
}

class Carrinho extends StatefulWidget {
  CarrinhoState createState() => CarrinhoState();
}

class CarrinhoState extends State<Carrinho> {
  @override
  void initState() {
    super.initState();
    //ChecarInternet().checarConexao(context);
    obterItensCarrinho();
  }

  @override
  void dispose() {
    //ChecarInternet().listener.cancel();
    super.dispose();
  }

  late http.Response response;

  List tamanhos = [];
  late double valorOriginal;
  var tamanhoSelecionado;

  TextEditingController quantidade = TextEditingController();

  List<Widget> cardsCarrinho = [];
  final dbHelper = DatabaseHelper.instance;
  bool editarClicado = false;

//============================================================================
//Este método popula variáveis locais referentes ao item do carrinho,
//recebendo os dados através da rota da api (/api/listarTudoProdutos)
//============================================================================

  obterItensCarrinho() async {
    final itens = await dbHelper.queryAllRows();
    itens.forEach((element) {
      setState(() {
        //enviando o id do produto através de um post e recebendo os dados
        cardsCarrinho.add(CardCarrinhoWidget(element));
      });
    });
  }

  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    return Scaffold(
        backgroundColor: Color(0xffeeeeee),
        bottomSheet: GestureDetector(
          child: Flushbar(
            backgroundColor: Color(cor.tema),
            messageText: Center(
                child: Text("Finalizar compra",
                    style: GoogleFonts.openSans(
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                        fontSize: fontesBotao(context)))),
            isDismissible: false,
            flushbarPosition: FlushbarPosition.BOTTOM,
          ),
          onTap: () {
            if (cardsCarrinho.isEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text("O carrinho está vazio"),
                  duration: Duration(seconds: 1)));
            } else {
              Navigator.pushNamed(context, "/finalizarCompra");
            }
          },
        ),
        appBar: AppBar(
          toolbarHeight: MediaQuery.of(context).size.height >= 650
              ? MediaQuery.of(context).size.height / 13
              : MediaQuery.of(context).size.height / 11,
          automaticallyImplyLeading: true,
          title: Center(
            child: Container(
              margin: EdgeInsets.only(top: 20, bottom: 20),
              height: MediaQuery.of(context).size.height / 11,
              child: Image.asset(
                'assets/logoamandaraupp.jpeg',
              ),
            ),
          ),
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(cor.cCinza1),
                  Color(cor.cCinza22),
                  Color(cor.cCinza22),
                  Color(cor.cCinza3),
                ],
              ),
            ),
          ),
          actions: [
            Center(
                child: Container(
              margin: EdgeInsets.only(right: 10),
              child: GestureDetector(
                child: Text("Limpar", style: TextStyle(color: Colors.white)),
                onTap: () async {
                  var linhas = await dbHelper.queryAllRows();
                  if (linhas.length == 0 || linhas.isEmpty == true) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text("O carrinho está vazio"),
                    ));
                  } else {
                    await dbHelper.limparCarrinho();
                    Navigator.pushReplacementNamed(context, "/carrinho");
                  }
                },
              ),
            ))
          ],
        ),
        body: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            alignment: Alignment.center,
            margin: EdgeInsets.all(5),
            child: ListView.builder(
                itemCount: cardsCarrinho.length,
                itemBuilder: (context, index) {
                  return cardsCarrinho[index];
                })));
  }
}
