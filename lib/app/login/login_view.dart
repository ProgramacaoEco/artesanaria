// ignore_for_file: import_of_legacy_library_into_null_safe

import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:loja_flyinghigh/utils/constants.dart';
import 'package:toast/toast.dart';
import 'package:http/http.dart' as http;

import '../widgets/colors.dart';
import '../../database/database.dart';

Cores cor = Cores();

class _LoginView extends State<LoginView> {
  InputDecoration decoCelular = InputDecoration(
    focusedBorder: UnderlineInputBorder(
      borderSide: BorderSide(
        color: Color(cor.tema),
      ),
    ),
    hintText: "  Número de telefone",
    border: const UnderlineInputBorder(
      borderRadius: BorderRadius.vertical(
        bottom: Radius.circular(0.2),
      ),
    ),
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

  MaskedTextController celular = MaskedTextController(mask: "(00)00000-0000");
  TextEditingController senha = TextEditingController();

  var url = Uri.https('${Constants.API_ROOT_ROUTE}',
      '${Constants.API_FOLDERS}cadastroPrelogin');

  var urlLoggin = Uri.https('${Constants.API_ROOT_ROUTE}',
      '${Constants.API_FOLDERS}cadastroPrelogin');

  DatabaseHelper dbHelper = DatabaseHelper.instance;

  AsyncMemoizer memoizerValores = AsyncMemoizer();

  RegExp regExp = RegExp(
      r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$",
      caseSensitive: false,
      multiLine: false);

  logarUser() async {
    http.Response response;

    try {
      response = await http.post(urlLoggin,
          body: {"telefone": celular.text, "senha": senha.text});

      if (response.statusCode == 200 || response.statusCode == 201) {
        print(response.body);
        Toast.show("Login realizado com sucesso!", context);
        Navigator.pop(context);
      } else {
        print(response.body);
        Toast.show("Ocorreu um erro ao enviar os dados", context);
      }
    } catch (error) {
      print(error);
    }
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
        automaticallyImplyLeading: false,
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
      ),
      body: Container(
        // margin: EdgeInsets.only(left: 20, right: 20, bottom: 80, top: 80),
        color: Color(cor.corTransp),
        child: Center(
          // alignment: Alignment.cen,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              color: Colors.white,
            ),
            margin: EdgeInsets.only(left: 20, right: 20, bottom: 50),
            height: MediaQuery.of(context).size.height / 2.7,
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
                        'Login',
                        style: TextStyle(
                          fontSize: 30,
                          color: Color(cor.tema),
                        ),
                      ),
                    ),
                  ),
                  SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Column(
                      children: [
                        Align(
                          alignment: Alignment.center,
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 5),
                          child: TextField(
                            decoration: decoCelular,
                            controller: celular,
                            autocorrect: false,
                            enableSuggestions: false,
                            keyboardType: TextInputType.text,
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 5),
                          child: TextField(
                            decoration: decoSenha,
                            controller: senha,
                            autocorrect: false,
                            enableSuggestions: false,
                            obscureText: true,
                          ),
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
                                  child: Text('Cadastre-se'),
                                  onPressed: () {
                                    Navigator.pushNamed(context, '/cadastro');
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
                                      logarUser();
                                    },
                                    child: const Text('Enviar'),
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
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class LoginView extends StatefulWidget {
  State<StatefulWidget> createState() {
    return _LoginView();
  }
}
