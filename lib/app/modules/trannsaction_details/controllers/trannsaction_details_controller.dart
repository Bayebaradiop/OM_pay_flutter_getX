import 'package:get/get.dart';
import '../../../data/models/response/transaction_response.dart';

class TrannsactionDetailsController extends GetxController {
  late TransactionResponse transaction;

  @override
  void onInit() {
    super.onInit();
    // La transaction est assignée manuellement avant l'initialisation
    // Pas besoin de Get.arguments car on utilise Get.bottomSheet
  }

  void shareTransaction() {
    Get.snackbar(
      'Partage',
      'Fonctionnalité de partage en cours de développement',
      snackPosition: SnackPosition.BOTTOM,
    );
  }
}
