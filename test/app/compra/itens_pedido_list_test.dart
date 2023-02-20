import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:loja_flyinghigh/app/providers/itens_pedido_list.dart';
import 'package:provider/provider.dart';

void main() {
  testWidgets('itens pedido list ...', (tester) async {
    // TODO: Implement test

    @override
    Widget build(BuildContext context) {
      Provider.of<ListaItensPedido>(context, listen: false)
          .index()
          .then((value) => print('Rodou'));

      return Scaffold();
    }
  });
}
