import '../../../../core/constants/api_constants.dart';
import '../../../../core/network/dio_client.dart';
import '../models/auth_response_model.dart';
import '../models/user_model.dart';

class AuthRemoteDataSource {
  final ApiClient _client;
  AuthRemoteDataSource(this._client);

  Future<AuthResponseModel> login(String email, String password) async {
    final json = await _client.post(
      ApiConstants.login,
      body: {'email': email, 'password': password},
      withAuth: false,
    );
    return AuthResponseModel.fromJson(json['data'] as Map<String, dynamic>);
  }

  Future<void> register(String userName, String email, String password) async {
    await _client.post(
      ApiConstants.register,
      body: {'userName': userName, 'email': email, 'password': password},
      withAuth: false,
    );
  }

  Future<UserModel> getMe() async {
    final json = await _client.get(ApiConstants.me);
    return UserModel.fromJson(json['data'] as Map<String, dynamic>);
  }
}
