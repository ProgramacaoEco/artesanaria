import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:loja_flyinghigh/app/model/bairro.dart';
import 'package:loja_flyinghigh/app/providers/bairros_list.dart';
import 'package:loja_flyinghigh/app/providers/itens_pedido_list.dart';
import 'package:loja_flyinghigh/utils/constants.dart';
import 'package:provider/provider.dart';

import '../../database/database.dart';
import 'package:flutter/services.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/colors.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class FinalizarCompra extends StatefulWidget {
  const FinalizarCompra({Key? key}) : super(key: key);
  @override
  FinalizarCompraState createState() => FinalizarCompraState();
}

Cores cor = Cores();
DatabaseHelper dbHelper = DatabaseHelper.instance;

class FinalizarCompraState extends State<FinalizarCompra> {
  //Gerenciamento de estado
  @override
  void initState() {
    super.initState();
    obterItensPedido();
    Provider.of<BairrosList>(context, listen: false).index();
  }

  @override
  void dispose() {
    super.dispose();
    //ChecarInternet().listener.cancel();
  }

  bool _autovalidate = false;
//variaveis dos valores
  var _idBairro;
  late bool selectbool = false;
  var forma;
  var tipoPessoa;
  var bairros = [];
  var itensPedido = [];
  var formaSelecionada;
  var freteSelecionado;
  var bairroSelecionado;
  var cidadeSelecionada;
  late bool carregou;
  var valorTotalCarrinho;
  var pedido = [];
  var busca = 'buscar na loja';
  String pendente = 'pendente';
  var value;

  List<Map> _payment = [
    {"pay": "Dinheiro"},
    {"pay": "Cartão"},
    {"pay": "Pix"}
  ];
  var _selectedPayment;

  var cidades = [];
  var estados = [];
  var estadoSelecionado;

  //variaveis da tela (CPF/CNPJ)
  var campoNum;
  var campoText;
  var campoNome;

  var _nomeBairro = "";
  double _valorFrete = 0.00;

  var _finalValue;

  DatabaseHelper dbHelper = DatabaseHelper.instance;

  late http.Response responsebairro;
  late http.Response responseforma;
  late http.Response responseparcela;
  late http.Response responsepedido;
  late http.Response responsecidade;
  late http.Response responseEstado;

  var urlbairro = Uri.https(
      '${Constants.API_ROOT_ROUTE}', '${Constants.API_FOLDERS}listarBairros');

  var urlforma = Uri.https(
      '${Constants.API_ROOT_ROUTE}', '${Constants.API_FOLDERS}listarFormas');

  var urlCadastroPedido = Uri.parse(
      '${Constants.API_BASIC_ROUTE}${Constants.API_FOLDERS}cadastrarPedido');

  var urlEstado = Uri.https(
      '${Constants.API_ROOT_ROUTE}', '${Constants.API_FOLDERS}getState');

  TextEditingController bairro = TextEditingController();
  var _selectedBairro;

  TextEditingController logradouro = TextEditingController();
  var _rua;

  TextEditingController complemento = TextEditingController();
  var _complemento;

  TextEditingController numero = TextEditingController();
  var _numero;

  TextEditingController nome = TextEditingController();
  String _nome = "";

  MaskedTextController telefone = MaskedTextController(mask: "(00)00000-0000");
  var _telefone;

  MaskedTextController cpf = MaskedTextController(mask: '000.000.000-00');
  var _cpf;

  var _obs;
  late MaskedTextController mascara =
      MaskedTextController(mask: '000.000.000-00');
  GlobalKey<FormFieldState> keyDpBairro = GlobalKey();
  GlobalKey<FormFieldState> keyDpParcelas = GlobalKey();

  final _formKey = GlobalKey<FormState>();
  final _formKey2 = GlobalKey<FormState>();

  var _idPedido;
  var _messageStoreClosed;

  Future<void> getMessageClosedStore() async {
    var url = Uri.https('${Constants.API_ROOT_ROUTE}',
        '${Constants.API_FOLDERS}getStoreStatus');

    await http.get(url).then((response) {
      print(response.body);
      var storeStatus = json.decode(response.body);
      setState(() {});
      _messageStoreClosed = storeStatus['message'];
      print(_messageStoreClosed);
    });
  }

  void showMessageClosedStore(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(_messageStoreClosed),
        actions: <Widget>[
          FlatButton(onPressed: () => Navigator.pop(ctx), child: Text("voltar"))
        ],
      ),
    );
    Navigator.pop(context, '/home');
  }

  obterItensPedido() async {
    itensPedido.clear();
    // final provider = Provider.of<ListaItensPedido>(context, listen: false);
    var itensPedidoList =
        await Provider.of<ListaItensPedido>(context, listen: false).indexErr();

    for (var item in itensPedidoList) {
      itensPedido.add(
        {
          "id_produto": item.idProduto.toString(),
          "valor_unitario": item.valor.toString(),
          "codigoProduto": item.codigoProduto.toString(),
          "descricaoProduto": item.descricaoProduto.toString(),
          "tamanho": item.tamanho.toString(),
          "quantidade": item.quantidade,
        },
      );
    }
    valorTotalCarrinho = await dbHelper.valorTotalCarrinho();
    valorTotalCarrinho = valorTotalCarrinho[0]['sum(valor)']
        .toStringAsFixed(2)
        .replaceAll(".", ",");
  }

  somaFreteValorFinal(double valorFrete) async {
    setState(() {
      _finalValue =
          double.parse(valorTotalCarrinho.replaceAll(",", ".")) + valorFrete;
    });
  }

  cadastroPedido() async {
    print(_idBairro);
    print(_rua);

    responsepedido = await http.post(urlCadastroPedido,
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json"
        },
        body: jsonEncode({
          "itens_pedido": itensPedido.toList(),
          "valor": _finalValue,
          "forma_pagamento": _selectedPayment,
          "nome_cliente": _nome,
          "cpf/cnpj": _cpf,
          "telefone": _telefone,
          "observacao": _obs,
          "data_pedido": null,
          "updated_at": null,
          "status_pedido": "pendente",
          "endereco_entrega": {
            "id_bairro": _idBairro,
            "rua": _rua,
            "numero": _numero,
            "complemento": _complemento,
          }
        }));
    print(responsepedido.body);
    if (responsepedido.statusCode == 200 || responsepedido.statusCode == 201) {
      var data = jsonDecode(responsepedido.body);
      setState(() {
        _idPedido = data['id_pedido'];
      });
      guardarIdPedido(_idPedido);
      dbHelper.limparCarrinho();
      Navigator.pushNamed(context, '/resumoPedido');
    }
    if (responsepedido.statusCode == 499) {
      showMessageClosedStore(context);
    }
    if (responsepedido.statusCode == 500) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('por favor, informe todos os campos obrigatórios')));
    }
  }

  guardarIdPedido(idPedido) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('id_pedido', idPedido);
  }

  guardarDadosEntrega() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('valorTotal', _finalValue.toString());
    prefs.setString('bairro', _selectedBairro.nome.toString());
    prefs.setString('logradouro', logradouro.text);
    prefs.setString('complemento', complemento.text);
    prefs.setString('numero', numero.text);
    prefs.setString('nome', nome.text);
    prefs.setString('telefone', telefone.text);
    prefs.setString('cpf', mascara.text);
    prefs.setString('valorFrete', _valorFrete.toString());
    prefs.setString('formaPagamento', _selectedPayment.toString());
    prefs.setString('rua', _rua.toString());
    prefs.setString('numero', _numero.toString());
    prefs.setString('complemento', _complemento.toString());
  }

  Widget build(BuildContext context) {
    final bairrosProvider = Provider.of<BairrosList>(context);
    List<Bairro> _bairros = bairrosProvider.bairros;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Text(
              "Pedido com entrega",
              style: GoogleFonts.nanumGothic(
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                  fontSize: 22),
            ),
          ],
        ),
        backgroundColor: Color(cor.tema),
        toolbarHeight: MediaQuery.of(context).size.height >= 650
            ? MediaQuery.of(context).size.height / 13
            : MediaQuery.of(context).size.height / 11,
      ),
      body: Container(
        color: Colors.white,
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        margin: const EdgeInsets.only(top: 10, left: 5, right: 5),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Container(
            color: Colors.blueGrey.shade50,
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Container(
                    decoration: const BoxDecoration(
                      color: Colors.white54,
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                    ),
                    height: MediaQuery.of(context).size.height / 10,
                    child: Column(
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Container(
                            margin: const EdgeInsets.only(top: 5, left: 5),
                            child: Text(
                              "Preencha os dados de entrega",
                              style: GoogleFonts.nanumGothic(
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF6c5c54),
                              ),
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.topLeft,
                          child: Container(
                            margin: EdgeInsets.only(top: 2),
                            child: Text(
                              " * - Campos obrigatórios",
                              style: GoogleFonts.nanumGothic(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                      padding: EdgeInsets.only(
                          top: MediaQuery.of(context).size.height * 0.02),
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.95,
                        height: MediaQuery.of(context).size.height * 0.12,
                        color: Colors.white54,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.95,
                              child: DropdownButtonFormField(
                                decoration: InputDecoration(
                                  label: Text('Bairro',
                                      style: TextStyle(fontSize: 21)),
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(5)),
                                ),
                                isExpanded: true,
                                value: _selectedBairro,
                                hint: Padding(
                                  padding: const EdgeInsets.only(left: 1.0),
                                  child: Row(
                                    children: [
                                      Text(_selectedBairro != null
                                          ? _selectedBairro.nome
                                          : "Selecione o bairro"),
                                    ],
                                  ),
                                ),
                                items: _bairros.map((bairro) {
                                  var valorFreteBairro = bairro.valorFrete;
                                  return DropdownMenuItem(
                                    value: bairro,
                                    child: Text(
                                        bairro.nome + " R\$$valorFreteBairro"),
                                  );
                                }).toList(),
                                onChanged: (newValue) {
                                  setState(() {
                                    _selectedBairro = newValue;
                                    _valorFrete = _selectedBairro.valorFrete;
                                    _nomeBairro =
                                        _selectedBairro.nome.toString();
                                    somaFreteValorFinal(_valorFrete);
                                    _idBairro = _selectedBairro.id;
                                  });
                                },
                                validator: (value) {
                                  if (value == null) return;
                                },
                              ),
                            ),
                          ],
                        ),
                      )),
                  SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          margin: const EdgeInsets.only(left: 5),
                          decoration: const BoxDecoration(
                              color: Colors.white54,
                              borderRadius: BorderRadius.all(
                                Radius.circular(5),
                              )),
                          child: TextFormField(
                            controller: logradouro,
                            decoration: InputDecoration(
                              labelText: " Rua*",
                            ),
                            validator: (value) {
                              if (value == null ||
                                  value.isEmpty ||
                                  value.length < 5) {
                                return "Digite uma rua válida";
                              }
                              return null;
                            },
                            onChanged: (value) {
                              setState(() {
                                _rua = value.toString();
                              });
                            },
                          ),
                        ),
                        flex: 2,
                      ),
                      SizedBox(
                        width: 25,
                      ),
                      Expanded(
                          child: Container(
                        margin: const EdgeInsets.only(right: 5),
                        decoration: const BoxDecoration(
                            color: Colors.white54,
                            borderRadius: BorderRadius.all(
                              Radius.circular(5),
                            )),
                        child: TextFormField(
                          controller: numero,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            labelText: " Número*",
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Digite o número residencial";
                            }
                            return null;
                          },
                          onChanged: (value) {
                            setState(() {
                              _numero = value;
                            });
                          },
                        ),
                      )),
                    ],
                  ),

                  SizedBox(height: 20),

                  // DropdownButtonFormField<dynamic>(
                  //   hint: const Text("Selecione a cidade*"),
                  //   items: cidades,
                  //   onChanged: (value) {
                  //     FocusScope.of(context).requestFocus(FocusNode());
                  //     setState(
                  //       () {
                  //         cidadeSelecionada = value;
                  //       },
                  //     );
                  //     print(value);
                  //     obterBairro(value);
                  //   },
                  // ),
                  // DropdownButtonFormField(
                  //   key: keyDpBairro,
                  //   hint: Text("Selecione o bairro*"),
                  //   items: bairros.map(
                  //     (tamanho) {
                  //       return DropdownMenuItem(
                  //           child: Text(tamanho), value: tamanho);
                  //     },
                  //   ).toList(),
                  //   onChanged: (value) {
                  //     FocusScope.of(context).requestFocus(
                  //       FocusNode(),
                  //     );
                  //     setState(
                  //       () {
                  //         bairroSelecionado = value;
                  //         var index = bairros.indexOf(value);
                  //         freteSelecionado = valorFretes[index];
                  //       },
                  //     );
                  //   },
                  // ),

                  Container(
                    margin: const EdgeInsets.only(left: 5, right: 5),
                    decoration: const BoxDecoration(
                        color: Colors.white54,
                        borderRadius: BorderRadius.all(
                          Radius.circular(5),
                        )),
                    child: TextFormField(
                      controller: complemento,
                      decoration: InputDecoration(
                        labelText: " Complemento*",
                      ),
                      onChanged: (value) {
                        setState(() {
                          _complemento = value.toString();
                        });
                      },
                    ),
                  ),
                  SizedBox(height: 20),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white54,
                      borderRadius: const BorderRadius.all(Radius.circular(5)),
                    ),
                    height: MediaQuery.of(context).size.height / 12,
                    margin: const EdgeInsets.only(top: 20, bottom: 5),
                    child: Column(
                      children: [
                        Align(
                          alignment: Alignment.topLeft,
                          child: Container(
                            margin: EdgeInsets.only(
                                top: MediaQuery.of(context).size.height * 0.005,
                                left: 5),
                            child: Text(
                              "Preencha os dados pessoais",
                              style: GoogleFonts.nanumGothic(
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF6c5c54),
                              ),
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.topLeft,
                          child: Container(
                            margin: EdgeInsets.only(top: 2),
                            child: Text(
                              " * - Campos obrigatórios",
                              style: GoogleFonts.nanumGothic(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 10),

                  Container(
                    margin: EdgeInsets.only(left: 5, right: 5),
                    decoration: const BoxDecoration(
                      color: Colors.white54,
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                    ),
                    child: TextFormField(
                        controller: nome,
                        onChanged: (value) {
                          setState(() {
                            _nome = value;
                          });
                        },
                        decoration: InputDecoration(
                          labelText: "Nome*",
                        ),
                        validator: (value) {
                          if (value == null ||
                              value.isEmpty ||
                              value.length < 8) {
                            return "Digite um nome válido";
                          }
                          return null;
                        }),
                  ),
                  SizedBox(height: 20),
                  Container(
                    margin: const EdgeInsets.only(left: 3, right: 3),
                    decoration: const BoxDecoration(
                      color: Colors.white54,
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                    ),
                    child: TextFormField(
                        controller: mascara,
                        onChanged: (value) {
                          setState(() {
                            _cpf = value;
                          });
                        },
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: "Cpf*",
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Digite o campo cpf corretamente";
                          }
                          return null;
                        }),
                  ),
                  SizedBox(height: 20),
                  Container(
                    margin: const EdgeInsets.only(left: 5, right: 5),
                    decoration: const BoxDecoration(
                      color: Colors.white54,
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                    ),
                    child: TextFormField(
                        controller: telefone,
                        onChanged: (value) {
                          setState(() {
                            _telefone = value;
                          });
                        },
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: "Telefone*",
                        ),
                        validator: (value) {
                          if (value == null ||
                              value.isEmpty ||
                              value.length < 14) {
                            return "Digite um número válido";
                          }
                          return null;
                        }),
                  ),
                  SizedBox(height: 20),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white54,
                      borderRadius: const BorderRadius.all(Radius.circular(5)),
                    ),
                    height: MediaQuery.of(context).size.height / 12,
                    margin: const EdgeInsets.only(top: 20, bottom: 5),
                    child: Column(
                      children: [
                        Align(
                          alignment: Alignment.topLeft,
                          child: Container(
                            margin: EdgeInsets.only(
                                top: MediaQuery.of(context).size.height * 0.005,
                                left: 5),
                            child: Text(
                              "Escolha a forma de pagamento",
                              style: GoogleFonts.nanumGothic(
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF6c5c54),
                              ),
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.topLeft,
                          child: Container(
                            margin: EdgeInsets.only(top: 2),
                            child: Text(
                              " * - Campos obrigatórios",
                              style: GoogleFonts.nanumGothic(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                      padding: EdgeInsets.only(
                          top: MediaQuery.of(context).size.height * 0.02),
                      child: Column(
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width * 0.95,
                            color: Colors.white54,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.95,
                                  child: DropdownButtonFormField(
                                    validator: (value) {
                                      if (value == null) {
                                        return;
                                      }
                                    },
                                    decoration: InputDecoration(
                                      label: Text('Pagamento',
                                          style: TextStyle(fontSize: 21)),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                    ),
                                    isExpanded: true,
                                    value: _selectedPayment,
                                    hint: Padding(
                                      padding:
                                          const EdgeInsets.only(left: 15.0),
                                      child: Text(_selectedPayment != null
                                          ? _selectedPayment
                                          : "Selecione a forma de pagamento"),
                                    ),
                                    items: _payment
                                        .map(
                                          (pay) => DropdownMenuItem(
                                            value: pay["pay"].toString(),
                                            child: Text(pay["pay"].toString()),
                                          ),
                                        )
                                        .toList(),
                                    onChanged: (newValue) {
                                      setState(() {
                                        _selectedPayment = newValue;
                                        print(_selectedPayment);
                                      });
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                          _selectedPayment == "Pix"
                              ? Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.95,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Text("Chave pix: (66)99912-7896",
                                              style: TextStyle(fontSize: 19)),
                                          InkWell(
                                            onTap: () async {
                                              await Clipboard.setData(
                                                  ClipboardData(
                                                      text: "66999127896"));
                                            },
                                            child: Padding(
                                              padding: EdgeInsets.only(
                                                  left: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.03),
                                              child: Icon(Icons.content_copy),
                                            ),
                                          ),
                                        ],
                                      )),
                                )
                              : Divider(
                                  thickness: 2,
                                ),
                        ],
                      )),
                  SizedBox(height: 5),
                  Container(
                    margin: EdgeInsets.only(left: 5, right: 5),
                    decoration: const BoxDecoration(
                      color: Colors.white54,
                      borderRadius: const BorderRadius.all(Radius.circular(5)),
                    ),
                    child: _selectedPayment != "Dinheiro"
                        ? TextFormField(
                            decoration: const InputDecoration(
                              labelText: "observação",
                            ),
                            onChanged: (value) {
                              _obs = value;
                            })
                        : TextFormField(
                            decoration: const InputDecoration(
                              labelText: "deseja informar o troco?",
                            ),
                            onChanged: (value) {
                              _obs = value;
                            }),
                  ),

                  Container(
                    width: MediaQuery.of(context).size.width * 0.95,
                    margin: EdgeInsets.only(bottom: 50, top: 10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: MediaQuery.of(context).size.height / 25,
                          margin: EdgeInsets.only(bottom: 3),
                          alignment: Alignment.centerLeft,
                          child: Text(
                            _finalValue == null
                                ? "Valor total do pedido: R\$" +
                                    valorTotalCarrinho.toString()
                                : "Valor total do pedido: R\$" +
                                    _finalValue.toStringAsFixed(2),
                            style: GoogleFonts.nanumGothic(
                              fontSize: 21,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        Divider(
                          thickness: 2,
                        ),
                        Align(
                          alignment: Alignment.center,
                          child: Container(
                            margin: EdgeInsets.all(5),
                            child: ElevatedButton(
                                child: Text('Finalizar pedido'),
                                onPressed: () async {
                                  if (_formKey.currentState!.validate()) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content: Text('Procesando...')),
                                    );
                                    getMessageClosedStore();
                                    guardarDadosEntrega();
                                    cadastroPedido();
                                  }
                                }),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
