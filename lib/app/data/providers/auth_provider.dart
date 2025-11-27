import 'package:get/get.dart';
import '../../../core/utils/constants.dart';
import '../models/request/login_request.dart';
import '../models/request/register_request.dart';
import '../models/request/verify_code_request.dart';
import '../models/response/auth_response.dart';

class AuthProvider extends GetConnect {
  @override
  void onInit() {
    super.onInit();
    httpClient.baseUrl = ApiConstants.baseUrl;
    timeout = const Duration(seconds: 30);
    httpClient.defaultContentType = 'application/json';
  }

   Future <Response <AuthResponse>> login(LoginRequest request) async{
      return await post(
        ApiConstants.loginEndpoint,
        request.toJson(),
        decoder: (data) => AuthResponse.fromJson(data),
      );
   }

   Future <Response<AuthResponse>> register(RegisterRequest request) async {
    return await post(ApiConstants.registerEndpoint,
    request.toJson(),

decoder: (data) => AuthResponse.fromJson(data),
    
    );
   }

  Future<Response<AuthResponse>> verifyCode(VerifyCodeRequest request) async {
    return await post(
      ApiConstants.verifyCodeSecretEndpoint,
      request.toJson(),
      decoder: (data) => AuthResponse.fromJson(data),
    );
  }
  void setToken(String token) {
    httpClient.addRequestModifier<dynamic>((request) {
      request.headers['Authorization'] = 'Bearer $token';
      return request;
    });
  }

  void removeToken() {
    httpClient.addRequestModifier<dynamic>((request) {
      request.headers.remove('Authorization');
      return request;
    });
  }

}
