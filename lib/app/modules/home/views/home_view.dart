import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/widgets/balance_card.dart';
import '../../../../core/widgets/transaction_type_toggle.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/custom_drawer.dart';
import '../../../../core/widgets/transaction_card.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../data/models/response/transaction_response.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Obx(() => CustomDrawer(
        userName: controller.userName,
        userPhone: controller.userPhone,
        isDarkMode: true,
        isScannerEnabled: true,
        selectedLanguage: 'Français',
        onThemeToggle: () {},
        onScannerToggle: () {},
        onLanguageChanged: (_) {},
        onLogout: controller.logout,
      )),
      body: Builder(
        builder: (context) => Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Balance Card avec vraies données
            Obx(() => BalanceCard(
              balance: controller.solde.value,
              userName: controller.userName,
              onQrCodeTap: () {
                showDialog(
                  context: context,
                  builder: (_) => AlertDialog(
                    backgroundColor: AppColors.cardBackground,
                    title: Text('Mon QR Code', style: AppTextStyles.header3),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 200,
                          height: 200,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: const Center(child: Icon(Icons.qr_code, size: 120)),
                        ),
                        const SizedBox(height: 12),
                        Text(controller.userPhone, style: AppTextStyles.bodyLarge),
                      ],
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text('Fermer', style: AppTextStyles.bodyLarge.copyWith(color: AppColors.primaryOrange)),
                      ),
                    ],
                  ),
                );
              },
              onMenuTap: () => Scaffold.of(context).openDrawer(),
            )),

            // Transaction form (design only)
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 13),
              clipBehavior: Clip.hardEdge,
              decoration: const BoxDecoration(
                color: Color(0xFF2A2A2A),
                borderRadius: BorderRadius.all(Radius.circular(15)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.white24,
                    blurRadius: 10,
                    offset: Offset(0, 5),
                    spreadRadius: 2,
                  )
                ],
              ),
              child: Stack(
                children: [
                  Positioned(
                    top: -10,
                    bottom: -10,
                    right: 0,
                    left: 0,
                    child: Opacity(
                      opacity: 0.8,
                      child: Image.asset(
                        'assets/images/rainbow_bg.png',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Obx(() => TransactionTypeToggle(
                          selectedType: controller.selectedTransactionType.value,
                          onChanged: controller.changeTransactionType,
                        )),
                        const SizedBox(height: 8),
                        Obx(() => Align(
                          alignment: Alignment.centerLeft,
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width * 0.5,
                            child: CustomTextField(
                              controller: controller.numeroController,
                              hintText: controller.selectedTransactionType.value == TransactionType.pay
                                  ? 'Numéro marchand'
                                  : 'Saisir le numéro',
                              keyboardType: TextInputType.phone,
                              onChanged: (value) {},
                            ),
                          ),
                        )),
                        const SizedBox(height: 8),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width * 0.5,
                            child: CustomTextField(
                              controller: controller.montantController,
                              hintText: 'Saisir le montant',
                              keyboardType: TextInputType.number,
                              onChanged: (value) {},
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Obx(() => CustomButton(
                          text: 'Valider',
                          onPressed: controller.isProcessing ? () {} : () => controller.validerTransaction(),
                          isLoading: controller.isProcessing,
                        )),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Recent transactions - Liste dynamique
            const SizedBox(height: 8),
            Expanded(
              child: Obx(() {
                if (controller.isLoadingTransactions) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: AppColors.primaryOrange,
                    ),
                  );
                }

                if (controller.transactions.isEmpty) {
                  return Center(
                    child: Text(
                      'Aucune transaction',
                      style: AppTextStyles.bodyLarge.copyWith(
                        color: Colors.white54,
                      ),
                    ),
                  );
                }

                return RefreshIndicator(
                  onRefresh: controller.refreshData,
                  color: AppColors.primaryOrange,
                  backgroundColor: AppColors.cardBackground,
                  child: ListView.builder(
                    padding: const EdgeInsets.only(top: 8, bottom: 16),
                    itemCount: controller.transactions.length,
                    itemBuilder: (context, index) {
                      final transaction = controller.transactions[index];
                      return GestureDetector(
                        onTap: () => controller.showTransactionDetail(transaction),
                        child: TransactionCard(
                          icon: _getIconForType(transaction.typeTransaction),
                          title: _getTitleForType(transaction.typeTransaction),
                          subtitle: _getSubtitle(transaction),
                          amount: transaction.formattedMontant,
                          date: _formatDateShort(transaction.dateCreation),
                          isPositive: _isPositiveTransaction(transaction.typeTransaction),
                        ),
                      );
                    },
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getIconForType(String type) {
    switch (type.toUpperCase()) {
      case 'TRANSFERT':
        return Icons.send_outlined;
      case 'DEPOT':
        return Icons.account_balance_wallet_outlined;
      case 'RETRAIT':
        return Icons.atm_outlined;
      case 'PAIEMENT':
        return Icons.shopping_bag_outlined;
      default:
        return Icons.receipt_outlined;
    }
  }

  String _getTitleForType(String type) {
    switch (type.toUpperCase()) {
      case 'TRANSFERT':
        return 'Transfert';
      case 'DEPOT':
        return 'Dépôt';
      case 'RETRAIT':
        return 'Retrait';
      case 'PAIEMENT':
        return 'Paiement';
      default:
        return type;
    }
  }

  String _getSubtitle(TransactionResponse transaction) {
    switch (transaction.typeTransaction.toUpperCase()) {
      case 'TRANSFERT':
        return 'Vers ${transaction.compteDestinataire ?? "Inconnu"}';
      case 'DEPOT':
        return transaction.telephoneDistributeur != null 
            ? 'Via ${transaction.telephoneDistributeur}' 
            : 'Guichet';
      case 'RETRAIT':
        return transaction.telephoneDistributeur != null 
            ? 'Via ${transaction.telephoneDistributeur}' 
            : 'Retrait d\'argent';
      case 'PAIEMENT':
        return transaction.nomMarchand ?? 'Marchand';
      default:
        return transaction.description ?? '';
    }
  }

  String _formatDateShort(String dateStr) {
    try {
      final date = DateTime.parse(dateStr);
      return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
    } catch (e) {
      return dateStr;
    }
  }

  bool _isPositiveTransaction(String type) {
    return type.toUpperCase() == 'DEPOT';
  }
}
