import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/services/auth_service.dart';
import '../../../data/services/compte_service.dart';
import '../../../data/services/transaction_service.dart';
import '../../../data/models/response/transaction_response.dart';
import '../../../routes/app_pages.dart';
import '../../../../core/widgets/transaction_type_toggle.dart';
import '../../trannsaction_details/views/trannsaction_details_view.dart';

class HomeController extends GetxController {
  final AuthService _authService = Get.find<AuthService>();
  final CompteService _compteService = Get.find<CompteService>();
  final TransactionService _transactionService = Get.find<TransactionService>();

  // Type de transaction sélectionné
  final Rx<TransactionType> selectedTransactionType = TransactionType.transfer.obs;

  // Controllers pour les champs
  final numeroController = TextEditingController();
  final montantController = TextEditingController();

  RxDouble get solde => _compteService.solde;
  RxBool get isLoadingSolde => _compteService.isLoading;
  
  String get userName {
    final user = _authService.currentUser.value;
    return user?.fullName ?? 'Utilisateur';
  }
  
  String get userPhone {
    final user = _authService.currentUser.value;
    return user?.telephone ?? '';
  }

  // Getters pour les transactions
  RxList<TransactionResponse> get transactions => _transactionService.transactions;
  bool get isLoadingTransactions => _transactionService.isLoading.value;
  bool get isProcessing => _transactionService.isProcessing.value;

  @override
  void onInit() {
    super.onInit();
    loadData();
  }

  @override
  void onClose() {
    numeroController.dispose();
    montantController.dispose();
    super.onClose();
  }

  Future<void> loadData() async {
    try {
      await _compteService.refreshSolde();
      await _transactionService.getHistorique();
    } catch (e) {
      Get.snackbar(
        'Erreur',
        e.toString(),
        snackPosition: SnackPosition.TOP,
      );
    }
  }

  Future<void> refreshData() async {
    await loadData();
  }

  void changeTransactionType(TransactionType type) {
    selectedTransactionType.value = type;
  }

  Future<void> validerTransaction() async {
    final numero = numeroController.text.trim();
    final montantText = montantController.text.trim();

    // Validation
    if (numero.isEmpty) {
      Get.snackbar(
        'Erreur',
        'Veuillez saisir un numéro',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    if (montantText.isEmpty) {
      Get.snackbar(
        'Erreur',
        'Veuillez saisir un montant',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    final montant = double.tryParse(montantText);
    if (montant == null || montant <= 0) {
      Get.snackbar(
        'Erreur',
        'Montant invalide',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    // Vérifier le solde
    if (montant > solde.value) {
      Get.snackbar(
        'Erreur',
        'Solde insuffisant',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    bool success = false;

    // Effectuer la transaction selon le type
    if (selectedTransactionType.value == TransactionType.transfer) {
      success = await _transactionService.effectuerTransfert(
        numeroDestinataire: numero,
        montant: montant,
      );
    } else {
      success = await _transactionService.effectuerPaiement(
        numeroMarchand: numero,
        montant: montant,
      );
    }

    // Afficher le résultat
    if (success) {
      Get.snackbar(
        'Succès',
        'Transaction effectuée avec succès',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
      
      // Vider les champs
      numeroController.clear();
      montantController.clear();
      
      // Rafraîchir le solde
      await _compteService.refreshSolde();
    } else {
      Get.snackbar(
        'Erreur',
        'Échec de la transaction',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  void showTransactionDetail(TransactionResponse transaction) {
    Get.bottomSheet(
      TrannsactionDetailsView(transaction: transaction),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    );
  }

  Future<void> logout() async {
    await _authService.logout();
    _compteService.resetSolde();
    _transactionService.resetTransactions();
    Get.offAllNamed(Routes.LOGIN);
  }
}
