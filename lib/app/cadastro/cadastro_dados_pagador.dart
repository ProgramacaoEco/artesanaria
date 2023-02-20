// ignore_for_file: file_names

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

class CadastroPagadorView extends StatefulWidget {
  const CadastroPagadorView({Key? key}) : super(key: key);

  @override
  _CadastroPagadorView createState() => _CadastroPagadorView();
}

class _CadastroPagadorView extends State<CadastroPagadorView> {
  @override
  void initState() {
    super.initState();
    //ChecarInternet().checarConexao(context);
  }

  @override
  void dispose() {
    super.dispose();
    //ChecarInternet().listener.cancel();
  }

  late DateTime _dateTime;

// TextEditingController dataNascimento = TextEditingController();
  var sexo;

  var url = Uri.https('${Constants.API_ROOT_ROUTE}',
      '${Constants.API_FOLDERS}cadastroPrelogin');

  DatabaseHelper dbHelper = DatabaseHelper.instance;

  final _formKey = GlobalKey<FormState>();

  AsyncMemoizer memoizerValores = AsyncMemoizer();

  RegExp regExp = RegExp(
      r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$",
      caseSensitive: false,
      multiLine: false);

  guardarValores() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('dataNascimento', _dateTime.toString());
    prefs.setString('sexo', sexo);

    Navigator.pushNamed(context, '/cadastroEndereco');
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
            height: MediaQuery.of(context).size.height / 2.6,
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
                        'Dados de Cobrança',
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
                          //  Align(
                          //    alignment: Alignment.center,
                          //  ),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  margin: EdgeInsets.only(),
                                  child: Text(
                                    '  Data de Nascimento',
                                    style: TextStyle(
                                        fontSize: 18,
                                        color: Colors.grey.shade700),
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: Container(
                                    margin: const EdgeInsets.only(
                                        top: 10, right: 25),
                                    width:
                                        MediaQuery.of(context).size.width / 5,
                                    child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          primary: Color(cor.tema),
                                        ),
                                        child: Icon(Icons.calendar_today_sharp),
                                        onPressed: () {
                                          showDatePicker(
                                                  context: context,
                                                  initialDate: DateTime.now(),
                                                  firstDate: DateTime(1900),
                                                  lastDate: DateTime.now())
                                              .then((dataNascimento) {
                                            setState(() {
                                              _dateTime = dataNascimento!;
                                            });
                                          });
                                        }),
                                  ),
                                ),
                              ]),
                          Container(
                            margin: const EdgeInsets.symmetric(vertical: 5),
                            child: DropdownButtonFormField(
                              hint: const Text("  Sexo"),
                              items: const [
                                DropdownMenuItem(
                                    child: Text('Masculino'),
                                    value: 'Masculino'),
                                DropdownMenuItem(
                                    child: Text('Feminino'), value: 'Feminino'),
                              ],
                              onChanged: (value) {
                                setState(
                                  () {
                                    sexo = value;
                                  },
                                );
                              },
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
                                  width: MediaQuery.of(context).size.width / 5,
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
            ),
          ),
        ),
      ),
    );
  }
}
