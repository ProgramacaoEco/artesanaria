// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loja_flyinghigh/utils/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../produto/produtosPage_view.dart';
import '../widgets/colors.dart';

Cores cor = Cores();

// ignore: must_be_immutable
class Categoria extends StatelessWidget {
  // ignore: non_constant_identifier_names
  String? path;
  int? id_categoria;
  String? text;
  String? imagem;

  Categoria({Key? key, this.id_categoria, this.path, this.text, this.imagem})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 10),
      decoration: const BoxDecoration(color: Colors.transparent),
      child: GestureDetector(
          onTap: () async {
            SharedPreferences prefs = await SharedPreferences.getInstance();
            prefs.setString("categoria", text.toString());
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const NavegacaoProdutosView()));
          },
          child: Column(
            children: [
              Expanded(
                child: CircleAvatar(
                  backgroundImage: NetworkImage(
                    //rotaIMAGE
                    '${Constants.API_BASIC_ROUTE}/storage/app/$imagem',
                  ),
                  backgroundColor: Color(cor.tema),
                  maxRadius: 32,
                ),
                flex: 2,
              ),
              Expanded(
                child: Container(
                  alignment: Alignment.center,
                  width: 85,
                  child: Text(
                    text.toString(),
                    style: GoogleFonts.nanumGothic(
                        fontSize: 15, fontWeight: FontWeight.w500),
                  ),
                ),
              )
            ],
          )),
    );
  }
}
