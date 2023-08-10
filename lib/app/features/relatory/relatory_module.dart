import 'package:flutter_modular/flutter_modular.dart';
import 'package:reportpad/app/features/relatory/relatory_page.dart';
import 'package:reportpad/app/model/scrip_model.dart';

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

        final String idSurvey = routeArgs['idSurvey'] ?? "0";

        return RelatoryPage(
          scrips: scrips,
          title: title,
          idSurvey: idSurvey,
        );
      },
    );
  }
}
