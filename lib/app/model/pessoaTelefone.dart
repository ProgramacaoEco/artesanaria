// ignore_for_file: file_names
import 'dart:convert';

class PessoaTelefone {

   String? pessoaID;
  String? ddi;
  String? ddd;
  String? numero;
  bool? flagPrincipal;
  bool? whatsApp;
  bool? telegram;

  PessoaTelefone({
    this.pessoaID,
    this.ddi,
    this.ddd,
    this.numero,
    this.flagPrincipal,
    this.whatsApp,
    this.telegram
  });

  
  factory PessoaTelefone.fromJson(Map<String, dynamic>json)=>PessoaTelefone(
    pessoaID: json['pessoaID'],
    ddi: json['ddi'],
    ddd: json['ddd'],
    numero: json['numero'],
    flagPrincipal: json['flagPrincipal'],
    whatsApp: json['whatsApp']
  );

  Map<String, dynamic> toJson() => {
      'pessoaID': pessoaID,
      'ddi': ddi,
      'ddd': ddd,
      'numero': numero,
      'flagPrincipal': flagPrincipal,
      'whatsApp': whatsApp,
      'telegram': telegram,
    };

}
