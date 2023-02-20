// ignore_for_file: file_names, import_of_legacy_library_into_null_safe, prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'colors.dart';

Cores cor = Cores();

class Inputs extends StatefulWidget {
    TextStyle titulo =  TextStyle(color: Color(cor.tema), fontSize: 20);
  InputDecoration decoNome =  InputDecoration(
    focusedBorder: UnderlineInputBorder(
      borderSide: BorderSide(
        color: Color(cor.tema),
      ),
    ),
    hintText: "Nome",
    border: const UnderlineInputBorder(
      borderRadius: BorderRadius.vertical(
        bottom: Radius.circular(0.2),
      ),
    ),
  );
  InputDecoration decoEmail =  InputDecoration(
    focusedBorder: UnderlineInputBorder(
      borderSide: BorderSide(
        color: Color(cor.tema),
      ),
    ),
    hintText: "E-mail",
    border: const UnderlineInputBorder(
      borderRadius: BorderRadius.vertical(
        bottom: Radius.circular(0.2),
      ),
    ),
  );
  InputDecoration decoCelular =  InputDecoration(
    focusedBorder: UnderlineInputBorder(
      borderSide: BorderSide(
        color: Color(cor.tema),
      ),
    ),
    hintText: "Celular",
    border: const UnderlineInputBorder(
      borderRadius: BorderRadius.vertical(
        bottom: Radius.circular(0.2),
      ),
    ),
  );
  TextEditingController nome = TextEditingController();
  TextEditingController email = TextEditingController();
  MaskedTextController celular = MaskedTextController(mask: "(00)00000-0000");

  var clienteExistente;

  RegExp regExp = RegExp(
      r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$",
      caseSensitive: false,
      multiLine: false);


  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    throw UnimplementedError();
  }
}