import 'package:loja_flyinghigh/app/model/pessoa.dart';

class Pagador {
  String? pagadorID;
  String? pessoaID;
  String? clienteID;
  bool? flagAtivo;
  String? id_Terceiros;
  String? tipoEvento;
  String? nomeEvento;

  Pessoa? pessoa;

  Pagador(
      {this.pagadorID,
      this.pessoaID,
      this.clienteID,
      this.flagAtivo,
      this.id_Terceiros,
      this.tipoEvento,
      this.nomeEvento,
      this.pessoa});

  factory Pagador.fromJson(Map<String, dynamic> json) => Pagador(
      pagadorID: json['pagadorID'],
      pessoaID: json['pessoaID'],
      clienteID: json['clienteID'],
      flagAtivo: json['flagAtivo'],
      id_Terceiros: json['id_Terceiros'],
      tipoEvento: json['tipoEvento'],
      nomeEvento: json['nomeEvento'],
      pessoa: json['pessoa']);

  Map<String, dynamic> toJson() => {
        'pagadorID': pagadorID,
        'pessoaID': pessoaID,
        'clienteID': clienteID,
        'flagAtivo': flagAtivo,
        'id_Terceiros': id_Terceiros,
        'tipoEvento': tipoEvento,
        'nomeEvento': nomeEvento,
        'pessoa': pessoa
      };
}
