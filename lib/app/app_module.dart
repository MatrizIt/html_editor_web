import 'package:flutter_modular/flutter_modular.dart';
import 'package:html_editor_web/app/features/home/home_module.dart';
import 'package:html_editor_web/app/features/relatory/relatory_module.dart';
import 'package:html_editor_web/app/features/result_preview/result_preview_module.dart';
import 'package:html_editor_web/app/features/validate_token/validate_token_module.dart';
import 'package:html_editor_web/app/features/worklist/worklist_module.dart';
import 'package:html_editor_web/app/repository/auth/auth_repository.dart';
import 'package:html_editor_web/app/repository/auth/i_auth_repository.dart';
import 'package:html_editor_web/app/repository/relatory/i_relatory_repository.dart';
import 'package:html_editor_web/app/repository/relatory/relatory_repository.dart';

class AppModule extends Module {
  @override
  void binds(Injector i) {
    i.addSingleton<IAuthRepository>(
      AuthRepository.new,
    );
    i.addSingleton<IRelatoryRepository>(
      RelatoryRepository.new,
    );
  }

  @override
  void routes(RouteManager r) {
    r.module('/home/', module: HomeModule());
    r.module('/relatory/', module: RelatoryModule());
    r.module('/result_preview/', module: ResultPreviewModule());
    r.module('/validate_token/', module: ValidateTokenModule());
    r.module('/worklist/', module: WorklistModule());
  }
}
