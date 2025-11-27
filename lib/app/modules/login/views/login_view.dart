import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/carousel_image.dart';
import '../controllers/login_controller.dart';

class LoginView extends GetView<LoginController> {
  const LoginView({super.key});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const CarouselImage(),
              
              Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 20),
                    
                    Text(
                      'Bienvenue sur OM Pay!',
                      style: AppTextStyles.header2,
                      textAlign: TextAlign.center,
                    ),
                    
                    const SizedBox(height: 8),
                    
                    Text(
                      'Entrez votre numéro mobile pour vous connecter',
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.textSecondary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    
                    const SizedBox(height: 32),
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
                    
                    const SizedBox(height: 20),
                    
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
                    
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {
                        },
                        child: Text(
                          'Mot de passe oublié ?',
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: AppColors.primaryOrange,
                          ),
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 32),
                    
                    Obx(() => CustomButton(
                      text: 'Se connecter',
                      onPressed: controller.login,
                      isLoading: controller.isLoading.value,
                    )),
                    
                    const SizedBox(height: 24),
                    
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Pas encore de compte ? ',
                          style: AppTextStyles.bodyMedium,
                        ),
                        TextButton(
                          onPressed: controller.goToRegister,
                          child: Text(
                            'S\'inscrire',
                            style: AppTextStyles.bodyMedium.copyWith(
                              color: AppColors.primaryOrange,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 16),
                    
                    Center(
                      child: TextButton(
                        onPressed: () {
                          Get.toNamed('/activate', arguments: controller.phoneController.text.trim());
                        },
                        child: Text(
                          'Activer mon compte',
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: AppColors.textSecondary,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
