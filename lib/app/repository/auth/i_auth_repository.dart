abstract class IAuthRepository {
  Future<bool> sendPhoneNumber(String phone);
  Future<bool> verifyToken(String token);
}
