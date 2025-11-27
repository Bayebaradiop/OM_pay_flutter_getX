# 🚀 Guide d'implémentation de la Connexion avec GetX
## 📱 Approche Endpoint par Endpoint

Ce guide suit une approche **pratique et progressive** : on implémente **un endpoint à la fois** avec tous ses composants (modèles, service, controller, vue, routes, tests).

> ✨ **Principe** : Chaque endpoint est complètement fonctionnel avant de passer au suivant !

---

## 📚 Table des matières

### 🔧 Configuration initiale
- [Étape 0 : Préparation du projet](#etape-0)

### 🎯 Endpoints à implémenter
- [📍 Endpoint 1 : Connexion (Login)](#endpoint-1) ⭐ COMMENCER ICI
- [📍 Endpoint 2 : Inscription (Register)](#endpoint-2)
- [📍 Endpoint 3 : Activation du compte](#endpoint-3)
- [📍 Endpoint 4 : Déconnexion (Logout)](#endpoint-4)

### ✅ Finalisation
- [Tests et validation](#tests)

---

<a name="etape-0"></a>
## 🔧 ÉTAPE 0 : PRÉPARATION DU PROJET (Une seule fois)

### 0.1 Créer la structure des dossiers

```bash
cd /home/mouhamadou-lamine/flutter/getx/OMPay_GetX/mon_app_getx/lib

# Structure GetX
mkdir -p app/modules/auth/{controllers,views,bindings}
mkdir -p app/modules/home/{controllers,views,bindings}
mkdir -p app/modules/splash/{controllers,views,bindings}
mkdir -p app/routes
mkdir -p app/data/{models,providers,services}
mkdir -p app/core/{utils,theme,widgets}
```

### 0.2 Vérifier pubspec.yaml

Vérifier que vous avez :
```yaml
dependencies:
  get: ^4.7.2
  http: ^1.1.0
  shared_preferences: ^2.2.2
```

Puis :
```bash
flutter pub get
```

### 0.3 Créer les fichiers de base (routes)

**Fichier : `lib/app/routes/app_routes.dart`**

```bash
cat > lib/app/routes/app_routes.dart << 'EOF'
abstract class AppRoutes {
  static const LOGIN = '/login';
  static const REGISTER = '/register';
  static const ACTIVATE = '/activate';
  static const HOME = '/home';
  static const SPLASH = '/';
}
EOF
```

**Fichier : `lib/app/routes/app_pages.dart`** (vide pour l'instant, on le remplira progressivement)

```bash
cat > lib/app/routes/app_pages.dart << 'EOF'
import 'package:get/get.dart';
import 'app_routes.dart';

class AppPages {
  static const INITIAL = AppRoutes.LOGIN;
  
  static final routes = <GetPage>[
    // Les routes seront ajoutées endpoint par endpoint
  ];
}
EOF
```

✅ **Configuration initiale terminée !** Passons au premier endpoint.

---

<a name="endpoint-1"></a>
# 📍 ENDPOINT 1 : CONNEXION (LOGIN)

## 🎯 Objectif
Implémenter la connexion utilisateur avec téléphone + mot de passe.

**Endpoint API** : `POST /api/auth/login`

**Données envoyées** :
```json
{
  "telephone": "771234567",
  "motDePasse": "password123"
}
```

**Réponse attendue** :
```json
{
  "id": "1",
  "nom": "Diop",
  "prenom": "Amadou",
  "email": "amadou@email.com",
  "telephone": "771234567",
  "role": "client",
  "token": "eyJhbGciOiJIUzI1NiIs..."
}
```

---

## 📦 ÉTAPE 1.1 : Créer les modèles de données

### A. Modèle de requête (ce qu'on envoie à l'API)

**Fichier : `lib/app/data/models/login_request.dart`**

```dart
/// Modèle pour la requête de connexion
class LoginRequest {
  final String telephone;
  final String motDePasse;

  LoginRequest({
    required this.telephone,
    required this.motDePasse,
  });

  /// Convertir en JSON pour l'API
  Map<String, dynamic> toJson() {
    return {
      'telephone': telephone,
      'motDePasse': motDePasse,
    };
  }
}
```

**Créer le fichier** :
```bash
cat > lib/app/data/models/login_request.dart << 'EOF'
/// Modèle pour la requête de connexion
class LoginRequest {
  final String telephone;
  final String motDePasse;

  LoginRequest({
    required this.telephone,
    required this.motDePasse,
  });

  Map<String, dynamic> toJson() {
    return {
      'telephone': telephone,
      'motDePasse': motDePasse,
    };
  }
}
EOF
```

---

### B. Modèle de réponse (ce qu'on reçoit de l'API)

**Fichier : `lib/app/data/models/login_response.dart`**

```dart
/// Modèle pour la réponse de connexion
class LoginResponse {
  final String id;
  final String email;
  final String nom;
  final String prenom;
  final String telephone;
  final String role;
  final String? token;

  LoginResponse({
    required this.id,
    required this.email,
    required this.nom,
    required this.prenom,
    required this.telephone,
    required this.role,
    this.token,
  });

  /// Créer un LoginResponse depuis JSON (réponse API)
  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      id: json['id']?.toString() ?? '',
      email: json['email'] ?? '',
      nom: json['nom'] ?? '',
      prenom: json['prenom'] ?? '',
      telephone: json['telephone'] ?? '',
      role: json['role'] ?? 'client',
      token: json['token'],
    );
  }

  /// Convertir en JSON (pour sauvegarde locale)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'nom': nom,
      'prenom': prenom,
      'telephone': telephone,
      'role': role,
      'token': token,
    };
  }
}
```

**Créer le fichier** :
```bash
cat > lib/app/data/models/login_response.dart << 'EOF'
/// Modèle pour la réponse de connexion
class LoginResponse {
  final String id;
  final String email;
  final String nom;
  final String prenom;
  final String telephone;
  final String role;
  final String? token;

  LoginResponse({
    required this.id,
    required this.email,
    required this.nom,
    required this.prenom,
    required this.telephone,
    required this.role,
    this.token,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      id: json['id']?.toString() ?? '',
      email: json['email'] ?? '',
      nom: json['nom'] ?? '',
      prenom: json['prenom'] ?? '',
      telephone: json['telephone'] ?? '',
      role: json['role'] ?? 'client',
      token: json['token'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'nom': nom,
      'prenom': prenom,
      'telephone': telephone,
      'role': role,
      'token': token,
    };
  }
}
EOF
```

✅ **Modèles créés !**

---

## 🌐 ÉTAPE 1.2 : Créer le Provider API

**Fichier : `lib/app/data/providers/auth_provider.dart`**

Le provider gère les appels HTTP :

```dart
import 'package:get/get.dart';

/// Provider pour les requêtes d'authentification
class AuthProvider extends GetConnect {
  
  @override
  void onInit() {
    // ⚠️ IMPORTANT : Changer cette URL selon votre backend
    httpClient.baseUrl = 'http://localhost:8000/api';
    httpClient.timeout = const Duration(seconds: 30);
    
    // Headers par défaut
    httpClient.addRequestModifier<dynamic>((request) {
      request.headers['Accept'] = 'application/json';
      request.headers['Content-Type'] = 'application/json';
      return request;
    });

    super.onInit();
  }

  /// LOGIN - Connexion utilisateur
  Future<Response> login(String telephone, String motDePasse) async {
    return await post('/auth/login', {
      'telephone': telephone,
      'motDePasse': motDePasse,
    });
  }
}
```

**Créer le fichier** :
```bash
cat > lib/app/data/providers/auth_provider.dart << 'EOF'
import 'package:get/get.dart';

class AuthProvider extends GetConnect {
  
  @override
  void onInit() {
    httpClient.baseUrl = 'http://localhost:8000/api'; // TODO: Changer selon votre API
    httpClient.timeout = const Duration(seconds: 30);
    
    httpClient.addRequestModifier<dynamic>((request) {
      request.headers['Accept'] = 'application/json';
      request.headers['Content-Type'] = 'application/json';
      return request;
    });

    super.onInit();
  }

  Future<Response> login(String telephone, String motDePasse) async {
    return await post('/auth/login', {
      'telephone': telephone,
      'motDePasse': motDePasse,
    });
  }
}
EOF
```

✅ **Provider créé !**

---

## 🔧 ÉTAPE 1.3 : Créer le Service d'authentification

**Fichier : `lib/app/data/services/auth_service.dart`**

Le service utilise le provider et gère la logique métier :

```dart
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../providers/auth_provider.dart';
import '../models/login_response.dart';

/// Service d'authentification
class AuthService extends GetxService {
  final AuthProvider authProvider = Get.find<AuthProvider>();
  
  // Utilisateur connecté (réactif)
  final Rx<LoginResponse?> currentUser = Rx<LoginResponse?>(null);
  
  /// Vérifie si un utilisateur est connecté
  bool get isLoggedIn => currentUser.value != null;

  /// CONNEXION
  Future<bool> login(String telephone, String motDePasse) async {
    try {
      print('🔐 Tentative de connexion : $telephone');
      
      final response = await authProvider.login(telephone, motDePasse);
      
      if (response.statusCode == 200 && response.body != null) {
        // Parser la réponse
        final userData = response.body;
        final user = LoginResponse.fromJson(userData);
        
        // Sauvegarder l'utilisateur
        currentUser.value = user;
        await _saveUser(user);
        
        print('✅ Connexion réussie !');
        return true;
      } else {
        print('❌ Échec connexion : ${response.statusText}');
        return false;
      }
    } catch (e) {
      print('❌ Erreur connexion : $e');
      return false;
    }
  }

  /// Sauvegarder l'utilisateur localement
  Future<void> _saveUser(LoginResponse user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_id', user.id);
    await prefs.setString('user_nom', user.nom);
    await prefs.setString('user_prenom', user.prenom);
    await prefs.setString('user_email', user.email);
    await prefs.setString('user_telephone', user.telephone);
    await prefs.setString('user_role', user.role);
    if (user.token != null) {
      await prefs.setString('user_token', user.token!);
    }
  }

  /// Charger l'utilisateur sauvegardé
  Future<void> loadUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('user_id');
    
    if (userId != null) {
      currentUser.value = LoginResponse(
        id: userId,
        nom: prefs.getString('user_nom') ?? '',
        prenom: prefs.getString('user_prenom') ?? '',
        email: prefs.getString('user_email') ?? '',
        telephone: prefs.getString('user_telephone') ?? '',
        role: prefs.getString('user_role') ?? 'client',
        token: prefs.getString('user_token'),
      );
    }
  }

  /// DÉCONNEXION
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    currentUser.value = null;
    print('✅ Déconnexion réussie');
  }
}
```

**Créer le fichier** :
```bash
cat > lib/app/data/services/auth_service.dart << 'EOF'
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../providers/auth_provider.dart';
import '../models/login_response.dart';

class AuthService extends GetxService {
  final AuthProvider authProvider = Get.find<AuthProvider>();
  final Rx<LoginResponse?> currentUser = Rx<LoginResponse?>(null);
  bool get isLoggedIn => currentUser.value != null;

  Future<bool> login(String telephone, String motDePasse) async {
    try {
      print('🔐 Tentative de connexion : $telephone');
      
      final response = await authProvider.login(telephone, motDePasse);
      
      if (response.statusCode == 200 && response.body != null) {
        final userData = response.body;
        final user = LoginResponse.fromJson(userData);
        currentUser.value = user;
        await _saveUser(user);
        print('✅ Connexion réussie !');
        return true;
      } else {
        print('❌ Échec connexion : ${response.statusText}');
        return false;
      }
    } catch (e) {
      print('❌ Erreur connexion : $e');
      return false;
    }
  }

  Future<void> _saveUser(LoginResponse user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_id', user.id);
    await prefs.setString('user_nom', user.nom);
    await prefs.setString('user_prenom', user.prenom);
    await prefs.setString('user_email', user.email);
    await prefs.setString('user_telephone', user.telephone);
    await prefs.setString('user_role', user.role);
    if (user.token != null) {
      await prefs.setString('user_token', user.token!);
    }
  }

  Future<void> loadUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('user_id');
    
    if (userId != null) {
      currentUser.value = LoginResponse(
        id: userId,
        nom: prefs.getString('user_nom') ?? '',
        prenom: prefs.getString('user_prenom') ?? '',
        email: prefs.getString('user_email') ?? '',
        telephone: prefs.getString('user_telephone') ?? '',
        role: prefs.getString('user_role') ?? 'client',
        token: prefs.getString('user_token'),
      );
    }
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    currentUser.value = null;
    print('✅ Déconnexion réussie');
  }
}
EOF
```

✅ **Service créé !**

---

## 🎮 ÉTAPE 1.4 : Créer le Controller

**Fichier : `lib/app/modules/auth/controllers/login_controller.dart`**

_(Contenu dans le message suivant pour rester dans la limite...)_

Voulez-vous que je continue avec les étapes 1.4 à 1.9 pour compléter l'endpoint LOGIN ? 🚀
