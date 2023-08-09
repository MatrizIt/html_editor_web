import 'package:flutter_modular/flutter_modular.dart';
import 'package:html_editor_web/app/features/relatory/relatory_page.dart';
import 'package:html_editor_web/app/model/scrip_model.dart';

class RelatoryModule extends Module {
  @override
  void binds(Injector i) {}

  @override
  void routes(RouteManager r) {
    r.child(
      '/',
      child: (context) {
        final Map<String, dynamic> routeArgs = r.args?.data ?? {};

        final List<ScripModel> scrips = routeArgs['Scrips'] ?? [];

        final String title = routeArgs['Title'] ?? 'Default Title';

       return RelatoryPage(scrips: scrips, title: title,);},
    );
  }
}
