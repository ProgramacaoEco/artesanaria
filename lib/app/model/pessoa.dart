import 'pessoaEmail.dart';
import 'pessoaEndereco.dart';
import 'pessoaFisica.dart';
import 'pessoaTelefone.dart';

class Pessoa {

   String? pessoaID;
  String? nome;
  PessoaFisica? pessoaFisica;
  List<PessoaTelefone>? pessoaTelefone;
  List<PessoaEmail>? pessoaEmail;
  List<PessoaEndereco>? pessoaEndereco;

  Pessoa({
    this.pessoaID,
    this.nome,
    this.pessoaFisica,
    this.pessoaTelefone,
    this.pessoaEmail,
    this.pessoaEndereco
  });

  factory Pessoa.fromJson(Map<String, dynamic>json)=>Pessoa(
    pessoaID: json['pessoaID'],
    nome: json['nome'],
    pessoaFisica: json['pessoaFisica'],
    pessoaTelefone: 
    List<PessoaTelefone>.from(
      json['pessoaTelefone'].map((x) => PessoaTelefone.fromJson(x))),
    pessoaEmail: 
    List<PessoaEmail>.from(
      json['pessoaEmail'].map((x) => PessoaEmail.fromJson(x))),
    pessoaEndereco: 
    List<PessoaEndereco>.from(
      json['pessoaEndereco'].map((x) => PessoaEndereco.fromJson(x))),
  );

  Map<String, dynamic>toJson()=>{
    'pessoaID': pessoaID,
    'nome': nome,
    'pessoaFisica': pessoaFisica,
    'pessoaTelefone':
    List<dynamic>.from(pessoaTelefone!.map((x) =>x.toJson())),
    'pessoaEmail': 
    List<dynamic>.from(pessoaEmail!.map((x) =>x.toJson())),
    'pessoaEndereco':
    List<dynamic>.from(pessoaEndereco!.map((x) =>x.toJson()))
  };
}

