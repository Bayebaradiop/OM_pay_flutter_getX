import 'package:get/get.dart';
import '../../../core/utils/constants.dart';

class BaseProvider extends GetConnect {
  String? _token;

  @override
  void onInit() {
    super.onInit();
    httpClient.baseUrl = ApiConstants.baseUrl;
    httpClient.timeout = const Duration(seconds: 30);
    httpClient.defaultContentType = 'application/json';
    
    httpClient.addRequestModifier<dynamic>((request) {
      if (_token != null) {
        request.headers['Authorization'] = 'Bearer $_token';
      }
      return request;
    });
    

    httpClient.addResponseModifier((request, response) {
      return response;
    });
  }

  void setToken(String token) {
    _token = token;
  }

  void removeToken() {
    _token = null;
  }

  String? get token => _token;

  bool get hasToken => _token != null;
}