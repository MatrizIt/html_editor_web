import 'package:flutter_modular/flutter_modular.dart';
import 'package:reportpad/app/features/worklist/worklist_page.dart';
import 'package:reportpad/app/repository/relatory/i_relatory_repository.dart';
import 'package:reportpad/app/repository/relatory/relatory_repository.dart';

class WorklistModule extends Module {
  @override
  void binds(Injector i) {}

  @override
  void routes(RouteManager r) {
    r.child(
      '/',
      child: (context) => WorklistPage(phone: r.args.data),
    );
  }
}
