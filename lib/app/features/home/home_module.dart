import 'package:flutter_modular/flutter_modular.dart';
import 'package:reportpad/app/features/home/home_page.dart';

class HomeModule extends Module {
  @override
  void binds(Injector i) {}

  @override
  void routes(RouteManager r) {
    r.child(
      '/',
      child: (context) => const HomePage(),
    );
  }
}
