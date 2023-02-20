// ignore_for_file: file_names
import 'package:flutter/material.dart';
import '../pesquisa/barra_pesquisa_view.dart';

class Searchbar extends StatefulWidget {

  const Searchbar({ Key? key }) : super(key: key);

  @override
  _SearchbarState createState() => _SearchbarState();
}

class _SearchbarState extends State<Searchbar> {
TextEditingController produto = TextEditingController();
   @override
   Widget build(BuildContext context) {
       return GestureDetector(
       child: Container(
        height: MediaQuery.of(context).size.height / 18,
        margin: const EdgeInsets.only(
          top: 5, bottom: 2, left: 5, right: 5
         ),
        decoration: const BoxDecoration(
          color: Colors.white,
         borderRadius:  BorderRadius.all(
           Radius.circular(22)
         ),
        ),
          child: TextFormField(
          controller: produto,
          keyboardType: TextInputType.text,
          decoration: const InputDecoration(
            border: InputBorder.none,
            icon: Icon(
              Icons.search,
              color: Colors.white,
              ),
            hintText: "Pesquisar",
            ),
          ),
       ),

       onTap: () {
           showSearch(
            context: context,
            delegate: Pesquisar(),
            );
       }
          );
  }
}