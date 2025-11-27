# 🚀 GUIDE COMPLET : TRANSFORMER OM PAY EN GETX

## 📖 Pour Débutants - Étape par Étape avec TOUT le Code

---

## 🎯 OBJECTIF

Transformer votre projet **OM_Pay** (ancien avec Provider) en **GetX** (nouveau pattern moderne).

**Durée estimée** : 2-3 heures si vous suivez bien les étapes.

---

## 📋 TABLE DES MATIÈRES

### PHASE 1 : PRÉPARATION (30 min)
- [Étape 1 : Copier les fichiers de base](#etape1)
- [Étape 2 : Créer les dossiers manquants](#etape2)

### PHASE 2 : CONFIGURATION (30 min)
- [Étape 3 : Configurer pubspec.yaml](#etape3)
- [Étape 4 : Créer ApiProvider (Service HTTP)](#etape4)
- [Étape 5 : Créer AuthService](#etape5)
- [Étape 6 : Créer les autres services](#etape6)
- [Étape 7 : Modifier main.dart](#etape7)
- [Étape 8 : Corriger app_pages.dart](#etape8)

### PHASE 3 : PAGES (1h30)
- [Étape 9 : Splash Screen](#etape9)
- [Étape 10 : Login Screen](#etape10)
- [Étape 11 : Register Screen](#etape11)
- [Étape 12 : Activate Screen](#etape12)
- [Étape 13 : Home Screen](#etape13)

### PHASE 4 : FINALISATION (30 min)
- [Étape 14 : Tester l'application](#etape14)
- [Étape 15 : Corriger les erreurs](#etape15)

---

<a name="etape1"></a>
## 📁 ÉTAPE 1 : COPIER LES FICHIERS DE BASE

**⏱️ Temps** : 5 minutes

**🎯 But** : Récupérer les fichiers réutilisables de l'ancien projet (theme, widgets, utils, dto, enums).

### 1.1 Ouvrir un terminal

```bash
cd /home/mouhamadou-lamine/flutter/OMPay_GetX
```

### 1.2 Créer les dossiers de destination

```bash
# Créer les dossiers core
mkdir -p mon_app_getx/lib/core/theme
mkdir -p mon_app_getx/lib/core/widgets
mkdir -p mon_app_getx/lib/core/utils
mkdir -p mon_app_getx/lib/core/enums

# Créer les dossiers data
mkdir -p mon_app_getx/lib/app/data/models
mkdir -p mon_app_getx/lib/app/data/providers
mkdir -p mon_app_getx/lib/app/data/services
```

### 1.3 Copier les fichiers

```bash
# Theme (3 fichiers)
cp -r OM_Pay/nom_du_projet/lib/theme/* mon_app_getx/lib/core/theme/

# Widgets (9 fichiers)
cp -r OM_Pay/nom_du_projet/lib/widgets/* mon_app_getx/lib/core/widgets/

# Utils (4 fichiers)
cp -r OM_Pay/nom_du_projet/lib/utils/* mon_app_getx/lib/core/utils/

# DTOs (10 fichiers)
cp -r OM_Pay/nom_du_projet/lib/dto mon_app_getx/lib/app/data/models/

# Enums (4 fichiers)
cp -r OM_Pay/nom_du_projet/lib/enums/* mon_app_getx/lib/core/enums/

# Assets (images)
cp -r OM_Pay/nom_du_projet/assets mon_app_getx/
```

### 1.4 Vérifier que les fichiers sont copiés

```bash
ls -la mon_app_getx/lib/core/theme/
ls -la mon_app_getx/lib/core/widgets/
ls -la mon_app_getx/lib/core/utils/
```

**✅ Résultat attendu** : Vous devez voir tous les fichiers listés.

---

<a name="etape2"></a>
## 📂 ÉTAPE 2 : VÉRIFIER LA STRUCTURE

**⏱️ Temps** : 2 minutes

**🎯 But** : S'assurer que la structure est correcte.

### 2.1 Votre structure doit ressembler à ça :

```
mon_app_getx/lib/
├── app/
│   ├── data/
│   │   ├── models/
│   │   │   └── dto/           ✅ COPIÉ
│   │   ├── providers/         📝 À REMPLIR
│   │   └── services/          📝 À REMPLIR
│   ├── modules/               ✅ CRÉÉ PAR GET_CLI
│   │   ├── splash/
│   │   ├── login/
│   │   ├── register/
│   │   ├── activate/
│   │   └── home/
│   └── routes/                ✅ CRÉÉ PAR GET_CLI
│       ├── app_routes.dart
│       └── app_pages.dart
├── core/
│   ├── theme/                 ✅ COPIÉ
│   ├── widgets/               ✅ COPIÉ
│   ├── utils/                 ✅ COPIÉ
│   └── enums/                 ✅ COPIÉ
└── main.dart                  📝 À MODIFIER
```

---

<a name="etape3"></a>
## 📦 ÉTAPE 3 : CONFIGURER PUBSPEC.YAML

**⏱️ Temps** : 3 minutes

**🎯 But** : Ajouter toutes les dépendances nécessaires.

### 3.1 Ouvrir le fichier

Fichier : `mon_app_getx/pubspec.yaml`

### 3.2 Remplacer la section dependencies

**CHERCHER cette section** :
```yaml
dependencies:
  flutter:
    sdk: flutter
  cupertino_icons: ^1.0.8
```

**REMPLACER PAR** :
```yaml
dependencies:
  flutter:
    sdk: flutter
  
  # GetX - Gestion d'état et navigation
  get: ^4.7.2
  
  # UI
  cupertino_icons: ^1.0.8
  
  # Réseau et API
  http: ^1.1.0
  
  # Stockage local
  shared_preferences: ^2.2.2
  
  # QR Code
  qr_flutter: ^4.1.0
  mobile_scanner: ^3.5.5
  
  # Emails
  mailer: ^6.0.1
```

### 3.3 Ajouter la section assets

**CHERCHER** :
```yaml
flutter:
  uses-material-design: true
```

**REMPLACER PAR** :
```yaml
flutter:
  uses-material-design: true
  
  # Images et assets
  assets:
    - assets/images/
```

### 3.4 Installer les dépendances

```bash
cd mon_app_getx
flutter pub get
```

**✅ Résultat attendu** : Toutes les dépendances s'installent sans erreur.

---

<a name="etape4"></a>
## 🌐 ÉTAPE 4 : CRÉER APIPROVIDER (SERVICE HTTP)

**⏱️ Temps** : 10 minutes

**🎯 But** : Créer le service qui gère toutes les requêtes HTTP vers votre backend.

### 4.1 Créer le fichier

**Fichier** : `lib/app/data/providers/api_provider.dart`

### 4.2 Copier ce code COMPLET

```dart
import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

/// Service API avec GetX
/// Gère toutes les requêtes HTTP et l'authentification
class ApiProvider extends GetxService {
  
  // ========== URL DE VOTRE API ==========
  // ⚠️ IMPORTANT : Remplacez par votre vraie URL !
  static const String baseUrl = 'https://om-pay-spring-boot-1.onrender.com/api';
  
  // ========== GESTION DU TOKEN JWT ==========
  
  /// Token JWT stocké en mémoire
  final Rx<String?> token = Rx<String?>(null);
  
  /// Clé pour sauvegarder le token
  static const String _tokenKey = 'auth_token';
  
  /// Vérifie si l'utilisateur est authentifié
  RxBool get isAuthenticated => (token.value != null).obs;
  
  // ========== INITIALISATION ==========
  
  /// Appelé automatiquement au démarrage de l'app
  @override
  void onInit() {
    super.onInit();
    print('🌐 ApiProvider initialisé');
  }
  
  // ========== MÉTHODES POUR LE TOKEN ==========
  
  /// Charger le token depuis le stockage local
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
  
  /// Sauvegarder le token dans le stockage local
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
  
  /// Supprimer le token (déconnexion)
  Future<void> clearToken() async {
    await saveToken(null);
  }
  
  // ========== GÉNÉRATION DES HEADERS HTTP ==========
  
  /// Créer les headers pour les requêtes HTTP
  Map<String, String> _getHeaders({bool includeAuth = false}) {
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    
    // Ajouter le token si nécessaire
    if (includeAuth && token.value != null) {
      headers['Authorization'] = 'Bearer ${token.value}';
      print('🔐 Requête avec authentification');
    }
    
    return headers;
  }
  
  // ========== REQUÊTES HTTP ==========
  
  /// POST - Envoyer des données au serveur
  /// Exemple : post('/auth/login', {'telephone': '771234567', 'password': '123456'})
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
  
  /// GET - Récupérer des données du serveur
  /// Exemple : get('/transactions')
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
  
  /// PUT - Mettre à jour des données
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
  
  /// DELETE - Supprimer des données
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
  
  // ========== TRAITEMENT DES RÉPONSES ==========
  
  /// Traiter la réponse HTTP
  dynamic _handleResponse(http.Response response) {
    print('📥 Status code : ${response.statusCode}');
    
    // Succès (200-299)
    if (response.statusCode >= 200 && response.statusCode < 300) {
      final decoded = json.decode(response.body);
      print('✅ Réponse reçue avec succès');
      return decoded;
    } 
    // Erreur
    else {
      final errorMessage = _parseError(response);
      print('❌ Erreur serveur : $errorMessage');
      throw Exception(errorMessage);
    }
  }
  
  /// Parser les messages d'erreur du serveur
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
  
  /// Messages d'erreur par défaut selon le code HTTP
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

### 4.3 Explication pour débutants

**Qu'est-ce que fait ce fichier ?**

1. **ApiProvider** = Le "facteur" qui envoie et reçoit des messages vers votre serveur
2. **token** = C'est comme votre "badge" pour prouver que vous êtes connecté
3. **post()** = Envoyer des données (ex: se connecter avec téléphone + mot de passe)
4. **get()** = Récupérer des données (ex: lire l'historique des transactions)
5. **saveToken()** = Sauvegarder votre "badge" pour rester connecté même après avoir fermé l'app

**Pourquoi GetxService ?**
- C'est un service qui reste en mémoire toute la vie de l'app
- On le crée une seule fois au démarrage
- Partout dans l'app, on peut l'utiliser avec `Get.find<ApiProvider>()`

---

<a name="etape5"></a>
## 🔐 ÉTAPE 5 : CRÉER AUTHSERVICE

**⏱️ Temps** : 10 minutes

**🎯 But** : Gérer l'authentification (login, register, logout).

### 5.1 Créer le fichier

**Fichier** : `lib/app/data/services/auth_service.dart`

### 5.2 Copier ce code COMPLET

```dart
import 'package:get/get.dart';
import '../providers/api_provider.dart';

/// Exception pour gérer la première connexion
class PremiereConnexionException implements Exception {
  final String message;
  PremiereConnexionException(this.message);
  
  @override
  String toString() => message;
}

/// Service d'authentification
/// Gère : Login, Register, Logout, Activation
class AuthService extends GetxService {
  
  // ========== DÉPENDANCES ==========
  
  /// Récupère automatiquement ApiProvider
  final ApiProvider _api = Get.find<ApiProvider>();
  
  // ========== DONNÉES UTILISATEUR ==========
  
  /// Informations de l'utilisateur connecté
  final Rx<Map<String, dynamic>?> currentUser = Rx<Map<String, dynamic>?>(null);
  
  /// Vérifie si l'utilisateur est connecté
  RxBool get isLoggedIn => (currentUser.value != null).obs;
  
  // ========== ENDPOINTS API ==========
  
  static const String loginEndpoint = '/auth/login';
  static const String registerEndpoint = '/auth/register';
  static const String verifyCodeEndpoint = '/auth/verify-code-secret';
  static const String profileEndpoint = '/auth/me';
  
  // ========== INSCRIPTION ==========
  
  /// Inscrire un nouvel utilisateur
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
      rethrow; // Relancer l'erreur pour la gérer dans le controller
    }
  }
  
  // ========== CONNEXION ==========
  
  /// Connecter un utilisateur
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
      
      // Sauvegarder le token
      if (response['token'] != null) {
        await _api.saveToken(response['token']);
        currentUser.value = response;
        print('✅ Connexion réussie !');
      }
      
      return response;
      
    } on Exception catch (e) {
      print('❌ Erreur connexion : $e');
      
      // Vérifier si c'est une première connexion
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
  
  // ========== ACTIVATION COMPTE ==========
  
  /// Activer un compte avec le code secret
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
      
      // Sauvegarder le token
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
  
  // ========== PROFIL ==========
  
  /// Récupérer le profil de l'utilisateur connecté
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
  
  // ========== DÉCONNEXION ==========
  
  /// Déconnecter l'utilisateur
  Future<void> logout() async {
    try {
      print('🚪 Déconnexion en cours...');
      
      // Supprimer le token
      await _api.clearToken();
      
      // Effacer les données utilisateur
      currentUser.value = null;
      
      print('✅ Déconnexion réussie');
      
    } catch (e) {
      print('❌ Erreur déconnexion : $e');
      rethrow;
    }
  }
  
  // ========== VÉRIFICATIONS ==========
  
  /// Vérifier si l'utilisateur est connecté
  bool checkIsLoggedIn() {
    final hasToken = _api.token.value != null;
    print('🔍 Vérification connexion : Token présent = $hasToken');
    return hasToken;
  }
}
```

### 5.3 Explication pour débutants

**Qu'est-ce que fait ce fichier ?**

1. **register()** = Créer un nouveau compte utilisateur
2. **login()** = Se connecter avec téléphone + mot de passe
3. **verifyCode()** = Activer le compte avec le code reçu par SMS
4. **logout()** = Se déconnecter
5. **getProfile()** = Récupérer les infos de l'utilisateur connecté

**PremiereConnexionException** = Une erreur spéciale qui se déclenche quand c'est la première fois qu'on se connecte (besoin d'activer le compte).

---

---

<a name="etape6"></a>
## 💼 ÉTAPE 6 : CRÉER LES AUTRES SERVICES

**⏱️ Temps** : 10 minutes

**🎯 But** : Créer CompteService et TransactionService.

### 6.1 Créer CompteService

**Fichier** : `lib/app/data/services/compte_service.dart`

**Code complet** :

```dart
import 'package:get/get.dart';
import '../providers/api_provider.dart';

/// Service de gestion du compte utilisateur
class CompteService extends GetxService {
  
  final ApiProvider _api = Get.find<ApiProvider>();
  
  // Endpoints
  static const String soldeEndpoint = '/comptes/solde';
  
  /// Consulter le solde du compte
  Future<double> consulterMonSolde() async {
    try {
      print('💰 Consultation du solde...');
      
      final response = await _api.get(soldeEndpoint, includeAuth: true);
      
      // Le solde peut être dans response['solde'] ou response directement
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

### 6.2 Créer TransactionService

**Fichier** : `lib/app/data/services/transaction_service.dart`

**Code complet** :

```dart
import 'package:get/get.dart';
import '../providers/api_provider.dart';

/// Service de gestion des transactions
class TransactionService extends GetxService {
  
  final ApiProvider _api = Get.find<ApiProvider>();
  
  // Endpoints
  static const String historiqueEndpoint = '/transactions/historique';
  static const String transfertEndpoint = '/transactions/transfert';
  static const String paiementEndpoint = '/transactions/paiement';
  
  /// Récupérer l'historique des transactions
  Future<List<dynamic>> getHistorique() async {
    try {
      print('📜 Récupération de l\'historique...');
      
      final response = await _api.get(historiqueEndpoint, includeAuth: true);
      
      // Vérifier si c'est une liste
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
      return []; // Retourner liste vide en cas d'erreur
    }
  }
  
  /// Faire un transfert d'argent
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
  
  /// Faire un paiement marchand
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

### 6.3 Explication

**CompteService** : Gère le compte utilisateur (solde).

**TransactionService** : Gère les transactions (historique, transfert, paiement).

Ces services seront injectés dans main.dart et utilisables partout avec `Get.find<CompteService>()`.

---

<a name="etape7"></a>
## 🎬 ÉTAPE 7 : MODIFIER MAIN.DART

**⏱️ Temps** : 5 minutes

**🎯 But** : Configurer l'application avec GetX et injecter tous les services.

### 7.1 Ouvrir le fichier

**Fichier** : `lib/main.dart`

### 7.2 Remplacer TOUT le contenu par :

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

/// Point d'entrée de l'application
void main() async {
  // Initialiser Flutter
  WidgetsFlutterBinding.ensureInitialized();
  
  // Forcer le mode portrait
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  
  // Configurer la barre de statut
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ),
  );
  
  // Initialiser les services GetX
  await initServices();
  
  // Lancer l'application
  runApp(const MyApp());
}

/// Initialiser tous les services globaux
Future<void> initServices() async {
  print('🚀 Démarrage des services...');
  
  // ApiProvider : gère les requêtes HTTP
  await Get.putAsync(() async {
    final api = ApiProvider();
    await api.loadToken(); // Charger le token sauvegardé
    return api;
  });
  
  // AuthService : gère l'authentification
  Get.put(AuthService());
  print('✅ AuthService initialisé');
  
  // CompteService : gère le compte
  Get.put(CompteService());
  print('✅ CompteService initialisé');
  
  // TransactionService : gère les transactions
  Get.put(TransactionService());
  print('✅ TransactionService initialisé');
  
  print('✅ Tous les services sont prêts !');
}

/// Widget racine de l'application
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      // Configuration de base
      title: 'OM Pay',
      debugShowCheckedModeBanner: false,
      
      // Thème
      theme: AppTheme.darkTheme,
      
      // Routes GetX
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
      
      // Configuration GetX
      defaultTransition: Transition.fade,
      transitionDuration: const Duration(milliseconds: 300),
    );
  }
}
```

### 7.3 Explication

**Qu'est-ce qui a changé ?**

1. **WidgetsFlutterBinding.ensureInitialized()** : Initialise Flutter avant tout
2. **SystemChrome** : Configure l'orientation (portrait) et la barre de statut
3. **initServices()** : Crée tous les services au démarrage
4. **Get.putAsync()** : Pour ApiProvider car il doit charger le token (async)
5. **Get.put()** : Pour les autres services (synchrone)
6. **GetMaterialApp** : Remplace MaterialApp pour activer GetX
7. **AppTheme.darkTheme** : Utilise le thème de votre ancien projet

---

<a name="etape8"></a>
## 🛣️ ÉTAPE 8 : CORRIGER APP_PAGES.DART

**⏱️ Temps** : 3 minutes

**🎯 But** : Changer la route initiale de HOME vers SPLASH.

### 8.1 Ouvrir le fichier

**Fichier** : `lib/app/routes/app_pages.dart`

### 8.2 Trouver cette ligne :

```dart
static const INITIAL = Routes.HOME;
```

### 8.3 Remplacer par :

```dart
static const INITIAL = Routes.SPLASH;
```

**Pourquoi ?**
- L'app doit démarrer sur le **Splash Screen**
- Le splash vérifie si l'utilisateur est connecté
- Puis navigue vers LOGIN ou HOME

---

<a name="etape9"></a>
## 🌅 ÉTAPE 9 : SPLASH SCREEN

**⏱️ Temps** : 15 minutes

**🎯 But** : Créer l'écran de démarrage qui vérifie l'authentification.

### 9.1 Modifier SplashController

**Fichier** : `lib/app/modules/splash/controllers/splash_controller.dart`

**SUPPRIMER tout le contenu et REMPLACER par** :

```dart
import 'package:get/get.dart';
import '../../../data/services/auth_service.dart';
import '../../../routes/app_routes.dart';

/// Controller pour l'écran Splash
class SplashController extends GetxController {
  
  final AuthService _authService = Get.find<AuthService>();
  
  /// Appelé quand la vue est prête
  @override
  void onReady() {
    super.onReady();
    _checkAuthAndNavigate();
  }
  
  /// Vérifier l'authentification et naviguer
  Future<void> _checkAuthAndNavigate() async {
    try {
      print('🔍 Vérification de l\'authentification...');
      
      // Attendre 2 secondes (effet splash)
      await Future.delayed(const Duration(seconds: 2));
      
      // Vérifier si l'utilisateur est connecté
      final isLoggedIn = _authService.checkIsLoggedIn();
      
      if (isLoggedIn) {
        print('✅ Utilisateur connecté → Redirection vers Home');
        Get.offAllNamed(Routes.HOME);
      } else {
        print('❌ Non connecté → Redirection vers Login');
        Get.offAllNamed(Routes.LOGIN);
      }
      
    } catch (e) {
      print('❌ Erreur splash : $e');
      // En cas d'erreur, aller au login
      Get.offAllNamed(Routes.LOGIN);
    }
  }
}
```

### 9.2 Modifier SplashView

**Fichier** : `lib/app/modules/splash/views/splash_view.dart`

**SUPPRIMER tout le contenu et REMPLACER par** :

```dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/splash_controller.dart';
import '../../../../core/theme/app_colors.dart';

/// Vue pour l'écran Splash
class SplashView extends GetView<SplashController> {
  const SplashView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: AppColors.primaryOrange,
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primaryOrange.withOpacity(0.3),
                    blurRadius: 20,
                    spreadRadius: 5,
                  ),
                ],
              ),
              child: const Icon(
                Icons.account_balance_wallet,
                size: 70,
                color: Colors.white,
              ),
            ),
            
            const SizedBox(height: 30),
            
            // Nom de l'app
            const Text(
              'OM Pay',
              style: TextStyle(
                color: Colors.white,
                fontSize: 36,
                fontWeight: FontWeight.bold,
                letterSpacing: 2,
              ),
            ),
            
            const SizedBox(height: 10),
            
            // Slogan
            Text(
              'Votre argent en toute sécurité',
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 14,
              ),
            ),
            
            const SizedBox(height: 40),
            
            // Indicateur de chargement
            const CircularProgressIndicator(
              color: AppColors.primaryOrange,
              strokeWidth: 3,
            ),
          ],
        ),
      ),
    );
  }
}
```

### 9.3 Explication

**SplashController** :
- `onReady()` : Appelé quand la vue est affichée
- Attend 2 secondes
- Vérifie si l'utilisateur a un token (= connecté)
- Redirige vers HOME ou LOGIN

**SplashView** :
- Affiche le logo OM Pay
- Loading indicator
- Pas d'interaction utilisateur

---

<a name="etape10"></a>
## 🔐 ÉTAPE 10 : LOGIN SCREEN

**⏱️ Temps** : 20 minutes

**🎯 But** : Créer l'écran de connexion avec gestion d'erreurs.

### 10.1 Modifier LoginController

**Fichier** : `lib/app/modules/login/controllers/login_controller.dart`

**SUPPRIMER tout et REMPLACER par** :

```dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/services/auth_service.dart';
import '../../../routes/app_routes.dart';
import '../../../../core/utils/error_messages.dart';

/// Controller pour l'écran de connexion
class LoginController extends GetxController {
  
  // Controllers de formulaire
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();
  
  // Variables réactives
  final isLoading = false.obs;
  final phoneError = Rx<String?>(null);
  final passwordError = Rx<String?>(null);
  
  // Services
  final AuthService _authService = Get.find<AuthService>();
  
  /// Nettoyage
  @override
  void onClose() {
    phoneController.dispose();
    passwordController.dispose();
    super.onClose();
  }
  
  /// Effacer les erreurs
  void clearErrors() {
    phoneError.value = null;
    passwordError.value = null;
  }
  
  /// Valider le formulaire
  bool _validateForm() {
    clearErrors();
    bool isValid = true;
    
    // Valider téléphone
    final phone = phoneController.text.trim();
    if (phone.isEmpty) {
      phoneError.value = ErrorMessages.telephoneRequis;
      isValid = false;
    } else if (phone.length < 9) {
      phoneError.value = ErrorMessages.telephoneInvalide;
      isValid = false;
    }
    
    // Valider mot de passe
    final password = passwordController.text;
    if (password.isEmpty) {
      passwordError.value = ErrorMessages.motDePasseRequis;
      isValid = false;
    } else if (password.length < 6) {
      passwordError.value = ErrorMessages.motDePasseCourt;
      isValid = false;
    }
    
    return isValid;
  }
  
  /// Se connecter
  Future<void> login() async {
    // Valider
    if (!_validateForm()) {
      return;
    }
    
    isLoading.value = true;
    
    try {
      print('🔐 Tentative de connexion...');
      
      await _authService.login(
        telephone: phoneController.text.trim(),
        motDePasse: passwordController.text,
      );
      
      isLoading.value = false;
      
      // Succès
      Get.snackbar(
        'Succès',
        'Bienvenue !',
        backgroundColor: Colors.green,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
      
      // Aller à Home
      Get.offAllNamed(Routes.HOME);
      
    } on PremiereConnexionException catch (e) {
      print('⚠️ Première connexion détectée');
      
      isLoading.value = false;
      phoneError.value = e.message;
      
      // Rediriger vers activation après 2 secondes
      Future.delayed(const Duration(seconds: 2), () {
        Get.toNamed(
          Routes.ACTIVATE,
          arguments: phoneController.text.trim(),
        );
      });
      
    } catch (e) {
      print('❌ Erreur connexion : $e');
      
      isLoading.value = false;
      
      final errorMessage = ErrorMessages.parseBackendError(e);
      
      // Afficher l'erreur
      if (errorMessage.contains('téléphone') ||
          errorMessage.contains('utilisateur') ||
          errorMessage.contains('introuvable')) {
        phoneError.value = errorMessage;
      } else {
        passwordError.value = errorMessage;
      }
      
      Get.snackbar(
        'Erreur',
        errorMessage,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
  
  /// Aller vers l'inscription
  void goToRegister() {
    Get.toNamed(Routes.REGISTER);
  }
  
  /// Aller vers l'activation
  void goToActivate() {
    Get.toNamed(
      Routes.ACTIVATE,
      arguments: phoneController.text.trim(),
    );
  }
}
```

### 10.2 Modifier LoginView

**Fichier** : `lib/app/modules/login/views/login_view.dart`

**SUPPRIMER tout et REMPLACER par** :

```dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/login_controller.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/carousel_image.dart';

/// Vue pour l'écran de connexion
class LoginView extends GetView<LoginController> {
  const LoginView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Carousel d'images
              const CarouselImage(),
              
              // Formulaire
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 20),
                    
                    // Titre
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
                    CustomTextField(
                      controller: controller.phoneController,
                      hintText: 'Numéro de téléphone',
                      prefixIcon: const Icon(Icons.phone, color: AppColors.primaryOrange),
                      keyboardType: TextInputType.phone,
                      onChanged: (_) => controller.clearErrors(),
                    ),
                    
                    // Erreur téléphone
                    Obx(() => controller.phoneError.value != null
                      ? Padding(
                          padding: const EdgeInsets.only(top: 8, left: 12),
                          child: Text(
                            controller.phoneError.value!,
                            style: const TextStyle(color: Colors.red, fontSize: 12),
                          ),
                        )
                      : const SizedBox.shrink(),
                    ),
                    
                    const SizedBox(height: 16),
                    
                    // Mot de passe
                    CustomTextField(
                      controller: controller.passwordController,
                      hintText: 'Mot de passe',
                      prefixIcon: const Icon(Icons.lock, color: AppColors.primaryOrange),
                      isPassword: true,
                      onChanged: (_) => controller.clearErrors(),
                    ),
                    
                    // Erreur mot de passe
                    Obx(() => controller.passwordError.value != null
                      ? Padding(
                          padding: const EdgeInsets.only(top: 8, left: 12),
                          child: Text(
                            controller.passwordError.value!,
                            style: const TextStyle(color: Colors.red, fontSize: 12),
                          ),
                        )
                      : const SizedBox.shrink(),
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // Bouton connexion
                    Obx(() => controller.isLoading.value
                      ? const Center(
                          child: CircularProgressIndicator(
                            color: AppColors.primaryOrange,
                          ),
                        )
                      : CustomButton(
                          text: 'Se connecter',
                          onPressed: controller.login,
                        ),
                    ),
                    
                    const SizedBox(height: 16),
                    
                    // Lien inscription
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Pas encore de compte ? ',
                          style: TextStyle(color: Colors.grey),
                        ),
                        GestureDetector(
                          onTap: controller.goToRegister,
                          child: const Text(
                            'S\'inscrire',
                            style: TextStyle(
                              color: AppColors.primaryOrange,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 16),
                    
                    // Lien activation
                    Center(
                      child: GestureDetector(
                        onTap: controller.goToActivate,
                        child: Text(
                          'Activer mon compte',
                          style: TextStyle(
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
```

### 10.3 Explication

**LoginController** :
- Gère la validation du formulaire
- Appelle AuthService.login()
- Gère les erreurs (première connexion, identifiants incorrects)
- Redirige vers HOME en cas de succès

**LoginView** :
- Formulaire avec 2 champs (téléphone, mot de passe)
- Affiche les erreurs sous chaque champ avec `Obx()`
- Bouton qui devient loading avec `Obx()`
- Liens vers inscription et activation

---

---

<a name="etape11"></a>
## 📝 ÉTAPE 11 : REGISTER SCREEN

**⏱️ Temps** : 20 minutes

**🎯 But** : Créer l'écran d'inscription avec tous les champs.

### 11.1 Modifier RegisterController

**Fichier** : `lib/app/modules/register/controllers/register_controller.dart`

**SUPPRIMER tout et REMPLACER par** :

```dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/services/auth_service.dart';
import '../../../routes/app_routes.dart';
import '../../../../core/utils/error_messages.dart';

/// Controller pour l'inscription
class RegisterController extends GetxController {
  
  // Controllers
  final nomController = TextEditingController();
  final prenomController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  
  // Variables réactives
  final isLoading = false.obs;
  final nomError = Rx<String?>(null);
  final prenomError = Rx<String?>(null);
  final phoneError = Rx<String?>(null);
  final emailError = Rx<String?>(null);
  final passwordError = Rx<String?>(null);
  final confirmPasswordError = Rx<String?>(null);
  
  // Services
  final AuthService _authService = Get.find<AuthService>();
  
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
  
  /// Effacer toutes les erreurs
  void clearErrors() {
    nomError.value = null;
    prenomError.value = null;
    phoneError.value = null;
    emailError.value = null;
    passwordError.value = null;
    confirmPasswordError.value = null;
  }
  
  /// Valider le formulaire
  bool _validateForm() {
    clearErrors();
    bool isValid = true;
    
    // Nom
    if (nomController.text.trim().isEmpty) {
      nomError.value = 'Le nom est requis';
      isValid = false;
    }
    
    // Prénom
    if (prenomController.text.trim().isEmpty) {
      prenomError.value = 'Le prénom est requis';
      isValid = false;
    }
    
    // Téléphone
    final phone = phoneController.text.trim();
    if (phone.isEmpty) {
      phoneError.value = ErrorMessages.telephoneRequis;
      isValid = false;
    } else if (phone.length < 9) {
      phoneError.value = ErrorMessages.telephoneInvalide;
      isValid = false;
    }
    
    // Email
    final email = emailController.text.trim();
    if (email.isEmpty) {
      emailError.value = 'L\'email est requis';
      isValid = false;
    } else if (!GetUtils.isEmail(email)) {
      emailError.value = 'Email invalide';
      isValid = false;
    }
    
    // Mot de passe
    final password = passwordController.text;
    if (password.isEmpty) {
      passwordError.value = ErrorMessages.motDePasseRequis;
      isValid = false;
    } else if (password.length < 6) {
      passwordError.value = ErrorMessages.motDePasseCourt;
      isValid = false;
    }
    
    // Confirmation mot de passe
    final confirmPassword = confirmPasswordController.text;
    if (confirmPassword.isEmpty) {
      confirmPasswordError.value = 'Confirmez votre mot de passe';
      isValid = false;
    } else if (password != confirmPassword) {
      confirmPasswordError.value = 'Les mots de passe ne correspondent pas';
      isValid = false;
    }
    
    return isValid;
  }
  
  /// S'inscrire
  Future<void> register() async {
    if (!_validateForm()) {
      return;
    }
    
    isLoading.value = true;
    
    try {
      print('📝 Inscription en cours...');
      
      final result = await _authService.register(
        nom: nomController.text.trim(),
        prenom: prenomController.text.trim(),
        telephone: phoneController.text.trim(),
        email: emailController.text.trim(),
        motDePasse: passwordController.text,
      );
      
      isLoading.value = false;
      
      // Succès
      Get.snackbar(
        'Succès',
        'Inscription réussie ! Activez votre compte.',
        backgroundColor: Colors.green,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 3),
      );
      
      // Attendre 2 secondes puis aller à l'activation
      await Future.delayed(const Duration(seconds: 2));
      
      Get.offNamed(
        Routes.ACTIVATE,
        arguments: phoneController.text.trim(),
      );
      
    } catch (e) {
      print('❌ Erreur inscription : $e');
      
      isLoading.value = false;
      
      final errorMessage = ErrorMessages.parseBackendError(e);
      
      // Afficher l'erreur
      if (errorMessage.contains('téléphone') || errorMessage.contains('existe')) {
        phoneError.value = errorMessage;
      } else if (errorMessage.contains('email')) {
        emailError.value = errorMessage;
      }
      
      Get.snackbar(
        'Erreur',
        errorMessage,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
  
  /// Retour au login
  void goToLogin() {
    Get.back();
  }
}
```

### 11.2 Modifier RegisterView

**Fichier** : `lib/app/modules/register/views/register_view.dart`

**SUPPRIMER tout et REMPLACER par** :

```dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/register_controller.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../../../../core/widgets/custom_button.dart';

/// Vue pour l'inscription
class RegisterView extends GetView<RegisterController> {
  const RegisterView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: controller.goToLogin,
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Logo
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: AppColors.primaryOrange,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Icon(
                  Icons.person_add,
                  size: 40,
                  color: Colors.white,
                ),
              ),
              
              const SizedBox(height: 24),
              
              // Titre
              Text(
                'Créer un compte',
                style: AppTextStyles.header2,
              ),
              
              const SizedBox(height: 8),
              
              Text(
                'Remplissez les informations ci-dessous',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              
              const SizedBox(height: 32),
              
              // Nom
              CustomTextField(
                controller: controller.nomController,
                hintText: 'Nom',
                prefixIcon: const Icon(Icons.person, color: AppColors.primaryOrange),
                onChanged: (_) => controller.clearErrors(),
              ),
              Obx(() => _buildError(controller.nomError.value)),
              
              const SizedBox(height: 16),
              
              // Prénom
              CustomTextField(
                controller: controller.prenomController,
                hintText: 'Prénom',
                prefixIcon: const Icon(Icons.person_outline, color: AppColors.primaryOrange),
                onChanged: (_) => controller.clearErrors(),
              ),
              Obx(() => _buildError(controller.prenomError.value)),
              
              const SizedBox(height: 16),
              
              // Téléphone
              CustomTextField(
                controller: controller.phoneController,
                hintText: 'Numéro de téléphone',
                prefixIcon: const Icon(Icons.phone, color: AppColors.primaryOrange),
                keyboardType: TextInputType.phone,
                onChanged: (_) => controller.clearErrors(),
              ),
              Obx(() => _buildError(controller.phoneError.value)),
              
              const SizedBox(height: 16),
              
              // Email
              CustomTextField(
                controller: controller.emailController,
                hintText: 'Email',
                prefixIcon: const Icon(Icons.email, color: AppColors.primaryOrange),
                keyboardType: TextInputType.emailAddress,
                onChanged: (_) => controller.clearErrors(),
              ),
              Obx(() => _buildError(controller.emailError.value)),
              
              const SizedBox(height: 16),
              
              // Mot de passe
              CustomTextField(
                controller: controller.passwordController,
                hintText: 'Mot de passe',
                prefixIcon: const Icon(Icons.lock, color: AppColors.primaryOrange),
                isPassword: true,
                onChanged: (_) => controller.clearErrors(),
              ),
              Obx(() => _buildError(controller.passwordError.value)),
              
              const SizedBox(height: 16),
              
              // Confirmation mot de passe
              CustomTextField(
                controller: controller.confirmPasswordController,
                hintText: 'Confirmer le mot de passe',
                prefixIcon: const Icon(Icons.lock_outline, color: AppColors.primaryOrange),
                isPassword: true,
                onChanged: (_) => controller.clearErrors(),
              ),
              Obx(() => _buildError(controller.confirmPasswordError.value)),
              
              const SizedBox(height: 32),
              
              // Bouton inscription
              Obx(() => controller.isLoading.value
                ? const Center(
                    child: CircularProgressIndicator(
                      color: AppColors.primaryOrange,
                    ),
                  )
                : CustomButton(
                    text: 'S\'inscrire',
                    onPressed: controller.register,
                  ),
              ),
              
              const SizedBox(height: 16),
              
              // Lien connexion
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Déjà un compte ? ',
                    style: TextStyle(color: Colors.grey),
                  ),
                  GestureDetector(
                    onTap: controller.goToLogin,
                    child: const Text(
                      'Se connecter',
                      style: TextStyle(
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
  
  /// Widget pour afficher les erreurs
  Widget _buildError(String? error) {
    if (error == null) return const SizedBox.shrink();
    
    return Padding(
      padding: const EdgeInsets.only(top: 8, left: 12),
      child: Text(
        error,
        style: const TextStyle(color: Colors.red, fontSize: 12),
      ),
    );
  }
}
```

---

<a name="etape12"></a>
## ✅ ÉTAPE 12 : ACTIVATE SCREEN

**⏱️ Temps** : 15 minutes

**🎯 But** : Créer l'écran d'activation du compte avec code secret.

### 12.1 Modifier ActivateController

**Fichier** : `lib/app/modules/activate/controllers/activate_controller.dart`

**SUPPRIMER tout et REMPLACER par** :

```dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/services/auth_service.dart';
import '../../../routes/app_routes.dart';
import '../../../../core/utils/error_messages.dart';

/// Controller pour l'activation du compte
class ActivateController extends GetxController {
  
  // Controllers
  final phoneController = TextEditingController();
  final codeController = TextEditingController();
  
  // Variables réactives
  final isLoading = false.obs;
  final phoneError = Rx<String?>(null);
  final codeError = Rx<String?>(null);
  
  // Services
  final AuthService _authService = Get.find<AuthService>();
  
  @override
  void onInit() {
    super.onInit();
    
    // Récupérer le téléphone depuis les arguments
    final phone = Get.arguments;
    if (phone != null && phone is String) {
      phoneController.text = phone;
      print('📱 Téléphone pré-rempli : $phone');
    }
  }
  
  @override
  void onClose() {
    phoneController.dispose();
    codeController.dispose();
    super.onClose();
  }
  
  /// Effacer les erreurs
  void clearErrors() {
    phoneError.value = null;
    codeError.value = null;
  }
  
  /// Valider le formulaire
  bool _validateForm() {
    clearErrors();
    bool isValid = true;
    
    // Téléphone
    final phone = phoneController.text.trim();
    if (phone.isEmpty) {
      phoneError.value = ErrorMessages.telephoneRequis;
      isValid = false;
    } else if (phone.length < 9) {
      phoneError.value = ErrorMessages.telephoneInvalide;
      isValid = false;
    }
    
    // Code secret
    final code = codeController.text.trim();
    if (code.isEmpty) {
      codeError.value = 'Le code secret est requis';
      isValid = false;
    } else if (code.length < 4) {
      codeError.value = 'Code secret trop court';
      isValid = false;
    }
    
    return isValid;
  }
  
  /// Activer le compte
  Future<void> activate() async {
    if (!_validateForm()) {
      return;
    }
    
    isLoading.value = true;
    
    try {
      print('🔑 Activation du compte...');
      
      await _authService.verifyCode(
        telephone: phoneController.text.trim(),
        codeSecret: codeController.text.trim(),
      );
      
      isLoading.value = false;
      
      // Succès
      Get.snackbar(
        'Succès',
        'Compte activé avec succès !',
        backgroundColor: Colors.green,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
      
      // Aller à Home
      Get.offAllNamed(Routes.HOME);
      
    } catch (e) {
      print('❌ Erreur activation : $e');
      
      isLoading.value = false;
      
      final errorMessage = ErrorMessages.parseBackendError(e);
      
      // Afficher l'erreur
      if (errorMessage.contains('code') || errorMessage.contains('secret')) {
        codeError.value = errorMessage;
      } else {
        phoneError.value = errorMessage;
      }
      
      Get.snackbar(
        'Erreur',
        errorMessage,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
  
  /// Retour au login
  void goToLogin() {
    Get.offAllNamed(Routes.LOGIN);
  }
}
```

### 12.2 Modifier ActivateView

**Fichier** : `lib/app/modules/activate/views/activate_view.dart`

**SUPPRIMER tout et REMPLACER par** :

```dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/activate_controller.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../../../../core/widgets/custom_button.dart';

/// Vue pour l'activation du compte
class ActivateView extends GetView<ActivateController> {
  const ActivateView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: controller.goToLogin,
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Icône
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: AppColors.primaryOrange.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.verified_user,
                  size: 50,
                  color: AppColors.primaryOrange,
                ),
              ),
              
              const SizedBox(height: 32),
              
              // Titre
              Text(
                'Activer votre compte',
                style: AppTextStyles.header2,
                textAlign: TextAlign.center,
              ),
              
              const SizedBox(height: 12),
              
              Text(
                'Entrez le code secret reçu par SMS pour activer votre compte OM Pay',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
              
              const SizedBox(height: 40),
              
              // Téléphone
              CustomTextField(
                controller: controller.phoneController,
                hintText: 'Numéro de téléphone',
                prefixIcon: const Icon(Icons.phone, color: AppColors.primaryOrange),
                keyboardType: TextInputType.phone,
                onChanged: (_) => controller.clearErrors(),
              ),
              Obx(() => controller.phoneError.value != null
                ? Padding(
                    padding: const EdgeInsets.only(top: 8, left: 12),
                    child: Text(
                      controller.phoneError.value!,
                      style: const TextStyle(color: Colors.red, fontSize: 12),
                    ),
                  )
                : const SizedBox.shrink(),
              ),
              
              const SizedBox(height: 20),
              
              // Code secret
              CustomTextField(
                controller: controller.codeController,
                hintText: 'Code secret',
                prefixIcon: const Icon(Icons.key, color: AppColors.primaryOrange),
                keyboardType: TextInputType.number,
                onChanged: (_) => controller.clearErrors(),
              ),
              Obx(() => controller.codeError.value != null
                ? Padding(
                    padding: const EdgeInsets.only(top: 8, left: 12),
                    child: Text(
                      controller.codeError.value!,
                      style: const TextStyle(color: Colors.red, fontSize: 12),
                    ),
                  )
                : const SizedBox.shrink(),
              ),
              
              const SizedBox(height: 32),
              
              // Bouton activation
              Obx(() => controller.isLoading.value
                ? const Center(
                    child: CircularProgressIndicator(
                      color: AppColors.primaryOrange,
                    ),
                  )
                : CustomButton(
                    text: 'Activer mon compte',
                    onPressed: controller.activate,
                  ),
              ),
              
              const SizedBox(height: 24),
              
              // Info
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.cardBackground,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppColors.primaryOrange.withOpacity(0.3),
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.info_outline,
                      color: AppColors.primaryOrange,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Le code secret vous a été envoyé par SMS lors de votre inscription',
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 13,
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
```

---

<a name="etape13"></a>
## 🏠 ÉTAPE 13 : HOME SCREEN

**⏱️ Temps** : 25 minutes

**🎯 But** : Créer l'écran d'accueil avec solde et historique.

### 13.1 Modifier HomeController

**Fichier** : `lib/app/modules/home/controllers/home_controller.dart`

**SUPPRIMER tout et REMPLACER par** :

```dart
import 'package:get/get.dart';
import '../../../data/services/auth_service.dart';
import '../../../data/services/compte_service.dart';
import '../../../data/services/transaction_service.dart';
import '../../../routes/app_routes.dart';

/// Controller pour l'écran d'accueil
class HomeController extends GetxController {
  
  // Services
  final AuthService _authService = Get.find<AuthService>();
  final CompteService _compteService = Get.find<CompteService>();
  final TransactionService _transactionService = Get.find<TransactionService>();
  
  // Variables réactives
  final solde = 0.0.obs;
  final transactions = <dynamic>[].obs;
  final isLoadingSolde = false.obs;
  final isLoadingTransactions = false.obs;
  final userName = 'Utilisateur'.obs;
  
  @override
  void onInit() {
    super.onInit();
    _loadUserData();
  }
  
  /// Charger les données utilisateur
  Future<void> _loadUserData() async {
    // Nom utilisateur
    if (_authService.currentUser.value != null) {
      final user = _authService.currentUser.value!;
      final prenom = user['prenom'] ?? '';
      final nom = user['nom'] ?? '';
      userName.value = '$prenom $nom'.trim();
    }
    
    // Charger solde et transactions
    await Future.wait([
      loadSolde(),
      loadTransactions(),
    ]);
  }
  
  /// Charger le solde
  Future<void> loadSolde() async {
    isLoadingSolde.value = true;
    
    try {
      print('💰 Chargement du solde...');
      final newSolde = await _compteService.consulterMonSolde();
      solde.value = newSolde;
      print('✅ Solde chargé : $newSolde FCFA');
    } catch (e) {
      print('❌ Erreur chargement solde : $e');
      solde.value = 0.0;
    } finally {
      isLoadingSolde.value = false;
    }
  }
  
  /// Charger l'historique des transactions
  Future<void> loadTransactions() async {
    isLoadingTransactions.value = true;
    
    try {
      print('📜 Chargement de l\'historique...');
      final history = await _transactionService.getHistorique();
      transactions.value = history;
      print('✅ ${history.length} transactions chargées');
    } catch (e) {
      print('❌ Erreur chargement transactions : $e');
      transactions.value = [];
    } finally {
      isLoadingTransactions.value = false;
    }
  }
  
  /// Rafraîchir toutes les données
  Future<void> refresh() async {
    print('🔄 Rafraîchissement...');
    await Future.wait([
      loadSolde(),
      loadTransactions(),
    ]);
  }
  
  /// Se déconnecter
  Future<void> logout() async {
    try {
      print('🚪 Déconnexion...');
      
      await _authService.logout();
      
      Get.offAllNamed(Routes.LOGIN);
      
      Get.snackbar(
        'Déconnexion',
        'À bientôt !',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      print('❌ Erreur déconnexion : $e');
    }
  }
  
  /// Navigation vers le profil (à implémenter)
  void goToProfile() {
    Get.snackbar(
      'Info',
      'Page profil à venir',
      snackPosition: SnackPosition.BOTTOM,
    );
  }
}
```

### 13.2 Modifier HomeView

**Fichier** : `lib/app/modules/home/views/home_view.dart`

**SUPPRIMER tout et REMPLACER par** :

```dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/home_controller.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/balance_card.dart';

/// Vue pour l'écran d'accueil
class HomeView extends GetView<HomeController> {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Obx(() => Text(
          'Bonjour ${controller.userName.value}',
          style: const TextStyle(color: Colors.white),
        )),
        actions: [
          IconButton(
            icon: const Icon(Icons.person, color: Colors.white),
            onPressed: controller.goToProfile,
          ),
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: controller.logout,
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: controller.refresh,
        color: AppColors.primaryOrange,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Carte de solde
                Obx(() => BalanceCard(
                  balance: controller.solde.value,
                  isLoading: controller.isLoadingSolde.value,
                )),
                
                const SizedBox(height: 24),
                
                // Actions rapides
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildActionButton(
                      icon: Icons.send,
                      label: 'Transfert',
                      onTap: () {
                        Get.snackbar('Info', 'Transfert à venir');
                      },
                    ),
                    _buildActionButton(
                      icon: Icons.shopping_cart,
                      label: 'Paiement',
                      onTap: () {
                        Get.snackbar('Info', 'Paiement à venir');
                      },
                    ),
                    _buildActionButton(
                      icon: Icons.qr_code_scanner,
                      label: 'Scanner',
                      onTap: () {
                        Get.snackbar('Info', 'Scanner à venir');
                      },
                    ),
                  ],
                ),
                
                const SizedBox(height: 32),
                
                // Titre historique
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Historique',
                      style: AppTextStyles.header3,
                    ),
                    Obx(() => controller.isLoadingTransactions.value
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: AppColors.primaryOrange,
                          ),
                        )
                      : const SizedBox.shrink(),
                    ),
                  ],
                ),
                
                const SizedBox(height: 16),
                
                // Liste des transactions
                Obx(() {
                  final txList = controller.transactions;
                  
                  if (txList.isEmpty) {
                    return _buildEmptyState();
                  }
                  
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: txList.length,
                    itemBuilder: (context, index) {
                      final tx = txList[index];
                      return _buildTransactionItem(tx);
                    },
                  );
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }
  
  /// Bouton d'action rapide
  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: 100,
        padding: const EdgeInsets.symmetric(vertical: 20),
        decoration: BoxDecoration(
          color: AppColors.cardBackground,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: AppColors.primaryOrange.withOpacity(0.3),
          ),
        ),
        child: Column(
          children: [
            Icon(icon, color: AppColors.primaryOrange, size: 32),
            const SizedBox(height: 8),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  /// Item de transaction
  Widget _buildTransactionItem(dynamic tx) {
    // Adapter selon la structure de vos transactions
    final type = tx['type'] ?? 'TRANSFERT';
    final montant = (tx['montant'] ?? 0).toDouble();
    final date = tx['date'] ?? '';
    final destinataire = tx['destinataire'] ?? 'Inconnu';
    
    final isDebit = type == 'TRANSFERT' || type == 'PAIEMENT';
    
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          // Icône
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: isDebit
                ? Colors.red.withOpacity(0.2)
                : Colors.green.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(
              isDebit ? Icons.arrow_upward : Icons.arrow_downward,
              color: isDebit ? Colors.red : Colors.green,
            ),
          ),
          
          const SizedBox(width: 12),
          
          // Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  type,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  destinataire,
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 12,
                  ),
                ),
                if (date.isNotEmpty)
                  Text(
                    date,
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 11,
                    ),
                  ),
              ],
            ),
          ),
          
          // Montant
          Text(
            '${isDebit ? '-' : '+'} ${montant.toStringAsFixed(0)} FCFA',
            style: TextStyle(
              color: isDebit ? Colors.red : Colors.green,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
  
  /// État vide
  Widget _buildEmptyState() {
    return Container(
      padding: const EdgeInsets.all(40),
      child: Column(
        children: [
          Icon(
            Icons.receipt_long,
            size: 64,
            color: AppColors.textSecondary.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          Text(
            'Aucune transaction',
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}
```

---

<a name="etape14"></a>
## 🧪 ÉTAPE 14 : TESTER L'APPLICATION

**⏱️ Temps** : 10 minutes

**🎯 But** : Lancer l'application et vérifier que tout fonctionne.

### 14.1 Vérifier les imports

Ouvrez chaque fichier créé et vérifiez qu'il n'y a pas d'erreurs d'import (lignes rouges).

### 14.2 Lancer l'application

```bash
cd /home/mouhamadou-lamine/flutter/OMPay_GetX/mon_app_getx
flutter run
```

### 14.3 Parcours de test

1. **Splash** → Doit rediriger vers Login (1ère fois)
2. **Login** → Cliquer sur "S'inscrire"
3. **Register** → Remplir le formulaire et s'inscrire
4. **Activate** → Entrer le code secret reçu par SMS
5. **Home** → Voir le solde et l'historique

### 14.4 Points de vérification

✅ Splash affiche le logo pendant 2 secondes  
✅ Login affiche les erreurs de validation  
✅ Register vérifie que les mots de passe correspondent  
✅ Activate redirige vers Home après activation  
✅ Home affiche le solde et l'historique  
✅ Déconnexion ramène au Login

---

<a name="etape15"></a>
## 🐛 ÉTAPE 15 : CORRIGER LES ERREURS COURANTES

**⏱️ Temps** : Variable

**🎯 But** : Résoudre les problèmes fréquents.

### 15.1 Erreur : "Get.find() failed"

**Cause** : Un service n'a pas été initialisé dans main.dart.

**Solution** :
```dart
// Vérifier que tous les services sont dans initServices()
Get.put(AuthService());
Get.put(CompteService());
Get.put(TransactionService());
```

### 15.2 Erreur : "Cannot find widget X"

**Cause** : Widget custom non trouvé.

**Solution** :
```bash
# Vérifier que les widgets ont été copiés
ls -la lib/core/widgets/
```

Si manquants, recopier depuis l'ancien projet :
```bash
cp -r OM_Pay/nom_du_projet/lib/widgets/* mon_app_getx/lib/core/widgets/
```

### 15.3 Erreur : "AppColors not found"

**Cause** : Theme non copié.

**Solution** :
```bash
cp -r OM_Pay/nom_du_projet/lib/theme/* mon_app_getx/lib/core/theme/
```

### 15.4 Erreur réseau : "Connection refused"

**Cause** : Backend inaccessible.

**Solution** :
1. Vérifier l'URL dans `api_provider.dart` :
```dart
static const String baseUrl = 'https://om-pay-spring-boot-1.onrender.com/api';
```

2. Tester l'URL dans le navigateur : https://om-pay-spring-boot-1.onrender.com/api

3. Si le serveur est endormi (Render free tier), attendre 1-2 minutes qu'il se réveille.

### 15.5 Erreur : "Token invalid"

**Cause** : Token expiré.

**Solution** :
- Se déconnecter et se reconnecter
- Ou effacer le cache :
```bash
flutter clean
flutter pub get
```

### 15.6 Debug avec les logs

Dans la console, vous verrez :
- 🚀 = Démarrage
- ✅ = Succès
- ❌ = Erreur
- 🔍 = Vérification
- 💰 = Solde
- 📜 = Transactions

**Exemple de logs normaux** :
```
🚀 Démarrage des services...
✅ AuthService initialisé
✅ CompteService initialisé
✅ Tous les services sont prêts !
🔍 Vérification de l'authentification...
❌ Non connecté → Redirection vers Login
```

---

## 🎉 FÉLICITATIONS !

Vous avez terminé la transformation de **OM Pay** en **GetX** !

### 📚 Récapitulatif

Vous avez appris à :
- ✅ Utiliser GetX pour la gestion d'état
- ✅ Créer des Controllers réactifs avec `.obs`
- ✅ Naviguer avec Get.toNamed()
- ✅ Injecter des services avec Get.put() et Get.find()
- ✅ Gérer l'authentification avec JWT
- ✅ Faire des requêtes HTTP
- ✅ Afficher des erreurs de validation

### 🚀 Prochaines étapes

1. **Ajouter les fonctionnalités manquantes** :
   - Page Transfert
   - Page Paiement
   - Scanner QR Code
   - Page Profil

2. **Améliorer l'UX** :
   - Animations
   - Gestion du mode hors ligne
   - Notifications push

3. **Optimiser** :
   - Cache des transactions
   - Pagination
   - Images optimisées

### 📖 Ressources GetX

- Documentation : https://pub.dev/packages/get
- Tutoriels : https://github.com/jonataslaw/getx
- Communauté Discord : https://discord.gg/9Hpt99N

---

## ❓ BESOIN D'AIDE ?

Si vous rencontrez un problème :

1. **Vérifier les logs** dans la console
2. **Relire l'étape** concernée
3. **Comparer votre code** avec le guide
4. **Tester sur un vrai appareil** (parfois l'émulateur a des bugs)

**Bon courage ! 💪**