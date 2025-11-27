import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/providers/auth_provider.dart';
import '../../../data/models/request/verify_code_request.dart';
import '../../../routes/app_pages.dart';
import '../../../../core/utils/error_messages.dart';
import '../../../../core/theme/app_colors.dart';

class ActivateController extends GetxController {
  final AuthProvider authProvider = Get.find<AuthProvider>();

  // Récupérer le téléphone depuis les arguments
  late String telephone;

  // Form controller
  final codeSecretController = TextEditingController();

  // Loading state
  final isLoading = false.obs;

  // Error state
  final codeError = Rx<String?>(null);

  @override
  void onInit() {
    super.onInit();
    // Récupérer le téléphone passé en argument
    telephone = Get.arguments as String? ?? '';
  }

  @override
  void onClose() {
    codeSecretController.dispose();
    super.onClose();
  }

  Future<void> verifyCode() async {
    codeError.value = null;
    
    // Validation locale avec ErrorMessages
    if (codeSecretController.text.trim().isEmpty) {
      codeError.value = ErrorMessages.codeSecretRequis;
      return;
    }
    
    if (codeSecretController.text.trim().length < 4) {
      codeError.value = 'Le code doit contenir au moins 4 caractères';
      return;
    }
    
    isLoading.value = true;
    
    try {
      final request = VerifyCodeRequest(
        telephone: telephone,
        codeSecret: codeSecretController.text.trim(),
      );

      final response = await authProvider.verifyCode(request);

      if (response.isOk && response.body != null) {
        // Sauvegarder le token si fourni
        if (response.body!.token != null) {
          authProvider.setToken(response.body!.token!);
          // TODO: Sauvegarder le token dans le storage local
          // await StorageService.saveToken(response.body!.token!);
        }
        
        Get.snackbar(
          'Succès',
          ErrorMessages.verificationReussie,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: AppColors.greenSuccess,
          colorText: Colors.white,
          duration: const Duration(seconds: 2),
        );
        
        // Rediriger vers HOME
        Get.offAllNamed(Routes.HOME);
      } else {
        final errorMessage = response.statusText ?? ErrorMessages.verificationEchouee;
        codeError.value = ErrorMessages.parseBackendError(errorMessage);
      }
    } catch (e) {
      final errorMessage = ErrorMessages.parseBackendError(e);
      codeError.value = errorMessage;
    } finally {
      isLoading.value = false;
    }
  }

  // Renvoyer le code
  Future<void> resendCode() async {
    Get.snackbar(
      'Information',
      'Un nouveau code a été envoyé à votre adresse email',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.blue,
      colorText: Colors.white,
      duration: const Duration(seconds: 3),
    );
    // TODO: Implémenter l'appel API pour renvoyer le code si disponible
  }
}
