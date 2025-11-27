import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/activate_controller.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../../../../core/widgets/custom_button.dart';

class ActivateView extends GetView<ActivateController> {
  const ActivateView({super.key});
  
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Icône
              Center(
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: AppColors.primaryOrange.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.mail_outline,
                    size: 40,
                    color: AppColors.primaryOrange,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              
              // Titre
              Text(
                'Vérification',
                style: AppTextStyles.header1,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              
              // Description
              Text(
                'Un code de vérification a été envoyé à votre adresse email',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              
              // Numéro de téléphone
              Text(
                controller.telephone,
                style: AppTextStyles.bodyLarge.copyWith(
                  color: AppColors.primaryOrange,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              
              // Champ code secret
              Obx(() => CustomTextField(
                    hintText: 'Code de vérification',
                    controller: controller.codeSecretController,
                    keyboardType: TextInputType.number,
                    prefixIcon: const Icon(Icons.vpn_key, color: AppColors.primaryOrange),
                    errorText: controller.codeError.value,
                    maxLength: 6,
                    onChanged: (value) {
                      if (controller.codeError.value != null) {
                        controller.codeError.value = null;
                      }
                    },
                  )),
              const SizedBox(height: 24),
              
              // Bouton vérifier
              Obx(() => CustomButton(
                    text: 'Vérifier',
                    onPressed: controller.verifyCode,
                    isLoading: controller.isLoading.value,
                  )),
              const SizedBox(height: 16),
              
              // Renvoyer le code
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Code non reçu ? ',
                    style: AppTextStyles.bodyMedium,
                  ),
                  TextButton(
                    onPressed: controller.resendCode,
                    child: Text(
                      'Renvoyer',
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
    );
  }
}
