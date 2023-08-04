import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppWidget extends StatelessWidget {
  const AppWidget({super.key});

  @override
  Widget build(BuildContext context) {
    Modular.setInitialRoute('/home/');

    return ScreenUtilInit(
      builder: (context, child) {
        return MaterialApp.router(
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate
          ],
          supportedLocales: const [
            Locale(
              'pt',
              'BR',
            ),
          ],
          debugShowCheckedModeBanner: false,
          title: 'Html Editor',
          theme: ThemeData(
            useMaterial3: true,
          ),
          routerConfig: Modular.routerConfig,
        );
      },
    );
  }
}
