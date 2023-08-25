import 'dart:convert';
import 'dart:developer';
import 'package:reportpad/app/core/rest/response_model.dart';
import 'package:http/http.dart' as http;

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
    return token64;
  }

  Future<ResponseModel?> get(
    String path,
  ) async {
    try {
      final token = generateAuthorizationToken();
      print("TOKEN: $token");
      var response = await http.get(
        Uri.parse("https://dcore.report-med.com/api/$path"),
        headers: getHeaders(
          token,
        ),
      );
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

  Future<ResponseModel?> post(String path, Object? data) async {
    try {
      final token = generateAuthorizationToken();
      print("TOKEN: $token");
      var response = await http.post(
        Uri.parse("https://dcore.report-med.com/api/$path"),
        headers: getHeaders(
          token,
        ),
        body: data,
      );
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
