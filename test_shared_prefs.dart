import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  print('🧪 Test SharedPreferences sur Web');
  
  final prefs = await SharedPreferences.getInstance();
  
  // Test d'écriture
  await prefs.setString('test_key', 'test_value');
  print('✅ Écriture: test_key = test_value');
  
  // Test de lecture immédiate
  final value = prefs.getString('test_key');
  print('📖 Lecture: test_key = $value');
  
  // Afficher toutes les clés
  print('📦 Toutes les clés: ${prefs.getKeys()}');
  
  // Simuler un reload (vérifier si les données persistent)
  final prefs2 = await SharedPreferences.getInstance();
  final value2 = prefs2.getString('test_key');
  print('🔄 Après reload: test_key = $value2');
  
  if (value2 == 'test_value') {
    print('✅ SharedPreferences fonctionne correctement !');
  } else {
    print('❌ SharedPreferences NE persiste PAS les données !');
  }
}
