import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:reportpad/app/app_module.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app/app_widget.dart';

void main() async {
  late SharedPreferences localStorage;
  WidgetsFlutterBinding.ensureInitialized();
  localStorage = await SharedPreferences.getInstance();// Garantir inicialização dos Widgets
  await FlutterDownloader.initialize();
  runApp(
    ModularApp(
      module: AppModule(),
      child: const AppWidget(),
    ),
  );
}
