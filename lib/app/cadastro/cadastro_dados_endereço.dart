// ignore_for_file: file_names

import 'dart:convert';

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

class CadastroEnderecoView extends StatefulWidget {
  const CadastroEnderecoView({Key? key}) : super(key: key);

  @override
  _CadastroEnderecoViewState createState() => _CadastroEnderecoViewState();
}

class _CadastroEnderecoViewState extends State<CadastroEnderecoView> {
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

  var nome;
  var telefone;
  var telefoneSplit;
  var ddd;
  var email;
  var senha;
  var dataNascimento;
  var cpf;
  var sexo;
  var estadoCivil;
  var accessToken;
  bool fez = false;

  var pagadorID = 'f9624b84-a424-455e-a47c-7af08f965f7d';

  InputDecoration decoMuni = InputDecoration(
    focusedBorder: UnderlineInputBorder(
      borderSide: BorderSide(
        color: Color(cor.tema),
      ),
    ),
    hintText: "  Município",
    border: const UnderlineInputBorder(
      borderRadius: BorderRadius.vertical(
        bottom: Radius.circular(0.2),
      ),
    ),
  );
  InputDecoration decoBairro = InputDecoration(
    focusedBorder: UnderlineInputBorder(
      borderSide: BorderSide(
        color: Color(cor.tema),
      ),
    ),
    hintText: "  Bairro",
    border: const UnderlineInputBorder(
      borderRadius: BorderRadius.vertical(
        bottom: Radius.circular(0.2),
      ),
    ),
  );
  InputDecoration decoLogra = InputDecoration(
    focusedBorder: UnderlineInputBorder(
      borderSide: BorderSide(
        color: Color(cor.tema),
      ),
    ),
    hintText: "  Logradouro",
    border: const UnderlineInputBorder(
      borderRadius: BorderRadius.vertical(
        bottom: Radius.circular(0.2),
      ),
    ),
  );

  InputDecoration decoNum = InputDecoration(
    focusedBorder: UnderlineInputBorder(
      borderSide: BorderSide(
        color: Color(cor.tema),
      ),
    ),
    hintText: "  Número",
    border: const UnderlineInputBorder(
      borderRadius: BorderRadius.vertical(
        bottom: Radius.circular(0.2),
      ),
    ),
  );

  InputDecoration decoCompl = InputDecoration(
    focusedBorder: UnderlineInputBorder(
      borderSide: BorderSide(
        color: Color(cor.tema),
      ),
    ),
    hintText: "  Complemento",
    border: const UnderlineInputBorder(
      borderRadius: BorderRadius.vertical(
        bottom: Radius.circular(0.2),
      ),
    ),
  );

  InputDecoration decoCEP = InputDecoration(
    focusedBorder: UnderlineInputBorder(
      borderSide: BorderSide(
        color: Color(cor.tema),
      ),
    ),
    hintText: "  CEP",
    border: const UnderlineInputBorder(
      borderRadius: BorderRadius.vertical(
        bottom: Radius.circular(0.2),
      ),
    ),
  );

  TextEditingController municipio = TextEditingController();
  TextEditingController bairro = TextEditingController();
  TextEditingController logradouro = TextEditingController();
  TextEditingController numero = TextEditingController();
  TextEditingController complemento = TextEditingController();
  MaskedTextController cep = MaskedTextController(mask: "00000-000");

  var url = Uri.https('${Constants.API_ROOT_ROUTE}',
      '${Constants.API_FOLDERS}cadastroPrelogin');

  var urlTokenPagoZap = Uri.https('dev.app.pagozap.com.br:3000', '/jwt/Token');

  var urlCadastroPagadorPagoZap =
      Uri.https('dev.app.pagozap.com.br:3000', '/api/Pagador/Save');

  DatabaseHelper dbHelper = DatabaseHelper.instance;

  AsyncMemoizer memoizerValores = AsyncMemoizer();

  final _formKey = GlobalKey<FormState>();

  RegExp regExp = RegExp(
      r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$",
      caseSensitive: false,
      multiLine: false);

  carregarValores() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    nome = prefs.getString('nome');
    email = prefs.getString('email');
    telefone = prefs.getString('telefone');
    senha = prefs.getString('senha');

    cpf = prefs.getString('cpf');
    dataNascimento = prefs.getString('dataNascimento');
    estadoCivil = prefs.getString('estadoCivil');
    sexo = prefs.getString('sexo');
  }

  // return await memoizerValores.runOnce(
  enviarValores() async {
    http.Response response;
    return await memoizerValores.runOnce(
      () async {
        try {
          response = await http.post(
            url,
            body: {
              "nome": nome,
              "email": email,
              "telefone": telefone,
              "senha": senha,
              "uf": "RS",
              "municipio": municipio.text,
              "cep": cep.text,
              "complemento": complemento.text,
              "bairro": bairro.text,
              "logradouro": logradouro.text,
              "numero": numero.text
            },
          );

          if (response.statusCode == 200 || response.statusCode == 201) {
            print(response.body);
            Toast.show("Dados enviados com sucesso", context);
            Navigator.pop(context);
            Navigator.pushNamed(context, '/home');
          } else {
            print(response.body);
            Toast.show("Ocorreu um erro ao enviar os dados", context);
          }
        } catch (error) {
          print(error);
        }
      },
    );
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
              height: MediaQuery.of(context).size.height / 1.2,
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
                          'Dados de Endereço',
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
                                  decoration: decoMuni,
                                  controller: municipio,
                                  autocorrect: false,
                                  enableSuggestions: false,
                                  keyboardType: TextInputType.text,
                                  validator: (value) {
                                    if (value == null ||
                                        value.isEmpty ||
                                        value.length < 3) {
                                      return "Insira uma cidade";
                                    }
                                    return null;
                                  }),
                            ),
                            Container(
                              margin: const EdgeInsets.only(top: 7),
                              child: TextFormField(
                                  decoration: decoBairro,
                                  controller: bairro,
                                  autocorrect: false,
                                  enableSuggestions: false,
                                  keyboardType: TextInputType.text,
                                  validator: (value) {
                                    if (value == null ||
                                        value.isEmpty ||
                                        value.length < 3) {
                                      return "Insira seu bairro";
                                    }
                                    return null;
                                  }),
                            ),
                            Container(
                              margin: const EdgeInsets.only(top: 7),
                              child: TextFormField(
                                  decoration: decoLogra,
                                  controller: logradouro,
                                  autocorrect: false,
                                  enableSuggestions: false,
                                  keyboardType: TextInputType.text,
                                  validator: (value) {
                                    if (value == null ||
                                        value.isEmpty ||
                                        value.length < 3) {
                                      return "Insira seu logradouro";
                                    }
                                    return null;
                                  }),
                            ),
                            Container(
                              margin: const EdgeInsets.only(top: 7),
                              child: TextFormField(
                                  decoration: decoNum,
                                  controller: numero,
                                  autocorrect: false,
                                  enableSuggestions: false,
                                  keyboardType: TextInputType.number,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return "Insira seu número residencial";
                                    }
                                    return null;
                                  }),
                            ),
                            Container(
                              margin: const EdgeInsets.only(top: 7),
                              child: TextFormField(
                                  decoration: decoCompl,
                                  controller: complemento,
                                  autocorrect: false,
                                  enableSuggestions: false,
                                  keyboardType: TextInputType.text,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return "Insira um complemento";
                                    }
                                    return null;
                                  }),
                            ),
                            Container(
                              margin: const EdgeInsets.only(top: 7),
                              child: TextFormField(
                                  decoration: decoCEP,
                                  controller: cep,
                                  autocorrect: false,
                                  enableSuggestions: false,
                                  keyboardType: TextInputType.text,
                                  validator: (value) {
                                    if (value == null ||
                                        value.isEmpty ||
                                        value.length < 9) {
                                      return "Insira seu CEP (8 dígitos)";
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
                                    margin: const EdgeInsets.only(
                                        top: 15, left: 15),
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
                                    margin: const EdgeInsets.only(
                                        top: 15, right: 25),
                                    child: ElevatedButton(
                                        onPressed: () async {
                                          if (_formKey.currentState!
                                              .validate()) {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              const SnackBar(
                                                  content:
                                                      Text('Processando...')),
                                            );
                                            enviarValores();
                                          }
                                        },
                                        child: const Icon(Icons.arrow_forward),
                                        style: ElevatedButton.styleFrom(
                                          primary: Color(cor.tema),
                                        )),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              )),
        ),
      ),
    );
  }
}
