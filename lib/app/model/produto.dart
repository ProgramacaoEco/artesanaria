// ignore_for_file: non_constant_identifier_names
import 'package:flutter/material.dart';

class Produto with ChangeNotifier {
  int id_produto;
  String descricaoProduto;
  double valor;
  String imagens;
  String descricao_pagamento;
  String codigoProduto;
  List quantidades;
  List? carouselImages;

  Produto({
    required this.id_produto,
    required this.descricaoProduto,
    required this.valor,
    required this.imagens,
    required this.descricao_pagamento,
    required this.codigoProduto,
    required this.quantidades,
    this.carouselImages,
  });
}
