import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

void main() async {
    var data = jsonEncode({
      "amount": 66666,
      "currency": "BRL",
      "description": "pedido numero",
      "on_behalf_of": '939f1c3a5c40447f9926829c5c8c346d',
      "statement_descriptor": 'Tests Flutter',
      "payment_type": "credit",
      "source": {
        "usage": "single_use",
        "amount": 66666,
        "currency": "BRL",
        "type": "card",
        "card": {
          "card_number": "4532650104137832",
          "holder_name": "PORTELINHA",
          "expiration_month": "12",
          "expiration_year": "2022",
          "security_code": "123"
        },
        "installment_plan": {
          "mode": "interest_free",
          "number_installments": null
        }
      },
      "requisicao": {
        "maxParcelas": null,
        "idRequisicaoPagamento": null,
        "id_Terceiros": null,
        "descricaoPagamento": null,
        "sellerID": "02039d44-b9dd-40c3-b3c4-83c066b7e178",
        "buyerID": null,
        "value": 66666,
        "status": "pending",
        "enviarWhatsapp": false,
        "enviarTelegram": false,
        "enviarSms": false,
        "enviarEmail": false,
        "split": false,
        "valor_split": null,
        "tipo_split": null,
        "documento_split": null,
        "pagador": {
          "pagadorID": null,
          "pessoaID": null,
          "clienteID": '02039d44-b9dd-40c3-b3c4-83c066b7e178',
          "flagAtivo": true,
          "tipoEvento": "I",
          "nomeEvento": "SAVE",
          "pessoa": {
            "pessoaID": null,
            "nome": 'Lucas Neves',
            "pessoaFisica": {
              "pessoaID": null,
              "cpf": '486.354.690-46',
              "dataNascimento": null,
              "estadoCivil": null,
              "sexo": null
            },
            "pessoaJuridica": {
              "pessoaID": null,
              "nomeFantasia": null,
              "cnpj": null
            },
            "pessoaTelefone": [
              {
                "pessoaID": null,
                "ddi": null,
                "ddd": null,
                "numero": null,
                "flagPrincipal": false,
                "whatsApp": false,
                "telegram": false
              }
            ],
            "pessoaEmail": [
              {"email": 'lucasnevesp@outlook.com'}
            ],
            "pessoaEndereco": [
              {
                "pessoaID": null,
                "uf": null,
                "municipio": null,
                "bairro": null,
                "logradouro": null,
                "numero": null,
                "complemento": null,
                "cep": null,
                "flagPrincipal": true
              }
            ],
            "tipoEvento": "I",
            "nomeEvento": "SAVE"
          },
          "id_Terceiros": null
        }
      },
      "split_rule": null,
      "split_rules": null
    });
    print('prépost'); 
    await Dio().post('dev.app.pagozap.com.br:3000/api/CobrancaCartaoCreditoZoop/RegistrarCobrancaDiretaCartaoCredito',
        data: data,
        options: Options(headers: {
          "Authorization": "Bearer 0d887f29214188f52fb483016840db12f03d0cd175ead2a7cbf260752621471e2a9c337b",
          "Accept": "application/json",
          "content-type": "application/json"
        }));
    print('póspost'); 
  }


