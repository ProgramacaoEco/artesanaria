import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:loja_flyinghigh/app/widgets/cardCarrinho.dart';
import 'package:loja_flyinghigh/app/widgets/colors.dart';
import 'package:loja_flyinghigh/database/database.dart';
import 'package:loja_flyinghigh/utils/constants.dart';
import 'package:material_dialogs/material_dialogs.dart';
import 'package:number_inc_dec/number_inc_dec.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:toast/toast.dart';

class CardCarrinhoWidget extends StatefulWidget {
  var element;
  CardCarrinhoWidget(this.element, {Key? key}) : super(key: key);
  @override
  State<CardCarrinhoWidget> createState() => _CardCarrinhoWidgetState();
}

class _CardCarrinhoWidgetState extends State<CardCarrinhoWidget> {
  void initState() {
    super.initState();
    Widget; //ChecarInternet().checarConexao(context);
  }

  @override
  void dispose() {
    super.dispose();
    //ChecarInternet().listener.cancel();
  }

  List tamanhos = [];
  late double valorOriginal;
  var tamanhoSelecionado;
  int quantidadeMax = 0;
  TextEditingController quantidade = TextEditingController();

  getQtde(quantidade) {
    setState(() {
      quantidadeMax = quantidade;
    });
    print('mudou ${quantidade}');
  }

  List<Widget> cardsCarrinho = [];
  final dbHelper = DatabaseHelper.instance;
  bool editarClicado = false;
  Cores cor = Cores();

  @override
  Widget build(BuildContext context) {
    var url = Uri.https('${Constants.API_ROOT_ROUTE}',
        '${Constants.API_FOLDERS}listarTudoProdutos/${widget.element['id_produto']}');
    return GestureDetector(
      onTap: () async {
        var response = await http.get(url);
        var dados = json.decode(response.body);
        setState(() {
          for (int i = 0; i < dados['quantidades'].length; i++) {
            tamanhos.add(dados['quantidades'][i]['tamanho']);
          }
          tamanhos = dados['quantidades'];
          String valorOrigin = dados['valor'];
          valorOrigin.replaceAll(',', '.');
          valorOriginal = double.parse(valorOrigin);
        });
        Dialogs.materialDialog(
            title: 'Editar o produto ${widget.element['descricaoProduto']}',
            context: context,
            actions: [
              StatefulBuilder(builder: (context, StateSetter setState) {
                return Column(
                  children: [
                    Container(
                        margin: EdgeInsets.symmetric(vertical: 10),
                        child: DropdownButtonFormField(
                          hint: Text("Selecione o tamanho"),
                          items: tamanhos.map((tamanho) {
                            print(tamanho);
                            return DropdownMenuItem(
                                child: Text(tamanho['tamanho']),
                                value: tamanho['tamanho'],
                                onTap: () {
                                  setState(() {
                                    quantidadeMax = tamanho['quantidade'];
                                  });
                                  print('mudou ${quantidadeMax}');
                                });
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              tamanhoSelecionado = value;
                              print(tamanhoSelecionado);
                            });
                          },
                          value: tamanhoSelecionado,
                        )),
                    Container(
                      child: Text("Quantidade",
                          style: GoogleFonts.nanumGothic(fontSize: 15)),
                    ),
                    Container(
                        child: NumberInputWithIncrementDecrement(
                          incIcon: Icons.add,
                          decIcon: Icons.remove,
                          controller: quantidade,
                          max: quantidadeMax,
                          autovalidate: true,
                        ),
                        margin: EdgeInsets.symmetric(vertical: 5)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [Text('Em estoque: $quantidadeMax')],
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      child: ElevatedButton(
                        child: Text("Ok",
                            style: TextStyle(color: Color(0XFF1C1C1C))),
                        onPressed: () async {
                          if (tamanhoSelecionado == null) {
                            Toast.show(
                                "Por favor, selecione um tamanho", context,
                                backgroundColor: Color(cor.tema),
                                gravity: Toast.TOP,
                                duration: Toast.LENGTH_LONG);
                          } else if (int.parse(quantidade.text) <= 0) {
                            Toast.show(
                                "Por favor, adicione uma quantidade", context,
                                backgroundColor: Color(cor.tema),
                                gravity: Toast.TOP,
                                duration: Toast.LENGTH_LONG);
                          } else {
                            var valor =
                                valorOriginal * int.parse(quantidade.text);

                            await dbHelper.editarItem(
                                int.parse(quantidade.text),
                                valor,
                                widget.element['descricaoProduto'],
                                tamanhoSelecionado,
                                widget.element['tamanho']);
                            Navigator.pop(context);
                            Navigator.pop(context);
                            Navigator.pushNamed(context, '/carrinho');
                          }
                        },
                        style:
                            ElevatedButton.styleFrom(primary: Color(cor.tema)),
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      child: ElevatedButton(
                        child: Text("Cancelar",
                            style: TextStyle(color: Color(0XFF1C1C1C))),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        style:
                            ElevatedButton.styleFrom(primary: Color(cor.tema)),
                      ),
                    )
                  ],
                );
              })
            ]);
      },
      child: CardCarrinho(
          codigoProduto: widget.element["codigoProduto"],
          id_produto: widget.element['id_produto'],
          descricaoProduto: widget.element['descricaoProduto'],
          valor: widget.element['valor'],
          descricao_pagamento: widget.element['descricao_pagamento'],
          imagem: widget.element['imagem'],
          quantidade: widget.element['quantidade'],
          tamanho: widget.element['tamanho']),
    );
  }
}
