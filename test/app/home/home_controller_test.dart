import 'package:flutter_test/flutter_test.dart';
import 'package:loja_flyinghigh/utils/constants.dart';
import 'package:http/http.dart' as http;

void main() async {
  print('begin');
  var response = await http.get(
    Uri.parse(
        '${Constants.API_BASIC_ROUTE}${Constants.API_FOLDERS}listarCampanhas'),
    headers: {"Accept": "application/json", "content-type": "application/json"},
  );

  print('status: ${response.statusCode}');
  print(response.body);
}
