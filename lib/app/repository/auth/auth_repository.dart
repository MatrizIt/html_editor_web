import 'package:html_editor_web/app/repository/auth/i_auth_repository.dart';
import 'package:html_editor_web/app/repository/repository.dart';

class AuthRepository extends Repository implements IAuthRepository {
  @override
  Future<bool> sendPhoneNumber(String phone) async {
    final response = await get("EnviarToken?telefone=$phone");
    return response?.statusCode == 200 ? true : false;
  }

  @override
  Future<bool> verifyToken(String token) async {
    var number = 5511985858505;
    var tokenComposto = ((int.parse(token)) * number);

    final response =
        await get("VerificarToken?token=$token&tokencomposto=$tokenComposto");
    return response?.statusCode == 200 ? true : false;
  }
}
