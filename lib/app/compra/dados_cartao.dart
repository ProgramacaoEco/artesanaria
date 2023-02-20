// ignore_for_file: file_names
import 'dart:io';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:loja_flyinghigh/app/cadastro/cadastro_dados_endereço.dart';
import 'package:loja_flyinghigh/app/providers/itens_pedido_list.dart';
import 'package:loja_flyinghigh/app/model/pagador.dart';
import 'package:loja_flyinghigh/utils/constants.dart';
import 'package:provider/provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import '../model/pessoa.dart';

import '../../database/database.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/colors.dart';

import 'package:http/http.dart' as http;
import 'package:toast/toast.dart';

Cores cor = Cores();
CadastroEnderecoView cEndV = CadastroEnderecoView();
Pessoa pessoa = Pessoa();
DatabaseHelper dbHelper = DatabaseHelper.instance;

class DadosCartaoState extends State<DadosCartao> {
  //Gerenciamento de estado
  @override
  void initState() {
    super.initState();
    carregarValoresPedido();
    Provider.of<ListaItensPedido>(context, listen: false)
        .carregaValorTotal()
        .then((value) {
      setState(() {
        isLoading = false;
      });
    });
    obterItensPedido();
    obterParcelas();
    getClienteByCNPJ();

    //ChecarInternet().checarConexao(context);
  }

  @override
  void dispose() {
    super.dispose();
    //ChecarInternet().listener.cancel();
  }

//variaveis dos valores
  bool loadingPagamento = false;
  bool isLoading = true;
  late bool selectbool = false;
  var nVezes;
  var forma;
  var parce;
  var bairros = [];
  var cidades = <DropdownMenuItem>[];
  var valorFretes = [];
  var formasDePagamento = [];
  var parcelas = [];
  var itensPedido = [];
  var formaSelecionada;
  var freteSelecionado;
  var bairroSelecionado;
  var cidadeSelecionada;
  var parcelaSelecionada;
  late bool dinheiro;
  var conversao;
  late bool carregou;
  var valorTotal;
  var valorTotalPrefs;
  var pedido = [];
  var busca = 'buscar na loja';
  String pendente = 'pendente';

  var clienteLojaID;
  var pagadorID;
  var verificaToken;
  var nFantasia;
  late Map<String, dynamic> jsonString;
  var buyerID;
  var sellerID;
  var id_Terceiros_Cliente;
  var clienteID;
  var id_pedido;

  var nome;
  var email;
  var telefone;
  var uf;
  var cidade;
  var bairro;
  var logradouro;
  var complemento;
  var numero;
  var cep;
  var cpfU;
  var cnpjU;

  var deveoper = 1;

  var tipoPessoa;
  //mudar
  var clienteLojaCNPJ = "37.626.212/0001-99";
  // var clienteTokenApiKeyOLD =
  //     "0d887f29214188f52fb483016840db12f03d0cd175ead2a7cbf260752621471e2a9c337b";
  //
  var clienteTokenApiKey =
      "ee7482d697c4030db8e9191016deed2f3df9d7a5bd645075f7e1d1268f38efb7dcbd3a1f";
  DatabaseHelper dbHelper = DatabaseHelper.instance;
  final _formKey = GlobalKey<FormState>();

  late http.Response responseforma;
  late http.Response responseparcela;
  late http.Response responsepedido;
  late http.Response responseVezes;

  var urlforma = Uri.parse(
      '${Constants.API_BASIC_ROUTE}${Constants.API_FOLDERS}listarFormas');

  var urlpedido = Uri.parse(
      '${Constants.API_BASIC_ROUTE}${Constants.API_FOLDERS}cadastrarPedido');

  var urlCadastroPedido = Uri.parse(
      '${Constants.API_BASIC_ROUTE}${Constants.API_FOLDERS}cadastrarPedido');

  var urlGetNumeroVezes = Uri.parse(
      '${Constants.API_BASIC_ROUTE}${Constants.API_FOLDERS}listarVezesActivy');

  var urlGetClienteByCNPJ =
      Uri.parse('https://app.pagozap.com.br:3000/api/Clientes/GetByCNPJ');

  var urlFinalizarPagamentoCarta =
      'https://app.pagozap.com.br:3000/api/CobrancaCartaoCreditoZoop/RegistrarCobrancaDiretaCartaoCredito';

  MaskedTextController numeroCartao =
      MaskedTextController(mask: '0000000000000000');
  MaskedTextController mesVal = MaskedTextController(mask: '00');
  MaskedTextController anoVal = MaskedTextController(mask: '00');
  MaskedTextController cvv = MaskedTextController(mask: '000');
  TextEditingController nomeCartao = TextEditingController();
  TextEditingController parcela = TextEditingController();

  GlobalKey<FormFieldState> keyDpParcelas = GlobalKey();

// ==================================================================
// MÉTODOS REFERENTES À PLATAFORMA PAGOZAP
// ==================================================================

  getClienteByCNPJ() async {
    try {
      var value = await http.post(urlGetClienteByCNPJ,
          body: jsonEncode({"key": clienteLojaCNPJ}),
          headers: {
            "Authorization": "Bearer $clienteTokenApiKey",
            "Accept": "application/json",
            "content-type": "application/json"
          });
      print(value);
      if (value.statusCode == 200 || value.statusCode == 201) {
        var dados = jsonDecode(value.body);

        final Map<String, dynamic> data = jsonDecode(dados);
        var pessoas = data['pessoas'];
        var pessoaJuridica = pessoas['pessoaJuridica'];

        clienteID = data['clienteID'];
        id_Terceiros_Cliente = data['id_Terceiros'];
        nFantasia = pessoaJuridica['nomeFantasia'];
      } else {
        print("Erro em pegar dados do cliente loja");
      }
    } catch (e) {
      print(e);
    }
  }

  enviarValoresCartaoPagoZap(int idPedido) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    var valorTotalReplaced = valorTotalPrefs.replaceAll(',', '');
    int amount = int.parse(valorTotalReplaced);
    var parce = parcelaSelecionada.split("x");

    var dadosPagador = "123";
    print(dadosPagador);

    var data = jsonEncode({
      "amount": amount,
      "currency": "BRL",
      "description": "Pedido numero $idPedido",
      "on_behalf_of": id_Terceiros_Cliente,
      "statement_descriptor": nFantasia,
      "payment_type": "credit",
      "source": {
        "usage": "single_use",
        "amount": amount,
        "currency": "BRL",
        "type": "card",
        "card": {
          "card_number": numeroCartao.text,
          "holder_name": nomeCartao.text,
          "expiration_month": mesVal.text,
          "expiration_year": anoVal.text,
          "security_code": cvv.text
        },
        "installment_plan": {
          "mode": "interest_free",
          "number_installments": int.parse(parce[0])
        }
      },
      "requisicao": {
        "maxParcelas": null,
        "idRequisicaoPagamento": null,
        "id_Terceiros": null,
        "descricaoPagamento": "Teste Eco Sistemas",
        "sellerID": clienteID,
        "buyerID": null,
        "value": amount,
        "enviarWhatsapp": false,
        "enviarTelegram": false,
        "enviarSms": false,
        "enviarEmail": true,
        "split": false,
        "valor_split": 0,
        "tipo_split": null,
        "documento_split": null,
        "pagador": {
          "pagadorID": null,
          "pessoaID": null,
          "clienteID": clienteID,
          "flagAtivo": true,
          "tipoEvento": "I",
          "nomeEvento": "SAVE",
          "pessoa": {
            "pessoaID": null,

            "pessoaFisica": {
              "pessoaID": null,
              "cpf": cpfU,
              "dataNascimento": null,
              "estadoCivil": null,
              "sexo": null
            },
            "pessoaJuridica": {
              "pessoaID": null,
              "nomeFantasia": null,
              "cnpj": cnpjU
            },
            "pessoaTelefone": [],
            "pessoaEmail": [

            ],
            "pessoaEndereco": [],
            "tipoEvento": "I",
            "nomeEvento": "SAVE"
          },
          "id_Terceiros": null
        }
      },
      "split_rule": null,
      "split_rules": null
    });
    var urlFinalizarPagamentoCartao = Uri.parse(
        'https://app.pagozap.com.br:3000/api/CobrancaCartaoCreditoZoop/RegistrarCobrancaDiretaCartaoCredito');

    try {
      var value =
          await http.post(urlFinalizarPagamentoCartao, body: data, headers: {
        "Authorization": "Bearer $clienteTokenApiKey",
        "Accept": "application/json",
        "content-type": "application/json"
      });

      if (value.statusCode == 200 || value.statusCode == 201) {
        final res = jsonDecode(value.body);
        final dData = jsonDecode(res);

        if (dData['error'] != null) {
          var error = dData['error'];
          var categoria = error['category'];

          if (categoria == "invalid_card_number") {
            Toast.show(
                "Erro na finalização do pagamento! Numero do cartão invalido ",
                context,
                duration: 2,
                backgroundColor: Colors.red,
                gravity: 2);
          } else if (categoria == "service_request_timeout") {
            Toast.show(
                "Erro na finalização do pagamento! Service request timeout ",
                context,
                duration: 2,
                backgroundColor: Colors.red,
                gravity: 2);
          }
        } else {
          final status = dData['status'];
          if (status == "succeeded") {
            print(status);
            Toast.show("Pagamento realizado com sucesso!", context,
                duration: 2, backgroundColor: Colors.green, gravity: 2);

            await mudarStatusPedido(idPedido);

            setState(() {
              loadingPagamento = false;
            });
            Navigator.pushNamed(context, '/resumoPedido');
            dbHelper.limparCarrinho();
          } else {
            Toast.show("Erro na finalização do pagamento!", context,
                duration: 2, backgroundColor: Colors.red, gravity: 2);
          }
        }
      } else {
        Toast.show(
            "Ocorreu um erro interno por favor tente novamente ou entre em contado com a loja",
            context,
            duration: 2,
            backgroundColor: Colors.red,
            gravity: 2);
        setState(() {
          loadingPagamento = false;
        });
        Navigator.pop(context);
      }
    } catch (e) {
      print(e);
      Toast.show(
          "Ocorreu um erro interno por favor tente novamente ou entre em contado com a loja",
          context,
          duration: 2,
          backgroundColor: Colors.red,
          gravity: 2);
      setState(() {
        loadingPagamento = false;
      });
      Navigator.pop(context);
    }
  }

  defineTipoPessoa() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (tipoPessoa == 1) {
      cpfU = prefs.getString('cpf');
      cnpjU = null;
    } else {
      cpfU = null;
      cnpjU = prefs.getString('cpf');
    }
  }

  mudarStatusPedido(int idPedido) async {
    http.Response response;

    var urlMudarStatusPedido = Uri.https('${Constants.API_ROOT_ROUTE}',
        '${Constants.API_FOLDERS}editarStatusPedido/$idPedido');

    var status = {"status_pedido": "Pagamento Aprovado"};

    try {
      response = await http.put(
        urlMudarStatusPedido,
        headers: {
          "Accept": "application/json",
          "content-type": "application/json"
        },
        body: status,
      );
      print(response.statusCode);
      print(response.body);
      if (response.statusCode == 200 || response.statusCode == 201) {
        var res = jsonDecode(response.body);
      } else {
        Toast.show(
            "Ocorreu um erro em mudar o status do pedido! por favor tente entre em contato com a loja",
            context,
            duration: 2,
            backgroundColor: Colors.red,
            gravity: 2);
      }
    } catch (erro) {
      print(erro);
    }
  }

// ===========================================================================
// REGISTRAR PEDIDO NO NOSSO BANCO SQL
// ===========================================================================

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
          "quantidade": item.quantidade.toString(),
        },
      );
    }
  }

  cadastroPedido() async {

    var valorTotalReplaced = valorTotalPrefs.replaceAll(',', '.');

    parce = parcelaSelecionada.split("x");
    print('numero de parcelas né $parce[0]');

    try {

    } catch (erro) {
      print(erro);
    }
  }

  obterParcelas() async {
    var vTotal = await carregarValoresPedido();

    responseVezes = await http.get(
      urlGetNumeroVezes,
      headers: {
        "Accept": "application/json",
        "content-type": "application/json"
      },
    );
    var dados = json.decode(responseVezes.body);
    vTotal = valorTotalPrefs.replaceAll(',', '.');
    vTotal = double.parse(vTotal);

    print(vTotal);

    for (int i = 0; i < dados.length; i++) {
      String sVezes = dados[i]['numero_vezes'];
      nVezes = dados[i]['numero_vezes'].replaceAll('x', '');
      var numeroVezes = int.parse(nVezes);
      var calculo = (vTotal / numeroVezes);

      var valorCerto = (calculo.toStringAsFixed(2)).replaceAll('.', ',');

      dados[i]['numero_vezes'] = "$sVezes de R\$$valorCerto";

      print(dados[i]['numero_vezes']);

      setState(
        () {
          parcelas.add(
            dados[i]['numero_vezes'],
          );
        },
      );
    }
  }

// ===========================================================================
// SHARED PREFERENCES
// ===========================================================================

  guardarIdPedido() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('id_pedido', id_pedido);
  }

  carregarValoresPedido() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      valorTotalPrefs = prefs.getString('valorTotal');
    });
  }



  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations(
      [
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ],
    );
    final provider = Provider.of<ListaItensPedido>(context);
    valorTotal = provider.valorTotal;

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
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        margin: const EdgeInsets.only(top: 10, left: 5, right: 5),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Container(
            margin: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              color: Colors.indigo.shade50,
              borderRadius: const BorderRadius.all(Radius.circular(10)),
            ),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.indigo.shade50,
                      borderRadius: const BorderRadius.all(Radius.circular(5)),
                    ),
                    height: MediaQuery.of(context).size.height / 12,
                    margin: const EdgeInsets.only(top: 10, bottom: 5),
                    child: Column(
                      children: [
                        Align(
                          alignment: Alignment.topLeft,
                          child: Container(
                            margin: const EdgeInsets.only(top: 5, left: 5),
                            child: Text(
                              "Preencha os dados do cartão de crédito",
                              style: GoogleFonts.nanumGothic(
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                                color: Colors.black
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
                  SizedBox(height: 25),
                  Row(
                    children: [
                      Expanded(
                          child: Container(
                            decoration: const BoxDecoration(
                              color: Colors.white54,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5)),
                            ),
                            margin: EdgeInsets.only(left: 5),
                            child: TextFormField(
                                controller: numeroCartao,
                                decoration: InputDecoration(
                                    labelText: " Número do Cartão*"),
                                validator: (value) {
                                  if (value == null ||
                                      value.isEmpty ||
                                      value.length < 16) {
                                    return "Revise os dados do cartão";
                                  }
                                  return null;
                                }),
                          ),
                          flex: 3),
                      SizedBox(width: 15),
                      Expanded(
                        child: Container(
                          decoration: const BoxDecoration(
                            color: Colors.white54,
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                          ),
                          margin: const EdgeInsets.only(right: 5),
                          child: TextFormField(
                              controller: mesVal,
                              decoration:
                                  const InputDecoration(labelText: ' mm*'),
                              validator: (value) {
                                if (value == null ||
                                    value.isEmpty ||
                                    value.length < 2) {
                                  return "Revise o mês";
                                }
                                return null;
                              }),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          decoration: const BoxDecoration(
                            color: Colors.white54,
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                          ),
                          margin: const EdgeInsets.only(right: 5),
                          child: TextFormField(
                              controller: anoVal,
                              decoration:
                                  const InputDecoration(labelText: ' AA*'),
                              validator: (value) {
                                if (value == null ||
                                    value.isEmpty ||
                                    value.length < 2) {
                                  return "Revise o ano";
                                }
                                return null;
                              }),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 25),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          decoration: const BoxDecoration(
                            color: Colors.white54,
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                          ),
                          margin: EdgeInsets.only(left: 5),
                          child: TextFormField(
                              controller: cvv,
                              decoration: InputDecoration(labelText: " CVV*"),
                              validator: (value) {
                                if (value == null ||
                                    value.isEmpty ||
                                    value.length < 3) {
                                  return "Revise o CVV";
                                }
                                return null;
                              }),
                        ),
                      ),
                      SizedBox(width: 15),
                      Expanded(
                          child: Container(
                            decoration: const BoxDecoration(
                              color: Colors.white54,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5)),
                            ),
                            margin: EdgeInsets.only(right: 5),
                            child: TextFormField(
                                controller: nomeCartao,
                                decoration: InputDecoration(
                                    labelText: ' Nome impresso no cartão*'),
                                validator: (value) {
                                  if (value == null ||
                                      value.isEmpty ||
                                      value.length < 8) {
                                    return "Insira um nome válido";
                                  }
                                  return null;
                                }),
                          ),
                          flex: 3),
                    ],
                  ),
                  SizedBox(height: 30),
                  Row(children: <Widget>[
                    Expanded(
                      child: Container(
                        decoration: const BoxDecoration(
                          color: Colors.white54,
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                        ),
                        margin: const EdgeInsets.only(right: 5, left: 5),
                        child: DropdownButtonFormField(
                          hint: Text("Selecione o n de parcelas"),
                          value: parcelaSelecionada,
                          style: const TextStyle(color: Colors.black),
                          items: parcelas.map((parcela) {
                            return DropdownMenuItem(
                              child: Text(parcela),
                              value: parcela,
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              parcelaSelecionada = value!;
                            });
                          },
                        ),
                      ),
                    ),
                  ]),
                  SizedBox(height: 1),
                  Container(
                    height: 55,
                    margin: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Container(
                        //width: MediaQuery.of(context).size.width,
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Container(
                                  margin: EdgeInsets.only(right: 5),
                                  child: const Image(
                                      image: AssetImage(
                                          'lib/app/images/bandeiras/mastercard.png'),
                                      height: 35)),
                              Container(
                                  margin: EdgeInsets.symmetric(horizontal: 5),
                                  child: const Image(
                                      image: AssetImage(
                                          'lib/app/images/bandeiras/visa.jpg'),
                                      height: 32)),
                              Container(
                                  margin: EdgeInsets.symmetric(horizontal: 5),
                                  child: const Image(
                                      image: AssetImage(
                                          'lib/app/images/bandeiras/elo.png'),
                                      height: 60)),
                              Container(
                                  margin: EdgeInsets.symmetric(horizontal: 5),
                                  child: const Image(
                                      image: AssetImage(
                                          'lib/app/images/bandeiras/amex.png'),
                                      height: 43)),
                              Container(
                                  margin: EdgeInsets.symmetric(horizontal: 5),
                                  child: const Image(
                                      image: AssetImage(
                                          'lib/app/images/bandeiras/hipercard.jpg'),
                                      height: 35)),
                              Container(
                                  margin: EdgeInsets.symmetric(horizontal: 5),
                                  child: const Image(
                                      image: AssetImage(
                                          'lib/app/images/bandeiras/hiper.png'),
                                      height: 35)),
                              Container(
                                  margin: EdgeInsets.symmetric(horizontal: 5),
                                  child: const Image(
                                      image: AssetImage(
                                          'lib/app/images/bandeiras/jcb.png'),
                                      height: 35)),
                              Container(
                                  margin: EdgeInsets.symmetric(horizontal: 5),
                                  child: const Image(
                                      image: AssetImage(
                                          'lib/app/images/bandeiras/discover.png'),
                                      height: 35)),
                              Container(
                                  margin: EdgeInsets.symmetric(horizontal: 5),
                                  child: const Image(
                                      image: AssetImage(
                                          'lib/app/images/bandeiras/diners.jpg'),
                                      height: 35)),
                              Container(
                                  margin: EdgeInsets.symmetric(horizontal: 5),
                                  child: const Image(
                                      image: AssetImage(
                                          'lib/app/images/bandeiras/banescard.png'),
                                      height: 35)),
                              Container(
                                  margin: EdgeInsets.symmetric(horizontal: 5),
                                  child: const Image(
                                      image: AssetImage(
                                          'lib/app/images/bandeiras/aura.png'),
                                      height: 35)),
                            ]),
                      ),
                    ),
                  ),
                  Container(
                    child: Divider(
                      thickness: 2,
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(bottom: 50),
                    child: Column(
                      children: [
                        Container(
                          height: MediaQuery.of(context).size.height / 25,
                          margin: EdgeInsets.only(left: 5, bottom: 5),
                          alignment: Alignment.centerLeft,
                          child: Row(
                            children: [
                              Text(
                                "Valor total do pedido: ",
                                style: GoogleFonts.nanumGothic(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              isLoading
                                  ? const Center(
                                      child: CircularProgressIndicator())
                                  : Text(
                                      "R\$ $valorTotalPrefs",
                                      style: GoogleFonts.nanumGothic(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                            ],
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: Container(
                            margin: EdgeInsets.only(right: 15),
                            width: MediaQuery.of(context).size.width * 0.5,
                            child: isLoading
                                ? Center(child: CircularProgressIndicator())
                                : ElevatedButton(
                                    onPressed: loadingPagamento
                                        ? () {}
                                        : () async {
                                            if (_formKey.currentState!
                                                .validate()) {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                const SnackBar(
                                                    content:
                                                        Text('Processando...')),
                                              );
                                              setState(() {
                                                loadingPagamento = true;
                                              });
                                              cadastroPedido();
                                            }
                                          },
                                    child: loadingPagamento
                                        ? Center(
                                            child: CircularProgressIndicator())
                                        : const Text('Realizar Pagamento',
                                            style: TextStyle(fontSize: 16)),
                                  ),
                          ),
                        ),
                        Divider(
                          thickness: 2,
                        ),
                        Container(
                          margin: EdgeInsets.all(5),
                          height: 125,
                          child: Center(
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5)),
                                  color: Colors.grey.shade300),
                              margin: EdgeInsets.all(5),
                              child: Container(
                                margin: EdgeInsets.all(3),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                        'Para maiores esclarecimentos sobre o envio do pedido consulte o vendedor via WhatsApp.',
                                        style: GoogleFonts.aBeeZee(
                                            fontSize: 17,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.black54)),
                                    Align(
                                      alignment: Alignment.centerRight,
                                      child: Container(
                                        margin: EdgeInsets.all(3),
                                        decoration: BoxDecoration(
                                          color: Colors.green.shade500,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(5)),
                                        ),
                                        width:
                                            MediaQuery.of(context).size.width /
                                                2.3,
                                        // margin: const EdgeInsets.only(right: 4),
                                        child: GestureDetector(
                                          onTap: () async {
                                            //Whats
                                            try {
                                              await launch(
                                                  'https://api.whatsapp.com/send?phone=');
                                            } catch (error) {
                                              print(error);
                                            }
                                          },
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: const [
                                              Image(
                                                image: AssetImage(
                                                    'lib/app/images/wpp.png'),
                                                height: 40,
                                              ),
                                              Text('Enviar Mensagem',
                                                  style: TextStyle(
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color: Colors.white))
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 50)
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

class DadosCartao extends StatefulWidget {
  State<StatefulWidget> createState() {
    return DadosCartaoState();
  }
}
