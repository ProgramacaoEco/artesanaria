// ignore_for_file: file_names

class PessoaFisica {

  String? pessoaID;
  String? cpf;
  DateTime? dataNascimento;
  String? estadoCivil;
  String? sexo;

  PessoaFisica({
    this.pessoaID,
    this.cpf,
    this.dataNascimento,
    this.estadoCivil,
    this.sexo
  });

  factory PessoaFisica.fromJson(Map<String, dynamic>json) => PessoaFisica(
    pessoaID: json['pessoaID'],
    cpf: json['cpf'],
    dataNascimento: json['dataNascimento'],
    estadoCivil: json['estadoCivil'],
    sexo: json['sexo']
  );

  Map<String, dynamic>toJson() => {
   "pessoaID": pessoaID,
   "cpf": cpf,
   "dataNascimento": dataNascimento, 
   "estadoCivil": estadoCivil,
   "sexo": sexo
  };

}