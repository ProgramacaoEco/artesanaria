// ignore_for_file: file_names
class Item {
  Item(
      { this.descricaoProduto,
      this.valor,
       this.descricao_pagamento,
       this.quantidade,
       this.tamanho,
       this.imagem,
       this.id_produto,
       this.codigoProduto,});

  int? id_produto;
  String? descricaoProduto;
  double? valor;
  String? descricao_pagamento;
  var quantidade;
  String? tamanho;
  String? imagem;
  String? codigoProduto;

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map["id_produto"] = id_produto;
    map["descricaoProduto"] = descricaoProduto;
    map["codigoProduto"] = codigoProduto;
    map["valor"] = valor;
    map["descricao_pagamento"] = descricao_pagamento;
    map["quantidade"] = quantidade;
    map["tamanho"] = tamanho;
    map["imagem"] = imagem;
    return map;
  }
}
