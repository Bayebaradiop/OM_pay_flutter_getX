import 'package:get/get.dart';
import '../../../core/utils/constants.dart';
import '../../../core/utils/error_messages.dart';
import '../models/request/login_request.dart';
import '../models/request/register_request.dart';
import '../models/request/verify_code_request.dart';
import '../models/response/auth_response.dart';
import 'base_provider.dart';

class AuthProvider extends BaseProvider {


   Future <Response<AuthResponse>> login(LoginRequest request) async {
      final response = await post(
        ApiConstants.loginEndpoint,
        request.toJson(),
      );
      
      if (response.statusCode == 200 || response.statusCode == 201) {
        return Response(
          statusCode: response.statusCode,
          body: AuthResponse.fromJson(response.body),
        );
      }
      
      return Response(
        statusCode: response.statusCode,
        body: response.body != null ? AuthResponse.fromJson(response.body) : null,
        statusText: _extractErrorMessage(response),
      );
   }



   Future <Response<AuthResponse>> register(RegisterRequest request) async {    
    final response = await post(
      ApiConstants.registerEndpoint,
      request.toJson(),
    );
    
    if (response.statusCode == 200 || response.statusCode == 201) {
      return Response(
        statusCode: response.statusCode,
        body: AuthResponse.fromJson(response.body),
      );
    }
    
    return Response(
      statusCode: response.statusCode,
      body: response.body != null ? AuthResponse.fromJson(response.body) : null,
      statusText: _extractErrorMessage(response),
    );
   }


  Future<Response<AuthResponse>> verifyCode(VerifyCodeRequest request) async {
    
    final response = await post(
      ApiConstants.verifyCodeSecretEndpoint,
      request.toJson(),
    );
    
    if (response.statusCode == 200 || response.statusCode == 201) {
      return Response(
        statusCode: response.statusCode,
        body: AuthResponse.fromJson(response.body),
      );
    }
    
    return Response(
      statusCode: response.statusCode,
      body: response.body != null ? AuthResponse.fromJson(response.body) : null,
      statusText: _extractErrorMessage(response),
    );
  }
  
  // Extraire le message d'erreur de la réponse en utilisant ErrorMessages
  String _extractErrorMessage(Response response) {
    String errorString = '';
    
    if (response.body != null) {
      if (response.body is Map) {
        errorString = response.body['message'] ?? response.body['error'] ?? '';
      }
    }
    
    if (errorString.isEmpty) {
      errorString = 'HTTP ${response.statusCode}';
    }
     return ErrorMessages.parseBackendError(errorString);
  }
}
