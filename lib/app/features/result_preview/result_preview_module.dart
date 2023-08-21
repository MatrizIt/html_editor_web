import 'package:flutter_modular/flutter_modular.dart';
import 'package:reportpad/app/features/result_preview/result_preview_page.dart';

class ResultPreviewModule extends Module {
  @override
  void binds(Injector i) {}

  @override
  void routes(RouteManager r) {
    r.child(
      '/',
      child: (context) {
        final Map<String, dynamic> routeArgs = r.args?.data ?? {};

        final String result = routeArgs['result'] ?? "0";

        final String idSurvey = routeArgs['idSurvey'] ?? "0";

        final String phone = routeArgs['phone'] ?? "";

        final String idProcedure = routeArgs['procedure'] ?? "";

        return ResultPreviewPage(
          result: result,
          phone: phone,
          idSurvey: idSurvey,
          idProcedure: idProcedure,
        );
      }
    );
  }
}
