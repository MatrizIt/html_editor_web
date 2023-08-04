import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:html_editor_web/app/features/validate_token/validate_token_page.dart';
import 'package:html_editor_web/app/repository/auth/i_auth_repository.dart';

import '../../../core/ui/helpers/messages.dart';

abstract class ValidateTokenView<T extends StatefulWidget> extends State<T>
    with Messages<T> {
  late final IAuthRepository repository;

  Future<void> requestToken(String phone) async {
    await repository.sendPhoneNumber(phone);
  }

  Future<void> sendToken(String token) async {
    bool isTokenValid = await repository.verifyToken(token);
    if (isTokenValid) {
      showSuccess("Token Validado com sucesso!");
      Modular.to.pushNamed(
        '/worklist/',
        arguments: (widget as ValidateTokenPage).phone,
      );
    } else {
      showError("Token Inválido");
    }
  }
}
