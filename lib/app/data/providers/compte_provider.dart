import 'package:get/get.dart';
import '../../../core/utils/constants.dart';
import 'base_provider.dart';

class CompteProvider extends BaseProvider {

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
}
