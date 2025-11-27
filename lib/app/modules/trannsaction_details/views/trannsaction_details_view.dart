import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../data/models/response/transaction_response.dart';

class TrannsactionDetailsView extends StatelessWidget {
  final TransactionResponse transaction;
  
  const TrannsactionDetailsView({super.key, required this.transaction});
  
  @override
  Widget build(BuildContext context) {
    
    return DraggableScrollableSheet(
      initialChildSize: 0.7, 
      minChildSize: 0.5,
      maxChildSize: 0.9,
      builder: (context, scrollController) {
        return Container(
          width: double.infinity,
          decoration: const BoxDecoration(
            color: AppColors.darkBackground,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: SingleChildScrollView(
            controller: scrollController,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  // Barre de glissement
                  Container(
                    width: 40,
                    height: 4,
                    margin: const EdgeInsets.only(bottom: 20),
                    decoration: BoxDecoration(
                      color: Colors.white30,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
              // Icônes de statut
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildStatusIcon(
                    Icons.arrow_upward,
                    AppColors.primaryOrange,
                  ),
                  const SizedBox(width: 16),
                  _buildStatusIcon(
                    Icons.undo,
                    Colors.blue,
                  ),
                ],
              ),
              
              const SizedBox(height: 16),
              
              // Texte du statut
              Text(
                _getStatusText(transaction.typeTransaction),
                style: AppTextStyles.header3.copyWith(
                  color: Colors.green,
                  fontSize: 18,
                ),
              ),
              
              const SizedBox(height: 30),
              
              // Carte des détails
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.cardBackground,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    _buildDetailRow(
                      'Destinataire',
                      transaction.compteDestinataire ?? 'N/A',
                    ),
                    const Divider(color: Colors.white24, height: 30),
                    _buildDetailRow(
                      'Expéditeur',
                      transaction.compteExpediteur ?? 'N/A',
                    ),
                    const Divider(color: Colors.white24, height: 30),
                    _buildDetailRow(
                      'Montant',
                      '${transaction.montant.toInt()} CFA',
                    ),
                    const Divider(color: Colors.white24, height: 30),
                    _buildDetailRow(
                      'Date',
                      _formatDate(transaction.dateCreation),
                    ),
                    const Divider(color: Colors.white24, height: 30),
                    _buildDetailRow(
                      'Référence',
                      transaction.reference,
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 20),
              
              // Texte de réception
              Text(
                'Reçu généré par l\'application OM PAY',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: Colors.white70,
                  fontStyle: FontStyle.italic,
                ),
                textAlign: TextAlign.center,
              ),
              
              const SizedBox(height: 30),
              
              // Bouton de partage
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: Colors.blue,
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  onPressed: () {
                    Get.snackbar(
                      'Partage',
                      'Fonctionnalité de partage en cours de développement',
                      snackPosition: SnackPosition.BOTTOM,
                    );
                  },
                  icon: const Icon(
                    Icons.share,
                    color: Colors.white,
                    size: 28,
                  ),
                ),
              ),
              
              const SizedBox(height: 30),
              
              // Bouton Croix pour fermer
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  onPressed: () => Get.back(),
                  icon: const Icon(Icons.close, color: Colors.white, size: 32),
                ),
              ),
              
              const SizedBox(height: 20),
            ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildStatusIcon(IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        border: Border.all(
          color: color,
          width: 3,
        ),
      ),
      child: Icon(
        icon,
        size: 40,
        color: Colors.white,
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: AppTextStyles.bodyLarge.copyWith(
            color: Colors.white70,
          ),
        ),
        Flexible(
          child: Text(
            value,
            style: AppTextStyles.bodyLarge.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.right,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  String _getStatusText(String type) {
    switch (type.toUpperCase()) {
      case 'TRANSFERT':
        return 'achat_pass_data';
      case 'PAIEMENT':
        return 'paiement_effectué';
      case 'DEPOT':
        return 'dépôt_effectué';
      case 'RETRAIT':
        return 'retrait_effectué';
      default:
        return 'transaction_effectuée';
    }
  }

  String _formatDate(String? dateStr) {
    if (dateStr == null) return 'N/A';
    
    try {
      final date = DateTime.parse(dateStr);
      return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
    } catch (e) {
      return dateStr;
    }
  }
}
