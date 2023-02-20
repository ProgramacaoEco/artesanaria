// ignore_for_file: file_names

class PessoaEndereco {

    int? pessoaEnderecoID;
  String? pessoaID;
  String? uf;
  String? municipio;
  String? bairro;
  String? logradouro;
  String? numero;
  String? complemento;
  String? cep;
  bool? flagPrincipal;

  PessoaEndereco({
    this.pessoaEnderecoID,
    this.pessoaID,
    this.uf,
    this.municipio,
    this.bairro,
    this.logradouro,
    this.numero,
    this.complemento,
    this.cep,
    this.flagPrincipal
  });

  factory PessoaEndereco.fromJson(Map<String, dynamic>json)=>PessoaEndereco(
    pessoaEnderecoID: json['pessoaEnderecoID'],
    pessoaID: json['pessoaID'],
    uf: json['uf'],
    municipio: json['municipio'],
    bairro: json['bairro'],
    logradouro: json['logradouro'],
    numero: json['numero'],
    complemento: json['complemento'],
    cep: json['cep'],
    flagPrincipal: json['flagPrincipal']
  );

  Map<String, dynamic>toJson() => {
    "pessoaEnderecoID": pessoaEnderecoID,
    "pessoaID": pessoaID,
    "uf": uf,
    "municipio": municipio,
    "bairro": bairro,
    "logradouro": logradouro,
    "numero": numero,
    "complemento": complemento,
    "cep": cep,
    "flagPrincipal": flagPrincipal
  };
}