import 'dart:convert';
import 'dart:developer';
import 'package:html_editor_web/app/core/rest/response_model.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class Repository {
  Map<String, String> getHeaders(String token) => {
        "Authorization": token,
        "Content-Type": "application/json",
      };

  String generateAuthorizationToken() {
    DateTime data = DateTime.now();

    var token = ((data.day + data.month + data.year) * data.day);
    var tokenToString = token.toString();

    List<int> uint = utf8.encode(tokenToString);

    String token64 = base64.encode(uint);
    print("TOKEN64: $token64");
    return token64;
  }

  Future<ResponseModel?> get(String path, [Map<String, dynamic>? data]) async {
    try {
      final token = generateAuthorizationToken();
      print("TOKEN: $token");
      var response = await http.get(
        Uri.parse("https://dcore.report-med.com/api/$path"),
        headers: getHeaders(
          token,
        ),
      );
      /*print("RESPONSE STATUS CODE> ${response.statusCode}");
      print("RESPONSE> ${response.body}");*/
      return ResponseModel.fromHttp(response);
    } catch (e, s) {
      log(
        "Erro ao efetuar requisição",
        error: e,
        stackTrace: s,
      );
      return null;
    }
  }
}
