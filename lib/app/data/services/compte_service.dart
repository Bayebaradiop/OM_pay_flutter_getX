import 'package:get/get.dart';
import '../providers/compte_provider.dart';
import '../models/response/profile_response.dart';

class CompteService extends GetxService {
  final CompteProvider _compteProvider = Get.find<CompteProvider>();

  final RxDouble solde = 0.0.obs;
  final RxBool isLoading = false.obs;
  String? _cachedNumeroCompte;

  Future<double> getSolde() async {
    try {
      isLoading.value = true;
      final response = await _compteProvider.getSolde();

      if (response.body != null) {
        solde.value = response.body!;
        return response.body!;
      }

      throw Exception('Impossible de récupérer le solde');
    } catch (e) {
      throw Exception('Erreur lors de la récupération du solde: ${e.toString()}');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> refreshSolde() async {
    await getSolde();
  }

  void resetSolde() {
    solde.value = 0.0;
  }

  Future<String?> getNumeroCompte() async {
    if (_cachedNumeroCompte != null) {
      return _cachedNumeroCompte;
    }

    try {
      final response = await _compteProvider.getProfil();

      if (response.statusCode == 200 && response.body != null) {
        final data = response.body!['data'] ?? response.body;
        
        if (data['compte'] != null && data['compte']['numeroCompte'] != null) {
          _cachedNumeroCompte = data['compte']['numeroCompte'] as String;
          return _cachedNumeroCompte;
        }
        
        if (data['numeroCompte'] != null) {
          _cachedNumeroCompte = data['numeroCompte'] as String;
          return _cachedNumeroCompte;
        }

        return null;
      }

      return null;
    } catch (e) {
      return null;
    }
  }

  void resetCache() {
    _cachedNumeroCompte = null;
  }
}
