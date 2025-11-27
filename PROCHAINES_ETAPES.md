# 🚀 PROCHAINES ÉTAPES - Implémentation OM Pay GetX

## 📊 ÉTAT ACTUEL DU PROJET

### ✅ Ce qui est déjà fait :
- Structure GetX créée avec get_cli
- Fichiers copiés : theme, widgets, utils, enums, images, models (dto)
- pubspec.yaml configuré avec toutes les dépendances
- Modules créés : splash, login, register, activate, home

### ❌ Ce qui reste à faire :
- Créer les services (ApiProvider, AuthService, etc.)
- Modifier main.dart pour initialiser GetX
- Corriger app_pages.dart (route initiale)
- Implémenter le code des controllers et views

---

## 📝 ÉTAPES À SUIVRE MAINTENANT

### ÉTAPE 3️⃣ : Créer les dossiers manquants

```bash
cd /home/mouhamadou-lamine/flutter/OMPay_GetX/mon_app_getx

# Créer les dossiers
mkdir -p lib/app/data/providers
mkdir -p lib/app/data/services
```

---

### ÉTAPE 4️⃣ : Créer ApiProvider

**Fichier** : `lib/app/data/providers/api_provider.dart`

**Action** : Créez ce fichier avec le contenu suivant :

```dart
import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

/// Service API avec GetX
class ApiProvider extends GetxService {
  
  static const String baseUrl = 'https://om-pay-spring-boot-1.onrender.com/api';
  
  final Rx<String?> token = Rx<String?>(null);
  static const String _tokenKey = 'auth_token';
  
  RxBool get isAuthenticated => (token.value != null).obs;
  
  @override
  void onInit() {
    super.onInit();
    print('🌐 ApiProvider initialisé');
  }
  
  Future<void> loadToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedToken = prefs.getString(_tokenKey);
      token.value = savedToken;
      
      if (savedToken != null) {
        print('✅ Token chargé depuis le stockage');
      } else {
        print('ℹ️ Aucun token sauvegardé');
      }
    } catch (e) {
      print('❌ Erreur chargement token : $e');
    }
  }
  
  Future<void> saveToken(String? newToken) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      if (newToken != null) {
        await prefs.setString(_tokenKey, newToken);
        token.value = newToken;
        print('✅ Token sauvegardé');
      } else {
        await prefs.remove(_tokenKey);
        token.value = null;
        print('🗑️ Token supprimé');
      }
    } catch (e) {
      print('❌ Erreur sauvegarde token : $e');
    }
  }
  
  Future<void> clearToken() async {
    await saveToken(null);
  }
  
  Map<String, String> _getHeaders({bool includeAuth = false}) {
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    
    if (includeAuth && token.value != null) {
      headers['Authorization'] = 'Bearer ${token.value}';
      print('🔐 Requête avec authentification');
    }
    
    return headers;
  }
  
  Future<Map<String, dynamic>> post(
    String endpoint,
    Map<String, dynamic> data, {
    bool includeAuth = false,
  }) async {
    try {
      final url = Uri.parse('$baseUrl$endpoint');
      print('📡 POST $url');
      print('📤 Données envoyées : $data');
      
      final response = await http.post(
        url,
        headers: _getHeaders(includeAuth: includeAuth),
        body: json.encode(data),
      );
      
      return _handleResponse(response);
    } catch (e) {
      print('❌ Erreur POST : $e');
      throw Exception('Erreur de connexion : $e');
    }
  }
  
  Future<dynamic> get(
    String endpoint, {
    bool includeAuth = true,
  }) async {
    try {
      final url = Uri.parse('$baseUrl$endpoint');
      print('📡 GET $url');
      
      final response = await http.get(
        url,
        headers: _getHeaders(includeAuth: includeAuth),
      );
      
      return _handleResponse(response);
    } catch (e) {
      print('❌ Erreur GET : $e');
      throw Exception('Erreur de connexion : $e');
    }
  }
  
  Future<Map<String, dynamic>> put(
    String endpoint,
    Map<String, dynamic> data,
  ) async {
    try {
      final url = Uri.parse('$baseUrl$endpoint');
      print('📡 PUT $url');
      
      final response = await http.put(
        url,
        headers: _getHeaders(includeAuth: true),
        body: json.encode(data),
      );
      
      return _handleResponse(response);
    } catch (e) {
      print('❌ Erreur PUT : $e');
      throw Exception('Erreur de connexion : $e');
    }
  }
  
  Future<void> delete(String endpoint) async {
    try {
      final url = Uri.parse('$baseUrl$endpoint');
      print('📡 DELETE $url');
      
      final response = await http.delete(
        url,
        headers: _getHeaders(includeAuth: true),
      );
      
      if (response.statusCode != 200 && response.statusCode != 204) {
        throw Exception(_parseError(response));
      }
      
      print('✅ DELETE réussi');
    } catch (e) {
      print('❌ Erreur DELETE : $e');
      throw Exception('Erreur de connexion : $e');
    }
  }
  
  dynamic _handleResponse(http.Response response) {
    print('📥 Status code : ${response.statusCode}');
    
    if (response.statusCode >= 200 && response.statusCode < 300) {
      final decoded = json.decode(response.body);
      print('✅ Réponse reçue avec succès');
      return decoded;
    } else {
      final errorMessage = _parseError(response);
      print('❌ Erreur serveur : $errorMessage');
      throw Exception(errorMessage);
    }
  }
  
  String _parseError(http.Response response) {
    try {
      final errorBody = json.decode(response.body);
      return errorBody['message'] ?? 
             errorBody['error'] ?? 
             _getDefaultError(response.statusCode);
    } catch (e) {
      return _getDefaultError(response.statusCode);
    }
  }
  
  String _getDefaultError(int statusCode) {
    switch (statusCode) {
      case 400:
        return 'Requête invalide. Vérifiez vos données.';
      case 401:
        return 'Session expirée. Veuillez vous reconnecter.';
      case 403:
        return 'Accès refusé.';
      case 404:
        return 'Ressource non trouvée.';
      case 500:
        return 'Erreur serveur. Réessayez plus tard.';
      default:
        return 'Une erreur est survenue (Code: $statusCode)';
    }
  }
}
```

---

### ÉTAPE 5️⃣ : Créer AuthService

**Fichier** : `lib/app/data/services/auth_service.dart`

```dart
import 'package:get/get.dart';
import '../providers/api_provider.dart';

class PremiereConnexionException implements Exception {
  final String message;
  PremiereConnexionException(this.message);
  
  @override
  String toString() => message;
}

class AuthService extends GetxService {
  
  final ApiProvider _api = Get.find<ApiProvider>();
  
  final Rx<Map<String, dynamic>?> currentUser = Rx<Map<String, dynamic>?>(null);
  
  RxBool get isLoggedIn => (currentUser.value != null).obs;
  
  static const String loginEndpoint = '/auth/login';
  static const String registerEndpoint = '/auth/register';
  static const String verifyCodeEndpoint = '/auth/verify-code-secret';
  static const String profileEndpoint = '/auth/me';
  
  Future<Map<String, dynamic>> register({
    required String nom,
    required String prenom,
    required String telephone,
    required String email,
    required String motDePasse,
  }) async {
    try {
      print('📝 Inscription de : $telephone');
      
      final response = await _api.post(
        registerEndpoint,
        {
          'nom': nom,
          'prenom': prenom,
          'telephone': telephone,
          'email': email,
          'motDePasse': motDePasse,
        },
      );
      
      print('✅ Inscription réussie');
      return response;
      
    } catch (e) {
      print('❌ Erreur inscription : $e');
      rethrow;
    }
  }
  
  Future<Map<String, dynamic>> login({
    required String telephone,
    required String motDePasse,
  }) async {
    try {
      print('🔐 Tentative de connexion : $telephone');
      
      final response = await _api.post(
        loginEndpoint,
        {
          'telephone': telephone,
          'motDePasse': motDePasse,
        },
      );
      
      if (response['token'] != null) {
        await _api.saveToken(response['token']);
        currentUser.value = response;
        print('✅ Connexion réussie !');
      }
      
      return response;
      
    } on Exception catch (e) {
      print('❌ Erreur connexion : $e');
      
      final errorMessage = e.toString().toLowerCase();
      if (errorMessage.contains('première connexion') ||
          errorMessage.contains('premiere connexion') ||
          errorMessage.contains('activer')) {
        throw PremiereConnexionException(
          'Première connexion détectée. Veuillez activer votre compte.'
        );
      }
      
      rethrow;
    }
  }
  
  Future<Map<String, dynamic>> verifyCode({
    required String telephone,
    required String codeSecret,
  }) async {
    try {
      print('🔑 Activation du compte : $telephone');
      
      final response = await _api.post(
        verifyCodeEndpoint,
        {
          'telephone': telephone,
          'codeSecret': codeSecret,
        },
      );
      
      if (response['token'] != null) {
        await _api.saveToken(response['token']);
        currentUser.value = response;
        print('✅ Compte activé avec succès');
      }
      
      return response;
      
    } catch (e) {
      print('❌ Erreur activation : $e');
      rethrow;
    }
  }
  
  Future<Map<String, dynamic>> getProfile() async {
    try {
      print('👤 Récupération du profil...');
      
      final response = await _api.get(profileEndpoint, includeAuth: true);
      
      currentUser.value = response;
      print('✅ Profil récupéré');
      
      return response;
      
    } catch (e) {
      print('❌ Erreur profil : $e');
      rethrow;
    }
  }
  
  Future<void> logout() async {
    try {
      print('🚪 Déconnexion en cours...');
      
      await _api.clearToken();
      currentUser.value = null;
      
      print('✅ Déconnexion réussie');
      
    } catch (e) {
      print('❌ Erreur déconnexion : $e');
      rethrow;
    }
  }
  
  bool checkIsLoggedIn() {
    final hasToken = _api.token.value != null;
    print('🔍 Vérification connexion : Token présent = $hasToken');
    return hasToken;
  }
}
```

---

### ÉTAPE 6️⃣ : Créer CompteService et TransactionService

**Fichier 1** : `lib/app/data/services/compte_service.dart`

```dart
import 'package:get/get.dart';
import '../providers/api_provider.dart';

class CompteService extends GetxService {
  
  final ApiProvider _api = Get.find<ApiProvider>();
  
  static const String soldeEndpoint = '/comptes/solde';
  
  Future<double> consulterMonSolde() async {
    try {
      print('💰 Consultation du solde...');
      
      final response = await _api.get(soldeEndpoint, includeAuth: true);
      
      final solde = (response is Map ? (response['solde'] ?? 0) : 0).toDouble();
      
      print('✅ Solde récupéré : $solde FCFA');
      return solde;
      
    } catch (e) {
      print('❌ Erreur récupération solde : $e');
      rethrow;
    }
  }
}
```

**Fichier 2** : `lib/app/data/services/transaction_service.dart`

```dart
import 'package:get/get.dart';
import '../providers/api_provider.dart';

class TransactionService extends GetxService {
  
  final ApiProvider _api = Get.find<ApiProvider>();
  
  static const String historiqueEndpoint = '/transactions/historique';
  static const String transfertEndpoint = '/transactions/transfert';
  static const String paiementEndpoint = '/transactions/paiement';
  
  Future<List<dynamic>> getHistorique() async {
    try {
      print('📜 Récupération de l\'historique...');
      
      final response = await _api.get(historiqueEndpoint, includeAuth: true);
      
      if (response is List) {
        print('✅ ${response.length} transactions récupérées');
        return response;
      } else if (response is Map && response['transactions'] != null) {
        final transactions = response['transactions'] as List;
        print('✅ ${transactions.length} transactions récupérées');
        return transactions;
      }
      
      return [];
      
    } catch (e) {
      print('❌ Erreur historique : $e');
      return [];
    }
  }
  
  Future<Map<String, dynamic>> transferer({
    required String destinataire,
    required double montant,
  }) async {
    try {
      print('💸 Transfert : $montant FCFA → $destinataire');
      
      final response = await _api.post(
        transfertEndpoint,
        {
          'destinataire': destinataire,
          'montant': montant,
        },
        includeAuth: true,
      );
      
      print('✅ Transfert effectué avec succès');
      return response;
      
    } catch (e) {
      print('❌ Erreur transfert : $e');
      rethrow;
    }
  }
  
  Future<Map<String, dynamic>> payer({
    required String marchand,
    required double montant,
  }) async {
    try {
      print('🛒 Paiement : $montant FCFA → $marchand');
      
      final response = await _api.post(
        paiementEndpoint,
        {
          'marchand': marchand,
          'montant': montant,
        },
        includeAuth: true,
      );
      
      print('✅ Paiement effectué avec succès');
      return response;
      
    } catch (e) {
      print('❌ Erreur paiement : $e');
      rethrow;
    }
  }
}
```

---

### ÉTAPE 7️⃣ : Modifier main.dart

**Fichier** : `lib/main.dart`

**Action** : Remplacez TOUT le contenu par :

```dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'app/routes/app_pages.dart';
import 'core/theme/app_theme.dart';
import 'app/data/providers/api_provider.dart';
import 'app/data/services/auth_service.dart';
import 'app/data/services/compte_service.dart';
import 'app/data/services/transaction_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ),
  );
  
  await initServices();
  
  runApp(const MyApp());
}

Future<void> initServices() async {
  print('🚀 Démarrage des services...');
  
  await Get.putAsync(() async {
    final api = ApiProvider();
    await api.loadToken();
    return api;
  });
  
  Get.put(AuthService());
  print('✅ AuthService initialisé');
  
  Get.put(CompteService());
  print('✅ CompteService initialisé');
  
  Get.put(TransactionService());
  print('✅ TransactionService initialisé');
  
  print('✅ Tous les services sont prêts !');
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'OM Pay',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
      defaultTransition: Transition.fade,
      transitionDuration: const Duration(milliseconds: 300),
    );
  }
}
```

---

### ÉTAPE 8️⃣ : Corriger app_pages.dart

**Fichier** : `lib/app/routes/app_pages.dart`

**Action** : Changez la ligne 18 de :
```dart
static const INITIAL = Routes.HOME;
```

à :
```dart
static const INITIAL = Routes.SPLASH;
```

---

## 🎯 APRÈS CES ÉTAPES

Une fois que vous aurez terminé les étapes 3 à 8, vous devrez :

1. **Implémenter les Controllers** (étapes 9-13 du guide GUIDE_COMPLET_GETX.md) :
   - SplashController
   - LoginController
   - RegisterController
   - ActivateController
   - HomeController

2. **Implémenter les Views** (étapes 9-13 du guide) :
   - SplashView
   - LoginView
   - RegisterView
   - ActivateView
   - HomeView

3. **Tester l'application** (étape 14)

4. **Déboguer** si nécessaire (étape 15)

---

## 📌 COMMANDES UTILES

```bash
# Installer les dépendances
flutter pub get

# Vérifier les erreurs
flutter analyze

# Lancer l'application
flutter run

# Nettoyer le cache
flutter clean
```

---

## 🆘 EN CAS DE PROBLÈME

Consultez le fichier **GUIDE_COMPLET_GETX.md** qui contient :
- Tous les codes complets
- Explications détaillées pour débutants
- Solutions aux erreurs courantes
- 15 étapes complètes avec exemples

---

**Bon courage ! 💪 Suivez ces étapes dans l'ordre et tout fonctionnera !**
