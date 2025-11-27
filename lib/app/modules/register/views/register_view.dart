import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/register_controller.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../../../../core/widgets/custom_button.dart';

class RegisterView extends GetView<RegisterController> {
  const RegisterView({super.key});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: controller.formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text('Inscription', style: AppTextStyles.header1),
                const SizedBox(height: 8),
                Text(
                  'Créez votre compte Orange Money',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 32),
                
                // Nom
                Obx(() => CustomTextField(
                      hintText: 'Nom',
                      controller: controller.nomController,
                      prefixIcon: const Icon(Icons.person, color: AppColors.primaryOrange),
                      errorText: controller.nomError.value,
                      onChanged: (value) {
                        if (controller.nomError.value != null) {
                          controller.nomError.value = null;
                        }
                      },
                    )),
                const SizedBox(height: 16),
                
                // Prénom
                Obx(() => CustomTextField(
                      hintText: 'Prénom',
                      controller: controller.prenomController,
                      prefixIcon: const Icon(Icons.person_outline, color: AppColors.primaryOrange),
                      errorText: controller.prenomError.value,
                      onChanged: (value) {
                        if (controller.prenomError.value != null) {
                          controller.prenomError.value = null;
                        }
                      },
                    )),
                const SizedBox(height: 16),
                
                // Téléphone
                Obx(() => CustomTextField(
                      hintText: 'Numéro de téléphone',
                      controller: controller.phoneController,
                      keyboardType: TextInputType.phone,
                      prefixIcon: const Icon(Icons.phone, color: AppColors.primaryOrange),
                      errorText: controller.phoneError.value,
                      onChanged: (value) {
                        if (controller.phoneError.value != null) {
                          controller.phoneError.value = null;
                        }
                      },
                    )),
                const SizedBox(height: 16),
                
                // Email
                Obx(() => CustomTextField(
                      hintText: 'Email',
                      controller: controller.emailController,
                      keyboardType: TextInputType.emailAddress,
                      prefixIcon: const Icon(Icons.email, color: AppColors.primaryOrange),
                      errorText: controller.emailError.value,
                      onChanged: (value) {
                        if (controller.emailError.value != null) {
                          controller.emailError.value = null;
                        }
                      },
                    )),
                const SizedBox(height: 16),
                
                // Mot de passe
                Obx(() => CustomTextField(
                      hintText: 'Mot de passe',
                      controller: controller.passwordController,
                      isPassword: true,
                      prefixIcon: const Icon(Icons.lock, color: AppColors.primaryOrange),
                      errorText: controller.passwordError.value,
                      onChanged: (value) {
                        if (controller.passwordError.value != null) {
                          controller.passwordError.value = null;
                        }
                      },
                    )),
                const SizedBox(height: 16),
                
                // Confirmer mot de passe
                Obx(() => CustomTextField(
                      hintText: 'Confirmer le mot de passe',
                      controller: controller.confirmPasswordController,
                      isPassword: true,
                      prefixIcon: const Icon(Icons.lock_outline, color: AppColors.primaryOrange),
                      errorText: controller.confirmPasswordError.value,
                      onChanged: (value) {
                        if (controller.confirmPasswordError.value != null) {
                          controller.confirmPasswordError.value = null;
                        }
                      },
                    )),
                const SizedBox(height: 32),
                
                // Bouton inscription
                Obx(() => CustomButton(
                      text: 'S\'inscrire',
                      onPressed: controller.handleRegister,
                      isLoading: controller.isLoading.value,
                    )),
                const SizedBox(height: 24),
                
                // Connexion
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Déjà un compte ? ', style: AppTextStyles.bodyMedium),
                    TextButton(
                      onPressed: () => Get.back(),
                      child: Text(
                        'Se connecter',
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.primaryOrange,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}