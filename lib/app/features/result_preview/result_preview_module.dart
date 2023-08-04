import 'package:flutter_modular/flutter_modular.dart';
import 'package:html_editor_web/app/features/result_preview/result_preview_page.dart';

class ResultPreviewModule extends Module {
  @override
  void binds(Injector i) {}

  @override
  void routes(RouteManager r) {
    r.child(
      '/',
      child: (context) => ResultPreviewPage(
        result: r.args.data,
      ),
    );
  }
}
