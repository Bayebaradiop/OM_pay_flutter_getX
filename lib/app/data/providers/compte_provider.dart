import 'package:get/get.dart';
import '../../../core/utils/constants.dart';

class CompteProvider extends GetConnect {
  @override
  void onInit() {
    super.onInit();
    httpClient.baseUrl = ApiConstants.baseUrl;
    timeout = const Duration(seconds: 30);
    httpClient.defaultContentType = 'application/json';
  }

  Future<Response<double>> getSolde() async {
    final response = await get(
      ApiConstants.soldeEndpoint,
      decoder: (data) {
        if (data is num) {
          return data.toDouble();
        }

        if (data is Map && data.containsKey('data')) {
          return (data['data'] as num).toDouble();
        }

        if (data is Map && data.containsKey('solde')) {
          return (data['solde'] as num).toDouble();
        }
        
        return 0.0;
      },
    );
    return response;
  }

  Future<Response<Map<String, dynamic>>> getProfil() async {
    final response = await get<Map<String, dynamic>>(
      ApiConstants.profilEndpoint,
    );
    return response;
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
