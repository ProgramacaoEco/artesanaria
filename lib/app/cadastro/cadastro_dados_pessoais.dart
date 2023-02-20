import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:loja_flyinghigh/utils/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
import 'package:http/http.dart' as http;

import '../widgets/colors.dart';
import '../../database/database.dart';

Cores cor = Cores();

class CadastroView extends StatefulWidget {
  const CadastroView({Key? key}) : super(key: key);

  @override
  _CadastroViewState createState() => _CadastroViewState();
}

class _CadastroViewState extends State<CadastroView> {
  InputDecoration decoNome = InputDecoration(
    focusedBorder: UnderlineInputBorder(
      borderSide: BorderSide(
        color: Color(cor.tema),
      ),
    ),
    hintText: "  Nome Completo",
    border: const UnderlineInputBorder(
      borderRadius: BorderRadius.vertical(
        bottom: Radius.circular(0.2),
      ),
    ),
  );
  InputDecoration decoEmail = InputDecoration(
    focusedBorder: UnderlineInputBorder(
      borderSide: BorderSide(
        color: Color(cor.tema),
      ),
    ),
    hintText: "  E-mail",
    border: const UnderlineInputBorder(
      borderRadius: BorderRadius.vertical(
        bottom: Radius.circular(0.2),
      ),
    ),
  );
  InputDecoration decoCelular = InputDecoration(
    focusedBorder: UnderlineInputBorder(
      borderSide: BorderSide(
        color: Color(cor.tema),
      ),
    ),
    hintText: "  DDD + Celular",
    border: const UnderlineInputBorder(
      borderRadius: BorderRadius.vertical(
        bottom: Radius.circular(0.2),
      ),
    ),
  );
  InputDecoration decoDDD = InputDecoration(
    focusedBorder: UnderlineInputBorder(borderSide: BorderSide()),
  );

  InputDecoration decoSenha = InputDecoration(
    focusedBorder: UnderlineInputBorder(
      borderSide: BorderSide(
        color: Color(cor.tema),
      ),
    ),
    hintText: "  Senha",
    border: const UnderlineInputBorder(
      borderRadius: BorderRadius.vertical(
        bottom: Radius.circular(0.2),
      ),
    ),
  );

  TextEditingController nome = TextEditingController();
  TextEditingController email = TextEditingController();
  MaskedTextController celular = MaskedTextController(mask: "(00)00000-0000");
  TextEditingController senha = TextEditingController();

  var url = Uri.https('${Constants.API_ROOT_ROUTE}',
      '${Constants.API_FOLDERS}cadastroPrelogin');

  DatabaseHelper dbHelper = DatabaseHelper.instance;

  AsyncMemoizer memoizerValores = AsyncMemoizer();

  final _formKey = GlobalKey<FormState>();

  RegExp regExp = RegExp(
      r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$",
      caseSensitive: false,
      multiLine: false);

  guardarValores() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('nome', nome.text);
    prefs.setString('email', email.text);
    prefs.setString('telefone', celular.text);
    prefs.setString('senha', senha.text);

    Navigator.pushNamed(context, '/cadastroPagador');
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations(
      [
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ],
    );
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Center(
          child: Container(
            margin: EdgeInsets.only(top: 20, bottom: 20),
            height: MediaQuery.of(context).size.height / 18,
            child: Image.asset(
              'lib/app/images/ecoimg.png',
            ),
          ),
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(cor.cCinza1),
                Color(cor.cCinza2),
                Color(cor.cCinza3),
              ],
            ),
          ),
        ),
        automaticallyImplyLeading: false,
      ),
      body: Container(
        color: Color(cor.corTransp),
        child: Center(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              color: Colors.white,
            ),
            margin: EdgeInsets.only(left: 20, right: 20),
            height: MediaQuery.of(context).size.height / 1.5,
            child: Container(
              margin: EdgeInsets.all(10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Align(
                    alignment: Alignment.topCenter,
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 25),
                      child: Text(
                        'Cadastro',
                        style: TextStyle(
                          fontSize: 30,
                          color: Color(cor.tema),
                        ),
                      ),
                    ),
                  ),
                  SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          Align(
                            alignment: Alignment.center,
                          ),
                          Container(
                            margin: const EdgeInsets.only(top: 7),
                            child: TextFormField(
                                decoration: decoNome,
                                controller: nome,
                                autocorrect: false,
                                enableSuggestions: false,
                                keyboardType: TextInputType.text,
                                validator: (value) {
                                  if (value == null ||
                                      value.isEmpty ||
                                      value.length <= 5) {
                                    return 'Insira seu nome completo';
                                  }
                                  return null;
                                }),
                          ),
                          Container(
                            margin: const EdgeInsets.only(top: 7),
                            child: TextFormField(
                                decoration: decoEmail,
                                controller: email,
                                autocorrect: false,
                                enableSuggestions: false,
                                keyboardType: TextInputType.emailAddress,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Insira seu email';
                                  }
                                  return null;
                                }),
                          ),
                          Container(
                            margin: const EdgeInsets.only(top: 7),
                            child: TextFormField(
                                decoration: decoCelular,
                                controller: celular,
                                autocorrect: false,
                                enableSuggestions: false,
                                keyboardType: TextInputType.number,
                                validator: (value) {
                                  if (value == null ||
                                      value.isEmpty ||
                                      value.length < 12) {
                                    return 'Insira seu número de telefone';
                                  }
                                  return null;
                                }),
                          ),
                          Container(
                            margin: const EdgeInsets.only(top: 7),
                            child: TextFormField(
                                decoration: decoSenha,
                                controller: senha,
                                autocorrect: false,
                                enableSuggestions: false,
                                obscureText: true,
                                validator: (value) {
                                  if (value == null ||
                                      value.isEmpty ||
                                      value.length < 5) {
                                    return 'A senha deve conter no mínimo 5 caracteres';
                                  }
                                  return null;
                                }),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Align(
                                alignment: Alignment.bottomLeft,
                                child: Container(
                                  margin:
                                      const EdgeInsets.only(top: 15, left: 15),
                                  child: TextButton(
                                    child: Text('Login'),
                                    onPressed: () {
                                      Navigator.pushNamed(context, '/login');
                                    },
                                  ),
                                ),
                              ),
                              Align(
                                alignment: Alignment.bottomRight,
                                child: Container(
                                  margin:
                                      const EdgeInsets.only(top: 15, right: 25),
                                  child: ElevatedButton(
                                      onPressed: () async {
                                        if (_formKey.currentState!.validate()) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            const SnackBar(
                                                content:
                                                    Text('Processing Data')),
                                          );

                                          guardarValores();
                                        }
                                      },
                                      child: const Icon(
                                          Icons.arrow_forward_outlined),
                                      style: ElevatedButton.styleFrom(
                                        primary: Color(cor.tema),
                                      )),
                                ),
                              ),
                              // Align(
                              //   alignment: Alignment.bottomRight,
                              //   child: Container(
                              //   margin: const EdgeInsets.only(top: 15, right: 25),
                              //   child: ElevatedButton(
                              //     onPressed: () async {enviarValores();},
                              //     child: const Text('Enviar'),
                              //     style: ElevatedButton.styleFrom(
                              //     primary:  Color(cor.tema),
                              //   )
                              //   ),
                              // ),
                              // ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
