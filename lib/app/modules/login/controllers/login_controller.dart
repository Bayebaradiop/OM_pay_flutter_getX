import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/services/auth_service.dart';
import '../../../routes/app_pages.dart';

class LoginController extends GetxController {
  final AuthService _authService = Get.find<AuthService>();

  final phoneController = TextEditingController();
  final passwordController = TextEditingController();

  final isLoading = false.obs;
  final isPasswordVisible = false.obs;
  final phoneError = Rxn<String>();
  final passwordError = Rxn<String>();

  @override
  void onClose() {
    phoneController.dispose();
    passwordController.dispose();
    super.onClose();
  }

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  bool _validateForm() {
    bool isValid = true;
    phoneError.value = null;
    passwordError.value = null;

    if (phoneController.text.isEmpty) {
      phoneError.value = 'Le numéro de téléphone est requis';
      isValid = false;
    } else if (phoneController.text.length < 9) {
      phoneError.value = 'Numéro invalide (min 9 chiffres)';
      isValid = false;
    }

    if (passwordController.text.isEmpty) {
      passwordError.value = 'Le mot de passe est requis';
      isValid = false;
    } else if (passwordController.text.length < 4) {
      passwordError.value = 'Mot de passe trop court (min 4 caractères)';
      isValid = false;
    }

    return isValid;
  }

  // Login
  Future<void> login() async {
    if (!_validateForm()) return;

    try {
      isLoading.value = true;

      final response = await _authService.login(
        phoneController.text.trim(),
        passwordController.text,
      );

      if (response.success) {
        Get.snackbar(
          'Succès',
          response.message,
          backgroundColor: Colors.green,
          colorText: Colors.white,
          snackPosition: SnackPosition.TOP,
        );

        // Navigation selon le cas
        if (response.codeSecret != null) {
          // Première connexion -> Vérifier code secret
          Get.toNamed(
            Routes.ACTIVATE,
            arguments: {
              'telephone': phoneController.text.trim(),
              'codeSecret': response.codeSecret,
            },
          );
        } else {

          Get.offAllNamed(Routes.HOME);
        }
      } else {
        Get.snackbar(
          'Erreur',
          response.message,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          snackPosition: SnackPosition.TOP,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Erreur',
        e.toString(),
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
      );
    } finally {
      isLoading.value = false;
    }
  }


  void goToRegister() {
    Get.toNamed(Routes.REGISTER);
  }
}
