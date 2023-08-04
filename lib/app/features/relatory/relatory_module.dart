import 'package:flutter_modular/flutter_modular.dart';
import 'package:html_editor_web/app/features/relatory/relatory_page.dart';

class RelatoryModule extends Module {
  @override
  void binds(Injector i) {}

  @override
  void routes(RouteManager r) {
    r.child(
      '/',
      child: (context) => RelatoryPage(scrips: r.args.data),
    );
  }
}
