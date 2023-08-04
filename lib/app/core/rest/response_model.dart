import 'dart:convert';

import 'package:http/http.dart' as http;

class ResponseModel {
  final int statusCode;
  final dynamic data;
  ResponseModel({
    required this.statusCode,
    required this.data,
  });

  factory ResponseModel.fromHttp(http.Response response) {
    return ResponseModel(
      statusCode: response.statusCode,
      data: response.body,
    );
  }
}
