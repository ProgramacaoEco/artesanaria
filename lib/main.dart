import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:loja_flyinghigh/app/model/produto.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:loja_flyinghigh/app/cadastro/cadastro_dados_endere%C3%A7o.dart';
import 'package:loja_flyinghigh/app/cadastro/cadastro_dados_pagador.dart';
import 'package:loja_flyinghigh/app/cadastro/cadastro_dados_pessoais.dart';
import 'package:loja_flyinghigh/app/compra/dados_cartao.dart';
import 'package:loja_flyinghigh/app/providers/campanhas_list.dart';
import 'package:loja_flyinghigh/app/providers/categorias_list.dart';
import 'package:loja_flyinghigh/app/providers/itens_pedido_list.dart';
import 'package:loja_flyinghigh/app/providers/produtos_list.dart';
import 'package:loja_flyinghigh/app/resumo_pedido/resumo_pedido.dart';
import 'package:provider/provider.dart';
import 'app/carrinho/carrinho_view.dart';
import '/app/compra/retirada_view.dart';
import 'app/home/home_view.dart';
import 'app/login/login_view.dart';
import '/app/compra/finalizar_compra.dart';
import '/app/pesquisa/pesquisar_view.dart';
import '/app/produto/descricaoProduto_view.dart';
import 'app/pdf/pdf_view.dart';
import 'app/produto/produtosPage_view.dart';
import 'app/providers/bairros_list.dart';

main() async {
  WidgetsFlutterBinding.ensureInitialized();
  HttpOverrides.global = MyHttpOverrides();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ListaItensPedido()),
        ChangeNotifierProvider(create: (context) => ProdutosList()),
        ChangeNotifierProvider(create: (context) => CategoriasList()),
        ChangeNotifierProvider(create: (context) => CampanhasList()),
        ChangeNotifierProvider(create: (context) => BairrosList()),
      ],
      child: MaterialApp(
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate
        ],
        supportedLocales: const [Locale('pt', 'BR')],
        debugShowCheckedModeBanner: false,
        routes: {
          '/home': (context) => HomeView(),
          '/login': (context) => LoginView(),
          '/carrinho': (context) => Carrinho(),
          '/retirada': (context) => RetiradaView(),
          '/finalizarCompra': (context) => FinalizarCompra(),
          '/navegacaoProdutos': (context) => NavegacaoProdutosView(),
          '/pesquisaProdutos': (context) => TelaPesquisaView(),
          '/cadastro': (context) => CadastroView(),
          '/cadastroEndereco': (context) => CadastroEnderecoView(),
          '/cadastroPagador': (context) => CadastroPagadorView(),
          '/dadosCartao': (context) => DadosCartao(),
          '/resumoPedido': (context) => ResumoPedido(),
        },
        initialRoute: '/home',
      ),
    );
  }
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
