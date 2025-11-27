import 'package:get/get.dart';
import '../../../core/utils/constants.dart';
import '../models/response/transaction_response.dart';
import '../models/request/transfert_request.dart';
import '../models/request/paiement_request.dart';

class TransactionProvider extends GetConnect {
  @override
  void onInit() {
    super.onInit();
    httpClient.baseUrl = ApiConstants.baseUrl;
    timeout = const Duration(seconds: 30);
    httpClient.defaultContentType = 'application/json';
  }

  Future<Response<List<TransactionResponse>>> getHistorique(String numeroCompte) async {
    final endpoint = '${ApiConstants.historiqueEndpoint}/$numeroCompte';
    
    final response = await get<List<TransactionResponse>>(
      endpoint,
      decoder: (data) {
        if (data is Map && data['success'] == false) {
          return <TransactionResponse>[];
        }
        
        final responseData = data is Map ? data['data'] ?? data : data;
        
        if (responseData is List) {
          return responseData
              .map((json) => TransactionResponse.fromJson(json))
              .toList();
        }
        return <TransactionResponse>[];
      },
    );
    
    if (response.statusCode == 500) {
      return Response<List<TransactionResponse>>(
        statusCode: 200,
        body: [],
      );
    }
    
    return response;
  }

  Future<Response<TransactionResponse>> transfert(TransfertRequest request) async {
    final response = await post(
      ApiConstants.transfertEndpoint,
      request.toJson(),
      decoder: (data) {
        if (data is Map) {
          final responseData = data['data'] ?? data;
          return TransactionResponse.fromJson(responseData);
        }
        return TransactionResponse.fromJson(data);
      },
    );
    return response;
  }



  Future<Response<TransactionResponse>> paiement(PaiementRequest request) async {
    final response = await post(
      ApiConstants.paiementEndpoint,
      request.toJson(),
      decoder: (data) {
        if (data is Map) {
          final responseData = data['data'] ?? data;
          return TransactionResponse.fromJson(responseData);
        }
        return TransactionResponse.fromJson(data);
      },
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
