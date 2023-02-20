import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loja_flyinghigh/flutter_flow/flutter_flow_theme.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../widgets/colors.dart';
import '../providers/itens_pedido_list.dart';

Cores cor = Cores();

class RetiradaView extends StatefulWidget {
  const RetiradaView({Key? key}) : super(key: key);
  @override
  _RetiradaViewState createState() => _RetiradaViewState();
}

class _RetiradaViewState extends State<RetiradaView> {
  var formaDeRetirada = 0;
  var tipoPessoa = 0;

  formaRetirada() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(
      () {
        prefs.setInt('formaDeRetirada', formaDeRetirada);
        prefs.setInt('tipoPessoa', tipoPessoa);
      },
    );
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

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(cor.tema),
        toolbarHeight: MediaQuery.of(context).size.height >= 650
            ? MediaQuery.of(context).size.height / 13
            : MediaQuery.of(context).size.height / 11,
        title: Container(
          margin: EdgeInsets.only(top: 20, bottom: 20),
          height: MediaQuery.of(context).size.height / 18,
          child: Row(
            children: [
              Text(
                "Finalizar compra",
                style: GoogleFonts.nanumGothic(
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                    fontSize: 22),
              ),
            ],
          ),
        ),
      ),
      bottomSheet: GestureDetector(
        child: Flushbar(
          backgroundColor: Color(cor.tema),
          messageText: Center(
            child: Text(
              "Prosseguir",
              style: GoogleFonts.openSans(
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                  fontSize: size.height >= 650 ? 24 : 22),
            ),
          ),
          isDismissible: false,
          flushbarPosition: FlushbarPosition.BOTTOM,
        ),
        onTap: () {
          if (formaDeRetirada == 0) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("Por favor, selecione uma opção"),
                duration: Duration(seconds: 1),
              ),
            );
          } else {
            formaRetirada();
            Navigator.pushNamed(context, '/finalizarCompra');
          }
        },
      ),
      backgroundColor: Color(0xffeeeeee),
      body: Container(
        margin: EdgeInsets.only(),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Container(
          //  color: Colors.blue,
          margin: EdgeInsets.only(bottom: 50),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  margin: EdgeInsets.only(top: 30, bottom: 0),
                  child: Center(
                    child: Text(
                      "Você é:",
                      style: GoogleFonts.nanumGothic(
                        fontSize: 28,
                        fontWeight: FontWeight.w700,
                        color: FlutterFlowTheme.of(context).primaryText,
                      ),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Container(
                      width: size.width * 0.4,
                      height: 65,
                      margin: EdgeInsets.all(5),
                      child: Row(children: [
                        Radio(
                          value: 1,
                          onChanged: (value) {
                            setState(
                              () {
                                tipoPessoa = value as int;
                              },
                            );
                          },
                          groupValue: tipoPessoa,
                          toggleable: false,
                          activeColor: Color(cor.tema),
                        ),
                        Text("Pessoa Física",
                            style: FlutterFlowTheme.of(context).subtitle2),
                      ]),
                    ),
                    Container(
                      height: 65,
                      width: size.width * 0.4,
                      margin: EdgeInsets.all(5),
                      child: Row(children: [
                        Radio(
                          value: 2,
                          onChanged: (value) {
                            setState(
                              () {
                                tipoPessoa = value as int;
                              },
                            );
                          },
                          groupValue: tipoPessoa,
                          toggleable: false,
                          activeColor: Color(cor.tema),
                        ),
                        Text("Pessoa Jurídica",
                            style: FlutterFlowTheme.of(context).bodyText2),
                      ]),
                    ),
                  ],
                ),
                Divider(
                  color: FlutterFlowTheme.of(context).secondaryText,
                ),
                Container(
                  margin: EdgeInsets.only(top: 15, bottom: 5),
                  width: size.width * 0.9,
                  child: Center(
                    child: Text(
                      "Escolha entre entrega ou retirada:",
                      style: GoogleFonts.nanumGothic(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: FlutterFlowTheme.of(context).primaryText,
                      ),
                    ),
                  ),
                ),
                Container(
                  width: size.width * 0.9,
                  height: 50,
                  margin: EdgeInsets.symmetric(vertical: 10),
                  child: Row(
                    children: [
                      Radio(
                        value: 1,
                        onChanged: (value) {
                          setState(
                            () {
                              formaDeRetirada = value as int;
                            },
                          );
                        },
                        groupValue: formaDeRetirada,
                        toggleable: false,
                        activeColor: Color(cor.tema),
                      ),
                      Text("Retirar o pedido na loja",
                          style: FlutterFlowTheme.of(context).subtitle2),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Container(
                    width: size.width * 0.9,
                    height: 50,
                    child: Row(
                      children: [
                        Radio(
                          value: 2,
                          onChanged: (value) {
                            setState(
                              () {
                                formaDeRetirada = value as int;
                              },
                            );
                          },
                          groupValue: formaDeRetirada,
                          toggleable: false,
                          activeColor: Color(cor.tema),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              "Receber o pedido pelos Correios",
                              style: FlutterFlowTheme.of(context).subtitle2,
                            ),
                            Align(
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Container(
                                    margin: const EdgeInsets.only(
                                        right: 2, bottom: 2),
                                    child: Text('*Sedex a cobrar',
                                        style: FlutterFlowTheme.of(context)
                                            .bodyText2),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Divider(
                    color: FlutterFlowTheme.of(context).secondaryText,
                  ),
                ),
                Container(
                  margin: EdgeInsets.all(5),
                  height: 125,
                  child: Center(
                    child: Container(
                      margin: EdgeInsets.all(15),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                              'Para maiores esclarecimentos sobre o envio do pedido consulte o vendedor.',
                              style: GoogleFonts.aBeeZee(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black54)),
                          Container(
                            margin: EdgeInsets.all(4),
                            //   child:   Align(
                            // alignment: Alignment.bottomRight,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                GestureDetector(
                                  child: const Image(
                                    image: AssetImage('lib/app/images/wpp.png'),
                                    height: 40,
                                  ),
                                  onTap: () async {
                                    //muda
                                    //Whats
                                    try {
                                      await launch(
                                          'https://api.whatsapp.com/send?phone=556699127896');
                                    } catch (error) {
                                      print(error);
                                    }
                                  },
                                ),
                                //muda
                                Text('(66)9912-7896',
                                    style: GoogleFonts.aBeeZee(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black54))
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  decoration: const BoxDecoration(
                    color: Color(0xffe0f2f1),
                    borderRadius: BorderRadius.all(Radius.circular(18)),
                  ),
                ),
                const SizedBox(
                  height: 15,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
