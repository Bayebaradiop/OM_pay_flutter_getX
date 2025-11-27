import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/providers/auth_provider.dart';
import '../../../data/models/request/register_request.dart';
import '../../../routes/app_pages.dart';
import '../../../../core/utils/error_messages.dart';
import '../../../../core/theme/app_colors.dart';

class RegisterController extends GetxController {
  final AuthProvider authProvider = Get.find<AuthProvider>();

  // Form controllers
  final nomController = TextEditingController();
  final prenomController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  // Loading states
  final isLoading = false.obs;

  // Error states
  final nomError = Rx<String?>(null);
  final prenomError = Rx<String?>(null);
  final phoneError = Rx<String?>(null);
  final emailError = Rx<String?>(null);
  final passwordError = Rx<String?>(null);
  final confirmPasswordError = Rx<String?>(null);

  // Form key
  final formKey = GlobalKey<FormState>();

  @override
  void onClose() {
    nomController.dispose();
    prenomController.dispose();
    phoneController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }

  void clearErrors() {
    nomError.value = null;
    prenomError.value = null;
    phoneError.value = null;
    emailError.value = null;
    passwordError.value = null;
    confirmPasswordError.value = null;
  }

  Future<void> handleRegister() async {
    clearErrors();
    
    // Validation locale avec ErrorMessages
    bool hasError = false;
    
    if (nomController.text.trim().isEmpty) {
      nomError.value = ErrorMessages.nomRequis;
      hasError = true;
    }
    
    if (prenomController.text.trim().isEmpty) {
      prenomError.value = ErrorMessages.prenomRequis;
      hasError = true;
    }
    
    if (phoneController.text.trim().isEmpty) {
      phoneError.value = ErrorMessages.telephoneRequis;
      hasError = true;
    } else if (phoneController.text.trim().length < 9) {
      phoneError.value = ErrorMessages.telephoneInvalide;
      hasError = true;
    }
    
    if (emailController.text.trim().isEmpty) {
      emailError.value = ErrorMessages.emailRequis;
      hasError = true;
    } else if (!emailController.text.contains('@')) {
      emailError.value = ErrorMessages.emailInvalide;
      hasError = true;
    }
    
    if (passwordController.text.isEmpty) {
      passwordError.value = ErrorMessages.motDePasseRequis;
      hasError = true;
    } else if (passwordController.text.length < 6) {
      passwordError.value = ErrorMessages.motDePasseCourt;
      hasError = true;
    }
    
    if (confirmPasswordController.text.isEmpty) {
      confirmPasswordError.value = 'Veuillez confirmer votre mot de passe';
      hasError = true;
    } else if (confirmPasswordController.text != passwordController.text) {
      confirmPasswordError.value = 'Les mots de passe ne correspondent pas';
      hasError = true;
    }
    
    if (hasError) return;
    
    isLoading.value = true;
    
    try {
      final request = RegisterRequest(
        nom: nomController.text.trim(),
        prenom: prenomController.text.trim(),
        telephone: phoneController.text.trim(),
        email: emailController.text.trim(),
        motDePasse: passwordController.text,
      );

      final response = await authProvider.register(request);

      print('📊 Status: ${response.statusCode}, Body: ${response.body}');

      if (response.isOk && response.body != null) {
        Get.snackbar(
          'Succès',
          response.body!.message.isNotEmpty 
              ? response.body!.message 
              : ErrorMessages.inscriptionReussie,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: AppColors.greenSuccess,
          colorText: Colors.white,
          duration: const Duration(seconds: 3),
        );
        
        // Rediriger vers la page d'activation avec le téléphone
        Get.offNamed(
          Routes.ACTIVATE,
          arguments: phoneController.text.trim(),
        );
      } else {
        // Utiliser ErrorMessages pour parser l'erreur
        String errorMessage = response.statusText ?? ErrorMessages.inscriptionEchouee;
        errorMessage = ErrorMessages.parseBackendError(errorMessage);
        
        print('❌ Erreur: $errorMessage');
        _handleError(errorMessage);
      }
    } catch (e) {
      print('❌ Exception: $e');
      final errorMessage = ErrorMessages.parseBackendError(e);
      _handleError(errorMessage);
    } finally {
      isLoading.value = false;
    }
  }

  void _handleError(String errorMessage) {
    final lowerError = errorMessage.toLowerCase();
    
    // Analyser et afficher l'erreur sous le champ approprié
    if (lowerError.contains('nom') && !lowerError.contains('prénom')) {
      nomError.value = errorMessage;
    } else if (lowerError.contains('prénom')) {
      prenomError.value = errorMessage;
    } else if (lowerError.contains('téléphone') || lowerError.contains('existe') || lowerError.contains('utilisé')) {
      phoneError.value = errorMessage;
    } else if (lowerError.contains('email') || lowerError.contains('e-mail')) {
      emailError.value = errorMessage;
    } else if (lowerError.contains('mot de passe')) {
      passwordError.value = errorMessage;
    } else {
      // Erreur générale en snackbar
      Get.snackbar(
        'Erreur',
        errorMessage,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColors.redError,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );
    }
  }
}
