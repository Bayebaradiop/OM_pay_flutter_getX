import 'package:get/get.dart';
import '../providers/transaction_provider.dart';
import '../models/response/transaction_response.dart';
import '../models/request/transfert_request.dart';
import '../models/request/paiement_request.dart';
import './compte_service.dart';

class TransactionService extends GetxService {
  final TransactionProvider _transactionProvider = Get.find<TransactionProvider>();
  final CompteService _compteService = Get.find<CompteService>();

  final RxList<TransactionResponse> transactions = <TransactionResponse>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool isProcessing = false.obs;

  Future<void> getHistorique() async {
    try {
      isLoading.value = true;
      
      final numeroCompte = await _compteService.getNumeroCompte();
      
      if (numeroCompte == null) {
        transactions.value = [];
        isLoading.value = false;
        return;
      }
      
      final response = await _transactionProvider.getHistorique(numeroCompte);
      
      if (response.statusCode == 200 || response.statusCode == 500) {
        if (response.body != null) {
          transactions.value = response.body!;
        } else {
          transactions.value = [];
        }
      } else {
        transactions.value = [];
      }
    } catch (e) {
      transactions.value = [];
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> refreshHistorique() async {
    await getHistorique();
  }

  Future<bool> effectuerTransfert({
    required String numeroDestinataire,
    required double montant,
  }) async {
    try {
      isProcessing.value = true;
      
      final request = TransfertRequest(
        telephoneDestinataire: numeroDestinataire,
        montant: montant,
      );
      
      final response = await _transactionProvider.transfert(request);
      
      if ((response.statusCode == 200 || response.statusCode == 201) && response.body != null) {
        await getHistorique();
        return true;
      }
      
      return false;
    } catch (e) {
      print(' Exception transfert: $e');
      return false;
    } finally {
      isProcessing.value = false;
    }
  }



  Future<bool> effectuerPaiement({
    required String numeroMarchand,
    required double montant,
  }) async {
    try {
      isProcessing.value = true;
      
      final request = PaiementRequest(
        codeMarchand: numeroMarchand,
        montant: montant,
      );
      
      final response = await _transactionProvider.paiement(request);
      
      if ((response.statusCode == 200 || response.statusCode == 201) && response.body != null) {
        await getHistorique();
        return true;
      }
      
      return false;
    } catch (e) {
      print(' Exception paiement: $e');
      return false;
    } finally {
      isProcessing.value = false;
    }
  }

  void resetTransactions() {
    transactions.clear();
  }
}
