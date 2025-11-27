import 'package:http/http.dart' as http;
import 'dart:convert';

void main() async {
  // Remplace par ton vrai token après connexion
  const token = 'TON_TOKEN_ICI';
  
  print('🔍 Test de l\'API /comptes/solde');
  print('Base URL: https://om-pay-spring-boot-1.onrender.com/api');
  print('Endpoint: /comptes/solde');
  print('Token: ${token.substring(0, 20)}...\n');
  
  try {
    final response = await http.get(
      Uri.parse('https://om-pay-spring-boot-1.onrender.com/api/comptes/solde'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );
    
    print('📊 Status Code: ${response.statusCode}');
    print('📊 Response Headers: ${response.headers}');
    print('📊 Response Body: ${response.body}');
    print('📊 Body Type: ${response.body.runtimeType}');
    
    if (response.statusCode == 200) {
      print('✅ API fonctionne !');
      try {
        final data = jsonDecode(response.body);
        print('🎯 Données décodées: $data (type: ${data.runtimeType})');
      } catch (e) {
        print('⚠️ Impossible de décoder en JSON, c\'est peut-être un nombre direct');
        try {
          final number = double.parse(response.body);
          print('🎯 Nombre parsé: $number');
        } catch (e2) {
          print('❌ Impossible de parser: $e2');
        }
      }
    } else {
      print('❌ Erreur: ${response.reasonPhrase}');
    }
  } catch (e) {
    print('❌ Exception: $e');
  }
}
