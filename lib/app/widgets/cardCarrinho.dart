// ignore_for_file: file_names
import 'package:loja_flyinghigh/utils/constants.dart';

import '../../database/database.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CardCarrinho extends StatelessWidget {
  fontes(BuildContext context) {
    if (MediaQuery.of(context).size.height >= 800) {
      return 16.0;
    } else {
      return 12.0;
    }
  }

  CardCarrinho(
      {required this.id_produto,
      required this.descricaoProduto,
      required this.valor,
      required this.imagem,
      required this.descricao_pagamento,
      required this.quantidade,
      required this.tamanho,
      required this.codigoProduto});

  int id_produto;
  String imagem;
  String descricaoProduto;
  String descricao_pagamento;
  int quantidade;
  String tamanho;
  String codigoProduto;
  var valor;
  var valorUnidade;

  Widget carregarImagem(String produtoImagem) {
      print(produtoImagem);
    if (produtoImagem == null) {
      return Image.asset('lib/images/noImage.png', fit: BoxFit.cover);
    } else {
      try {

        return Image.network(
            //rotaIMAGE
            '${Constants.API_BASIC_ROUTE}/storage/app/$produtoImagem',
            fit: BoxFit.cover);
      } catch (error) {
        return Image.asset('lib/images/noImage.png', fit: BoxFit.cover);
      }
    }
  }

  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    // String preco = valorUnidade.toString();
    return Container(
      margin: EdgeInsets.only(top: 3),
      width: MediaQuery.of(context).size.width,
      height: size.height * 0.35,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: Colors.white,
      ),
      child: Card(
        child: Flex(
          crossAxisAlignment: CrossAxisAlignment.center,
          direction: Axis.horizontal,
          children: [
            Container(
              width: MediaQuery.of(context).size.width / 2.8,
              height: MediaQuery.of(context).size.height / 3,
              child: carregarImagem(this.imagem),
            ),
            Container(
              margin: EdgeInsets.only(left: 20, top: 10, bottom: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        width: size.width * 0.5,
                        child: Text(
                          this.descricaoProduto,
                          style: GoogleFonts.nanumGothic(
                            fontWeight: FontWeight.w700,
                            fontSize: descricaoProduto.length > 28 ? 20 : 22,
                          ),
                        ),
                      ),
                    ],
                  ),

                  // Container(
                  //     width: MediaQuery.of(context).size.width / 2,
                  //     child: Text(this.descricao_pagamento,
                  //                 style: GoogleFonts.nanumGothic(
                  //                   fontSize: fontes(context),
                  //                 ),
                  //     )),
                  Container(
                    child: Row(
                      children: [
                        Text(
                          quantidade.toString(),
                          style: GoogleFonts.nanumGothic(
                            fontSize: 18,
                          ),
                        ),
                        Text(
                          quantidade == 1 ? ' unidade' : ' unidades',
                          style: GoogleFonts.nanumGothic(
                            fontSize: 18,
                          ),
                        )
                      ],
                    ),
                  ),
                  Container(
                  child: Row(
                    children: [
                      Text(
                        "Tamanho: ",
                        style: GoogleFonts.nanumGothic(
                          fontSize: MediaQuery.of(context).size.height > 600 ? 18 : 14,
                        ),
                      ),
                      Text(
                        tamanho,
                        style: GoogleFonts.nanumGothic(
                          fontSize: MediaQuery.of(context).size.height > 600 ? 18 : 14,
                        ),
                      ),
                    ],
                  )                  ),
                  Row(
                    children: [
                      Container(
                        child: Text(
                          'Valor total: ',
                          style: GoogleFonts.nanumGothic(
                            fontSize: MediaQuery.of(context).size.height > 600 ? 18 : 14,
                          ),
                          // width: MediaQuery.of(context).size.width / 2,
                        ),
                      ),
                      Container(
                        child: Text(
                          "R\$${this.valor.toString().replaceAll(".", ",")}",
                          style: GoogleFonts.nanumGothic(
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFCF1A1A),
                            fontSize: MediaQuery.of(context).size.height > 600 ? 20 : 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width / 2,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          margin: EdgeInsets.only(right: 10),
                          child: Text(
                            "Editar",
                            style: GoogleFonts.nanumGothic(
                              color: Colors.blue,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        Center(
                          //widthFactor: 2.5,

                          child: GestureDetector(
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: Text(
                                        "Deseja remover o item $descricaoProduto?"),
                                    actions: [
                                      ElevatedButton(
                                        onPressed: () {
                                          DatabaseHelper dbHelper =
                                              DatabaseHelper.instance;
                                          dbHelper.removerItem(
                                              descricaoProduto, tamanho);
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                  "Item removido com sucesso."),
                                            ),
                                          );
                                          Navigator.pop(context);
                                          Navigator.pop(context);
                                          Navigator.pushNamed(
                                              context, "/carrinho");
                                        },
                                        child: Text("Sim"),
                                        style: ElevatedButton.styleFrom(
                                            primary: Color(0xFFCF1A1A)),
                                      ),
                                      ElevatedButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: Text("Não"),
                                        style: ElevatedButton.styleFrom(
                                            primary: Color(0xFFCF1A1A)),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border(
                                  top: BorderSide(color: Colors.red),
                                  left: BorderSide(color: Colors.red),
                                  right: BorderSide(color: Colors.red),
                                  bottom: BorderSide(color: Colors.red),
                                ),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(3.0),
                                  child: Container(
                                    margin: EdgeInsets.only(left: 7),
                                    child: Text(
                                      "Remover",
                                      style: GoogleFonts.nanumGothic(
                                          fontSize: 16, color: Colors.red),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
