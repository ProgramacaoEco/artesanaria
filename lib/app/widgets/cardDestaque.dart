// ignore_for_file: file_names, must_be_immutable, unused_element, unnecessary_this, import_of_legacy_library_into_null_safe

import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:loja_flyinghigh/app/produto/descricaoProduto_view.dart';
import 'package:loja_flyinghigh/utils/constants.dart';
import '../../database/database.dart';
import '../model/produto.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:async/async.dart';

import 'package:shared_preferences/shared_preferences.dart'
    show SharedPreferences;
import 'package:http/http.dart' as http;
import 'colors.dart';

class CustomCardDestaque extends StatelessWidget {
  final Produto produto;
  CustomCardDestaque(this.produto, {Key? key}) : super(key: key);

  //declarando instâncias de (Color, DatabaseHelper[database.dart]; AsyncMemoizer; Produto[produto.dart])
  DatabaseHelper dbHelper = DatabaseHelper.instance;
  AsyncMemoizer memoizerDestaques = AsyncMemoizer();
  Cores cor = Cores();

  late http.Response response;

  gerarUrl() {
    var url = Uri.https('${Constants.API_ROOT_ROUTE}',
        '${Constants.API_FOLDERS}listarTudoProdutos/${produto.id_produto}');
    return url;
  }

  var urlgetPagador =
      Uri.https('dev.app.pagozap.com.br:3000', '/api/Pagador/Save');

  fontes(BuildContext context) {
    if (MediaQuery.of(context).size.height >= 800) {
      return 18.0;
    } else {
      return 12.0;
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return GestureDetector(
        child: Container(
          margin: const EdgeInsets.only(top: 7, left: 2.5, right: 2.5),
          height: size.height * 0.3,
          width: size.width * 0.3,
          decoration: BoxDecoration(
            color: Colors.white70,
            border: Border.all(width: 3.0, color: Colors.blueGrey.shade100),
            borderRadius: const BorderRadius.all(Radius.circular(10)),
          ),
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.only(),
                height: size.height * 0.18,
                width: MediaQuery.of(context).size.width / 3.2,
                child: produto.imagens != null
                    ? Container(
                        decoration: BoxDecoration(color: Colors.transparent),
                        child: Image.network(
                          //rotaIMAGE
                          '${Constants.API_BASIC_ROUTE}/storage/app/${produto.imagens}',
                          fit: BoxFit.cover,
                        ),
                      )
                    : Image.asset('lib/app/images/noImage.png',
                        fit: BoxFit.cover),
              ),
              Expanded(
                child: Container(
                  // height: size.height * 0.1,
                  width: size.width / 2.2,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                    color: Color(cor.corTransp),
                  ),
                  child: Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          margin:
                              const EdgeInsets.only(top: 5, bottom: 3, left: 3),
                          //width: MediaQuery.of(context).size.width / 2.5,
                          child: Text(
                            produto.descricaoProduto,
                            // textAlign: TextAlign.center,
                            style: GoogleFonts.nanumGothic(
                                fontSize:
                                    MediaQuery.of(context).size.height >= 650
                                        ? produto.descricaoProduto.length > 24
                                            ? 11
                                            : 14
                                        : produto.descricaoProduto.length > 45
                                            ? 6
                                            : produto.descricaoProduto.length >= 24
                                                ? 8
                                                : 9,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        // width: MediaQuery.of(context).size.width / 2,
                        //height: MediaQuery.of(context).size.height / 50

                        // Container(
                        //   child: Text(
                        //     produto.descricao_pagamento! ,
                        //     textAlign: TextAlign.start,
                        //     style: GoogleFonts.nanumGothic(
                        //       fontSize: MediaQuery.of(context).size.height >= 800 ?   14 : 12,
                        //       fontWeight: FontWeight.w200,
                        //       textStyle: TextStyle(),
                        //     ),
                        //   ),
                        //   width: MediaQuery.of(context).size.width / 2.4,
                        //   height: MediaQuery.of(context).size.height / 13.5,
                        //   alignment: Alignment.center,
                        // ),
                        Container(
                          margin: EdgeInsets.only(right: 5),
                          child: Text(
                            "R\$${produto.valor.toString().replaceAll('.', ',')}",
                            textAlign: TextAlign.center,
                            style: GoogleFonts.nanumGothic(
                              fontSize:
                                  MediaQuery.of(context).size.height >= 800
                                      ? 16
                                      : 14,
                              fontWeight: FontWeight.w800,
                              textStyle: TextStyle(color: Colors.red.shade900),
                            ),
                          ),
                          width: MediaQuery.of(context).size.width / 2.5,
                          height: MediaQuery.of(context).size.height >= 700
                              ? MediaQuery.of(context).size.height / 25
                              : MediaQuery.of(context).size.height / 35,
                          alignment: Alignment.topRight,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        onTap: () async {
          List<String> tamanhos = [];
          List<String> imagens = [];
          //var list = await dbHelper.queryAllRowsLogado();

          //Envia o id_produto através do http.post para popular as listas locais (tamanhos/imagens).
          response = await http.get(gerarUrl());
          var dados = json.decode(response.body);

          // for (int i = 0; i < dados['quantidades'].length; i++) {
          //   tamanhos.add(dados['tamanhos'][i]['tamanho']);
          // }

          for (int i = 0; i < dados['quantidades'].length; i++) {
            tamanhos.add(dados['quantidades'][i]['tamanho']);
          }

          for (int i = 0; i < dados['imagens'].length; i++) {
            imagens.add(dados['imagens'][i]['path']);
          }

          //SharedPreferences seta os valores para as variaveis entre parenteses, utilizando os valores das variáveis locais.
          SharedPreferences prefs = await SharedPreferences.getInstance();
          // prefs.setInt('id_produto', produto.id_produto!);
          // prefs.setString('descricaoProduto', produto.descricaoProduto!);
          // prefs.setDouble('valor', produto.valor!);
          // prefs.setString('descricaoPagamento', produto.descricao_pagamento!);
          // prefs.setString('codigoProduto', produto.codigoProduto!);
          // prefs.setStringList('tamanhos', tamanhos);
          prefs.setStringList('imagens', imagens);
          Navigator.push(
              (context),
              MaterialPageRoute(
                  builder: (context) => DescricaoProdutoView(this.produto)));
        });
  }
}
