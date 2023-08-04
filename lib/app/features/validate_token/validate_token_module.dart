import 'package:flutter_modular/flutter_modular.dart';
import 'package:html_editor_web/app/features/validate_token/validate_token_page.dart';

class ValidateTokenModule extends Module {
  @override
  void binds(Injector i) {}

  @override
  void routes(RouteManager r) {
    r.child(
      '/',
      child: (context) => ValidateTokenPage(
        phone: r.args.data,
      ),
    );
  }
}
