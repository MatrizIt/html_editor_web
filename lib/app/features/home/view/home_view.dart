import 'package:flutter/material.dart';
import 'package:html_editor_web/app/repository/auth/auth_repository.dart';
import 'package:html_editor_web/app/repository/auth/i_auth_repository.dart';

abstract class HomeView<T extends StatefulWidget> extends State<T> {
  late final IAuthRepository repository;

  Future<bool> sendPhone(String phone) async {
    final resp = await repository.sendPhoneNumber(phone);
    return resp;
  }
}
