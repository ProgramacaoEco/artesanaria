import 'package:loja_flyinghigh/app/model/produto.dart';
import 'package:loja_flyinghigh/utils/constants.dart';

import '../widgets/bottomSheet.dart';
import '../../database/database.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/itensCarrinho.dart';
import 'package:flutter/services.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:number_inc_dec/number_inc_dec.dart';
import 'package:another_flushbar/flushbar.dart';
import '../widgets/colors.dart';

Cores cor = Cores();

class DescricaoProdutoView extends StatefulWidget {
  final Produto produto;
  const DescricaoProdutoView(this.produto, {Key? key}) : super(key: key);
  @override
  _DescricaoProdutoView createState() => _DescricaoProdutoView();
}

class _DescricaoProdutoView extends State<DescricaoProdutoView> {
  @override
  void initState() {
    super.initState();
    carregarValores();
    //ChecarInternet().checarConexao(context);
  }

  @override
  void dispose() {
    super.dispose();
    //ChecarInternet().listener.cancel();
  }

  int quantidadeMax = 0;
  //Declarando variáveis locais, que irão receber valores futuramente
  //Para o SharedPreferences
  // int id_produto = 0;
  // var codigoProduto = " ";
  // var descricao_pagamento = " ";
  // var descricaoProduto = " ";
  // var valor;
  // var value;
  // List tamanhos = [];
  List imagens = [];

  //Para métodos locais
  List<Widget> imagensCarrousel = [];
  var tamanhoSelecionado;
  bool shouldPop = true;

  //Instânciando flushkey, dbHelper(database) e um Text Controller
  static var flushkey = GlobalKey();
  final dbHelper = DatabaseHelper.instance;
  TextEditingController quantidade = TextEditingController();

  static obterTamanho() {
    final RenderBox renderBox =
        flushkey.currentContext!.findRenderObject() as RenderBox;
    final size = renderBox.size.height;
    return size;
  }

  fontesBotao(BuildContext context) {
    if (MediaQuery.of(context).size.height >= 650) {
      return 24.0;
    } else {
      return 22.0;
    }
  }

  fontes(BuildContext context) {
    if (MediaQuery.of(context).size.height >= 650) {
      return 18.0;
    } else {
      return 17.0;
    }
  }

  getQtde(quantidade) {
    setState(() {
      quantidadeMax = quantidade;
    });
    print('mudou ${quantidade}');
  }

  //Esse método irá receber os valores passados pelo card do produto, através do SharedPreferences,
  //além de montar o carrousel de imagens
  carregarValores() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(
      () {
        imagens = prefs.getStringList('imagens')!;
      },
    );
    if (imagens[0] == null ||
        imagens.isEmpty ||
        imagens.length == 0 ||
        imagens == []) {
      imagensCarrousel.add(
        Container(
          // margin: EdgeInsets.all(15),
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('lib/images/noImage.png'),
              fit: BoxFit.cover,
            ),
          ),
        ),
      );
    } else {
      for (int i = 0; i < imagens.length; i++) {
        imagensCarrousel.add(
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(
                    '${Constants.API_BASIC_ROUTE}/storage/app/${imagens[i]}'),
                fit: BoxFit.cover,
              ),
            ),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    SystemChrome.setPreferredOrientations(
      [
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ],
    );
    return WillPopScope(
      child: Scaffold(
        // bottomSheet:
        // GestureDetector(
        //   child: Flushbar(
        //     key: flushkey,
        //     backgroundColor: Color(cor.tema),
        //     borderRadius: const BorderRadius.all(Radius.circular(30)),
        //     messageText: Center(
        //       child: Text(
        //         "Comprar",
        //         style: GoogleFonts.openSans(
        //             fontWeight: FontWeight.w600,
        //             color: Colors.white,
        //             fontSize: fontesBotao(context)),
        //       ),
        //     ),
        //     isDismissible: false,
        //     //flushbarPosition: FlushbarPosition.BOTTOM,
        //     flushbarStyle: FlushbarStyle.GROUNDED,
        //     // blockBackgroundInteraction: true,
        //   ),
        //   onTap: () {
        //     //verifica se o usuário selecionou o tamanho
        //     if (tamanhoSelecionado == null) {
        //       ScaffoldMessenger.of(context).showSnackBar(
        //         const SnackBar(
        //           content: Text("Por favor, insira um tamanho"),
        //           duration: Duration(milliseconds: 1500),
        //         ),
        //       );
        //       //verifica se o usuário selecionou a quantidade
        //     } else if (int.parse(quantidade.text) <= 0) {
        //       ScaffoldMessenger.of(context).showSnackBar(
        //         const SnackBar(
        //           content: Text("Por favor, insira uma quantidade"),
        //           duration: Duration(milliseconds: 1500),
        //         ),
        //       );
        //       //Se tiver selecionado tamanho e quantidade, ele joga uma caixa
        //       // dialogo, com dois botôes: finalizar compra (leva para /carrinho)
        //       //ou continuar comprando, que leva para /home
        //     } else {
        //       showDialog(
        //         context: context,
        //         builder: (_) => AlertDialog(
        //           title: const Text("O que gostaria de fazer?"),
        //           actions: [
        //             SizedBox(
        //               width: MediaQuery.of(context).size.width,
        //               child: ElevatedButton(
        //                 onPressed: () async {
        //                   var itemExistente = await dbHelper.obterItemExistente(
        //                       widget.produto.descricaoProduto,
        //                       tamanhoSelecionado);
        //                   if (itemExistente == null ||
        //                       itemExistente.isEmpty ||
        //                       itemExistente == []) {
        //                     var valor = widget.produto.valor *
        //                         int.parse(quantidade.text).toInt();
        //                     Item itemCarrinho = Item(
        //                       id_produto: widget.produto.id_produto,
        //                       descricaoProduto: widget.produto.descricaoProduto,
        //                       codigoProduto: widget.produto.codigoProduto,
        //                       valor: valor,
        //                       descricao_pagamento:
        //                           widget.produto.descricao_pagamento,
        //                       quantidade: quantidade.text,
        //                       tamanho: tamanhoSelecionado,
        //                       imagem: widget.produto.imagens.isEmpty ||
        //                               widget.produto.imagens == null ||
        //                               widget.produto.imagens.length <= 0 ||
        //                               widget.produto.imagens == []
        //                           ? null
        //                           : widget.produto.imagens[0],
        //                     );

        //                     //insere os itens no carrinho
        //                     await dbHelper.insert(
        //                       itemCarrinho.toMap(),
        //                     );
        //                     ScaffoldMessenger.of(context).showSnackBar(
        //                       const SnackBar(
        //                         content: Text("Item inserido com sucesso."),
        //                         duration: Duration(seconds: 1),
        //                       ),
        //                     );
        //                   } else {
        //                     await dbHelper.verificarItemDuplicado(
        //                         int.parse(quantidade.text),
        //                         widget.produto.valor,
        //                         widget.produto.descricaoProduto,
        //                         tamanhoSelecionado);
        //                     ScaffoldMessenger.of(context).showSnackBar(
        //                       const SnackBar(
        //                         content: Text("Item inserido com sucesso."),
        //                         duration: Duration(seconds: 1),
        //                       ),
        //                     );
        //                   }

        //                   Navigator.pop(context);
        //                   Navigator.pop(context);
        //                 },
        //                 child: const Text("Continuar comprando"),
        //                 style: ElevatedButton.styleFrom(
        //                   primary: Color(cor.tema),
        //                 ),
        //               ),
        //             ),
        //             SizedBox(
        //               width: MediaQuery.of(context).size.width,
        //               child: ElevatedButton(
        //                 onPressed: () async {
        //                   var itemExistente = await dbHelper.obterItemExistente(
        //                       widget.produto.descricaoProduto,
        //                       tamanhoSelecionado);
        //                   if (itemExistente == null ||
        //                       itemExistente.isEmpty ||
        //                       itemExistente == []) {
        //                     var valor = widget.produto.valor *
        //                         int.parse(quantidade.text).toInt();
        //                     Item itemCarrinho = Item(
        //                         id_produto: widget.produto.id_produto,
        //                         descricaoProduto:
        //                             widget.produto.descricaoProduto,
        //                         valor: valor,
        //                         descricao_pagamento:
        //                             widget.produto.descricao_pagamento,
        //                         quantidade: quantidade.text,
        //                         tamanho: tamanhoSelecionado,
        //                         imagem: widget.produto.imagens.isEmpty ||
        //                                 widget.produto.imagens == null ||
        //                                 widget.produto.imagens.length <= 0 ||
        //                                 widget.produto.imagens == []
        //                             ? null
        //                             : widget.produto.imagens,
        //                         codigoProduto: widget.produto.codigoProduto);
        //                     await dbHelper.insert(
        //                       itemCarrinho.toMap(),
        //                     );
        //                     ScaffoldMessenger.of(context).showSnackBar(
        //                       const SnackBar(
        //                         content: Text("Item inserido com sucesso."),
        //                         duration: Duration(seconds: 1),
        //                       ),
        //                     );
        //                   } else {
        //                     await dbHelper.verificarItemDuplicado(
        //                         int.parse(quantidade.text),
        //                         widget.produto.valor,
        //                         widget.produto.descricaoProduto,
        //                         tamanhoSelecionado);
        //                     ScaffoldMessenger.of(context).showSnackBar(
        //                       const SnackBar(
        //                         content: Text("Item inserido com sucesso."),
        //                         duration: Duration(seconds: 1),
        //                       ),
        //                     );
        //                   }
        //                   Navigator.pop(context);
        //                   Navigator.pop(context);
        //                   Navigator.pushNamed(context, "/carrinho");
        //                 },
        //                 child: Text("Finalizar a compra"),
        //                 style: ElevatedButton.styleFrom(
        //                   primary: Color(0xFFC02727),
        //                 ),
        //               ),
        //             ),
        //           ],
        //         ),
        //       );
        //     }
        //   },
        // ),
        appBar: AppBar(
          toolbarHeight: MediaQuery.of(context).size.height >= 650
              ? MediaQuery.of(context).size.height / 13
              : MediaQuery.of(context).size.height / 11,
          title: Container(
            margin: EdgeInsets.only(top: 20, bottom: 20),
            height: MediaQuery.of(context).size.height / 11,
            child: Image.asset(
              'assets/logoamandaraupp.jpeg',
            ),
          ),
          centerTitle: true,
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
        ),
        body: Container(
          margin: EdgeInsets.only(),
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                CarouselSlider(
                    options: CarouselOptions(
                      initialPage: 0,
                      enableInfiniteScroll: true,
                      autoPlay: true,
                      autoPlayInterval: Duration(seconds: 8),
                      scrollDirection: Axis.horizontal,
                      autoPlayCurve: Curves.fastOutSlowIn,
                      // enlargeCenterPage: true,
                      enlargeStrategy: CenterPageEnlargeStrategy.height,
                      autoPlayAnimationDuration: Duration(milliseconds: 800),
                    ),
                    items: imagensCarrousel),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        child: Text(
                          widget.produto.descricaoProduto,
                          style: GoogleFonts.nanumGothic(
                              fontWeight: FontWeight.bold,
                              fontSize: fontes(context)),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 20),
                  child: Text("Em até 1x de R\$" + widget.produto.valor.toString(),
                      style: GoogleFonts.nanumGothic(
                          fontWeight: FontWeight.w500, fontSize: 16)),
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                  child: Column(
                    children: [
                      Container(
                          margin: EdgeInsets.symmetric(vertical: 5),
                          child: DropdownButtonFormField(
                            hint: Text("Selecione o tamanho"),
                            items: widget.produto.quantidades.map(
                              (tamanho) {
                                print(tamanho);
                                return DropdownMenuItem(
                                  child: Text(tamanho['tamanho']),
                                  value: tamanho['tamanho'],
                                  onTap: () {
                                    setState(() {
                                      quantidadeMax = tamanho['quantidade'];
                                    });
                                    print('mudou ${tamanho['quantidade']}');
                                  },
                                );
                              },
                            ).toList(),
                            onChanged: (value) {
                              setState(() {
                                tamanhoSelecionado = value;
                              });
                            },
                            value: tamanhoSelecionado,
                          )),
                      Container(
                        child: Text("Quantidade",
                            style: GoogleFonts.nanumGothic(fontSize: 15)),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [Text('Em estoque: $quantidadeMax')],
                      ),
                      Container(
                        child: NumberInputWithIncrementDecrement(
                          controller: quantidade,
                          incIcon: Icons.add,
                          decIcon: Icons.remove,
                          max: quantidadeMax,
                          autovalidate: true,
                        ),
                        margin: EdgeInsets.symmetric(vertical: 15),
                      ),
                      // Container(
                      //   height: MediaQuery.of(context).size.height / 14
                      // ),
                    ],
                  ),
                ),
                GestureDetector(
                  child: Flushbar(
                    key: flushkey,
                    backgroundColor: Color(cor.tema),
                    borderRadius: const BorderRadius.all(Radius.circular(30)),
                    messageText: Center(
                      child: Text(
                        "Comprar",
                        style: GoogleFonts.openSans(
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                            fontSize: fontesBotao(context)),
                      ),
                    ),
                    isDismissible: false,
                    flushbarPosition: FlushbarPosition.BOTTOM,
                    flushbarStyle: FlushbarStyle.GROUNDED,
                    // blockBackgroundInteraction: true,
                  ),
                  onTap: () {
                    //verifica se o usuário selecionou o tamanho
                    if (tamanhoSelecionado == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Por favor, insira um tamanho"),
                          duration: Duration(milliseconds: 1500),
                        ),
                      );
                      //verifica se o usuário selecionou a quantidade
                    } else if (int.parse(quantidade.text) <= 0 ||
                        quantidadeMax < int.parse(quantidade.text)) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content:
                              Text("Por favor, insira uma quantidade correta"),
                          duration: Duration(milliseconds: 1500),
                        ),
                      );
                      //Se tiver selecionado tamanho e quantidade, ele joga uma caixa
                      // dialogo, com dois botôes: finalizar compra (leva para /carrinho)
                      //ou continuar comprando, que leva para /home
                    } else {
                      showDialog(
                        context: context,
                        builder: (_) => AlertDialog(
                          title: const Text("O que gostaria de fazer?"),
                          actions: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width,
                              child: ElevatedButton(
                                onPressed: () async {
                                  var itemExistente =
                                      await dbHelper.obterItemExistente(
                                          widget.produto.descricaoProduto,
                                          tamanhoSelecionado);
                                  if (itemExistente == null ||
                                      itemExistente.isEmpty ||
                                      itemExistente == []) {
                                    var valor = widget.produto.valor *
                                        int.parse(quantidade.text).toInt();
                                    Item itemCarrinho = Item(
                                      id_produto: widget.produto.id_produto,
                                      descricaoProduto:
                                          widget.produto.descricaoProduto,
                                      codigoProduto:
                                          widget.produto.codigoProduto,
                                      valor: valor,
                                      descricao_pagamento:
                                          widget.produto.descricao_pagamento,
                                      quantidade: quantidade.text,
                                      tamanho: tamanhoSelecionado,
                                      imagem: widget.produto.imagens.isEmpty ||
                                              widget.produto.imagens == null ||
                                              widget.produto.imagens.length <=
                                                  0 ||
                                              widget.produto.imagens == []
                                          ? null
                                          : widget.produto.imagens[0],
                                    );

                                    //insere os itens no carrinho
                                    await dbHelper.insert(
                                      itemCarrinho.toMap(),
                                    );
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content:
                                            Text("Item inserido com sucesso."),
                                        duration: Duration(seconds: 1),
                                      ),
                                    );
                                  } else {
                                    await dbHelper.verificarItemDuplicado(
                                        int.parse(quantidade.text),
                                        widget.produto.valor,
                                        widget.produto.descricaoProduto,
                                        tamanhoSelecionado);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content:
                                            Text("Item inserido com sucesso."),
                                        duration: Duration(seconds: 1),
                                      ),
                                    );
                                  }

                                  Navigator.pop(context);
                                  Navigator.pop(context);
                                },
                                child: const Text("Continuar comprando"),
                                style: ElevatedButton.styleFrom(
                                  primary: Color(0XFF1C1C1C),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width,
                              child: ElevatedButton(
                                onPressed: () async {
                                  var itemExistente =
                                      await dbHelper.obterItemExistente(
                                          widget.produto.descricaoProduto,
                                          tamanhoSelecionado);
                                  if (itemExistente == null ||
                                      itemExistente.isEmpty ||
                                      itemExistente == []) {
                                    var valor = widget.produto.valor *
                                        int.parse(quantidade.text).toInt();
                                    Item itemCarrinho = Item(
                                        id_produto: widget.produto.id_produto,
                                        descricaoProduto:
                                            widget.produto.descricaoProduto,
                                        valor: valor,
                                        descricao_pagamento:
                                            widget.produto.descricao_pagamento,
                                        quantidade: quantidade.text,
                                        tamanho: tamanhoSelecionado,
                                        imagem:
                                            widget.produto.imagens.isEmpty ||
                                                    widget.produto.imagens ==
                                                        null ||
                                                    widget.produto.imagens
                                                            .length <=
                                                        0 ||
                                                    widget.produto.imagens == []
                                                ? null
                                                : widget.produto.imagens,
                                        codigoProduto:
                                            widget.produto.codigoProduto);
                                    await dbHelper.insert(
                                      itemCarrinho.toMap(),
                                    );
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content:
                                            Text("Item inserido com sucesso."),
                                        duration: Duration(seconds: 1),
                                      ),
                                    );
                                  } else {
                                    await dbHelper.verificarItemDuplicado(
                                        int.parse(quantidade.text),
                                        widget.produto.valor,
                                        widget.produto.descricaoProduto,
                                        tamanhoSelecionado);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content:
                                            Text("Item inserido com sucesso."),
                                        duration: Duration(seconds: 1),
                                      ),
                                    );
                                  }
                                  Navigator.pop(context);
                                  Navigator.pop(context);
                                  Navigator.pushNamed(context, "/carrinho");
                                },
                                child: Text("Finalizar a compra"),
                                style: ElevatedButton.styleFrom(
                                  primary: Color(0xFFC02727),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                  },
                )
              ],
            ),
          ),
        ),
      ),
      onWillPop: () async {
        return shouldPop;
      },
    );
  }
}
