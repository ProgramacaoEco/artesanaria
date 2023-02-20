// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:material_dialogs/widgets/buttons/icon_button.dart';
import '../pesquisa/barra_pesquisa_view.dart';
import '../widgets/colors.dart';
import 'package:url_launcher/url_launcher.dart';

class CustomBottomsheet extends StatefulWidget {

   const CustomBottomsheet({ Key? key }) : super(key: key);

  @override
  State<CustomBottomsheet> createState() => _CustomBottomsheetState();
}

class _CustomBottomsheetState extends State<CustomBottomsheet> {
  Cores cor = Cores();

   @override
   Widget build(BuildContext context) {
       return BottomAppBar(
         child: Container(
           height: MediaQuery.of(context).size.height/18,
              decoration: BoxDecoration(
                 gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [
                    Color(cor.cor3),
                    Color(cor.cor2),
                    Color(cor.cor1),
                  ],
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  FloatingActionButton(
                    onPressed: ()  {
                    Navigator.pushNamed(context, "/carrinho");
                    },
                    heroTag: "car",
                    backgroundColor: Colors.white,
                    elevation: 18.0,
                    child: const Icon(Icons.shopping_cart_rounded),
                  ),
                  FloatingActionButton(
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, '/home');
                    },
                    heroTag: "home",
                    backgroundColor: Colors.white,
                    elevation: 18.0,
                    child: const Icon(Icons.home),
                  ),
                  FloatingActionButton(
                    onPressed: () {
                      showSearch(
                          context: context,
                          delegate: Pesquisar(),
                      );
                    },
                    heroTag: "search",
                    backgroundColor: Colors.white,
                    elevation: 18,
                    child: const Icon(Icons.search)
                  )
                ],
              ),
            ),
         );
  }
}