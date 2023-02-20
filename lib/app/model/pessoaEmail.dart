// ignore_for_file: file_names
class PessoaEmail {

  String? pessoaEmailID;
  String? pessoaID;
  String? email;
  bool? flagPrincipal;

  PessoaEmail({
    this.pessoaEmailID,
    this.pessoaID,
    this.email,
    this.flagPrincipal
  });

  factory PessoaEmail.fromJson(Map<String, dynamic>json)=>PessoaEmail(
    pessoaEmailID: json['pessoaEmailID'],
    pessoaID: json['pessoaID'],
    email: json['email'],
    flagPrincipal: json['flagPrincipal']
  );

  Map<String, dynamic>toJson() => {
    'pessoaEmailID': pessoaEmailID,
    'pessoaID': pessoaID,
    'email': email,
    'flagPrincipal': flagPrincipal
  };

}