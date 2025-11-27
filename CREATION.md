# 📝 ÉTAPES DE CRÉATION DU PROJET OM PAY AVEC GETX

## 🎯 Projet : Transformation de OM Pay en GetX Pattern

---

## 📅 Date de création : 24 novembre 2025

---

## 🚀 ÉTAPE 1 : INSTALLATION DE GET_CLI

### 1.1 Installer get_cli globalement

```bash
flutter pub global activate get_cli
```

**Résultat attendu** :
```
Activated get_cli 1.9.1.
Installed executables get and getx.
```

### 1.2 Ajouter get_cli au PATH

```bash
export PATH="$PATH":"$HOME/.pub-cache/bin"
```

**Note** : Pour rendre permanent, ajoutez cette ligne dans `~/.bashrc` ou `~/.zshrc` :

```bash
echo 'export PATH="$PATH":"$HOME/.pub-cache/bin"' >> ~/.bashrc
source ~/.bashrc
```

### 1.3 Vérifier l'installation

```bash
get --version
```

**Résultat** :
```
Version: 1.9.1
```

---

## 📁 ÉTAPE 2 : INITIALISATION DE LA STRUCTURE GETX

### 2.1 Aller dans le projet

```bash
cd /home/mouhamadou-lamine/flutter/OMPay_GetX/mon_app_getx
```

### 2.2 Initialiser GetX Pattern

```bash
get init
```

**Choix effectués** :
- Architecture : `1) GetX Pattern (by Kauê)`
- Écraser le dossier lib : `1) Yes!`
- Mettre à jour get : `1) Yes!`

**Résultat** :
```
✓ Package: get installed!
✓ File: main.dart created successfully
✓ File: home_controller.dart created successfully
✓ File: home_view.dart created successfully
✓ File: home_binding.dart created successfully
✓ File: app_routes.dart created successfully
✓ File: app_pages.dart created successfully
✓ GetX Pattern structure successfully generated.
```

---

## 🎨 ÉTAPE 3 : CRÉATION DES PAGES

### 3.1 Créer la page Splash

```bash
get create page:splash
```

**Fichiers créés** :
- `lib/app/modules/splash/controllers/splash_controller.dart`
- `lib/app/modules/splash/views/splash_view.dart`
- `lib/app/modules/splash/bindings/splash_binding.dart`

### 3.2 Créer la page Login

```bash
get create page:login
```

**Fichiers créés** :
- `lib/app/modules/login/controllers/login_controller.dart`
- `lib/app/modules/login/views/login_view.dart`
- `lib/app/modules/login/bindings/login_binding.dart`

### 3.3 Créer la page Register

```bash
get create page:register
```

**Fichiers créés** :
- `lib/app/modules/register/controllers/register_controller.dart`
- `lib/app/modules/register/views/register_view.dart`
- `lib/app/modules/register/bindings/register_binding.dart`

### 3.4 Créer la page Activate

```bash
get create page:activate
```

**Fichiers créés** :
- `lib/app/modules/activate/controllers/activate_controller.dart`
- `lib/app/modules/activate/views/activate_view.dart`
- `lib/app/modules/activate/bindings/activate_binding.dart`

---

## 📦 ÉTAPE 4 : COPIE DES FICHIERS DE L'ANCIEN PROJET

### 4.1 Copier les fichiers réutilisables

```bash
cd /home/mouhamadou-lamine/flutter/OMPay_GetX

# Theme (couleurs, styles, thème)
cp -r OM_Pay/nom_du_projet/lib/theme mon_app_getx/lib/core/

# Widgets (composants UI réutilisables)
cp -r OM_Pay/nom_du_projet/lib/widgets mon_app_getx/lib/core/

# Utils (constantes, messages d'erreur)
cp -r OM_Pay/nom_du_projet/lib/utils mon_app_getx/lib/core/

# DTOs (modèles de données)
cp -r OM_Pay/nom_du_projet/lib/dto mon_app_getx/lib/data/models/

# Enums (types énumérés)
cp -r OM_Pay/nom_du_projet/lib/enums mon_app_getx/lib/core/

# Assets (images)
cp -r OM_Pay/nom_du_projet/assets mon_app_getx/
```

### 4.2 Fichiers copiés (30 fichiers environ)

**Theme** (3 fichiers) :
- `app_colors.dart` - Couleurs de l'application
- `app_text_styles.dart` - Styles de texte
- `app_theme.dart` - Thème global

**Widgets** (9 fichiers) :
- `balance_card.dart`
- `carousel_image.dart`
- `custom_button.dart`
- `custom_drawer.dart`
- `custom_snackbar.dart`
- `custom_text_field.dart`
- `rainbow_decorator.dart`
- `transaction_card.dart`
- `transaction_type_toggle.dart`

**Utils** (4 fichiers) :
- `constants.dart` - URL API et constantes
- `error_messages.dart` - Messages d'erreur français
- `error_message_en.dart` - Messages anglais
- `error_message_wolof.dart` - Messages wolof

**DTOs** (10 fichiers) :
- Request : `login_request.dart`, `register_request.dart`, `verify_code_request.dart`, `transfert_request.dart`, `paiement_request.dart`
- Response : `auth_response.dart`, `user_response.dart`, `profile_response.dart`, `compte_response.dart`, `transaction_response.dart`

**Enums** (4 fichiers) :
- `role.dart`
- `statut.dart`
- `statut_transaction.dart`
- `type_transaction.dart`

---

## 🏗️ STRUCTURE FINALE DU PROJET

```
mon_app_getx/
├── lib/
│   ├── app/
│   │   ├── modules/
│   │   │   ├── splash/
│   │   │   │   ├── controllers/
│   │   │   │   │   └── splash_controller.dart
│   │   │   │   ├── views/
│   │   │   │   │   └── splash_view.dart
│   │   │   │   └── bindings/
│   │   │   │       └── splash_binding.dart
│   │   │   ├── login/
│   │   │   │   ├── controllers/
│   │   │   │   │   └── login_controller.dart
│   │   │   │   ├── views/
│   │   │   │   │   └── login_view.dart
│   │   │   │   └── bindings/
│   │   │   │       └── login_binding.dart
│   │   │   ├── register/
│   │   │   │   ├── controllers/
│   │   │   │   ├── views/
│   │   │   │   └── bindings/
│   │   │   ├── activate/
│   │   │   │   ├── controllers/
│   │   │   │   ├── views/
│   │   │   │   └── bindings/
│   │   │   └── home/
│   │   │       ├── controllers/
│   │   │       │   └── home_controller.dart
│   │   │       ├── views/
│   │   │       │   └── home_view.dart
│   │   │       └── bindings/
│   │   │           └── home_binding.dart
│   │   └── routes/
│   │       ├── app_routes.dart
│   │       └── app_pages.dart
│   ├── data/
│   │   ├── models/
│   │   │   └── dto/
│   │   │       ├── request/
│   │   │       └── response/
│   │   ├── providers/
│   │   │   └── api_provider.dart (À CRÉER)
│   │   └── services/
│   │       ├── auth_service.dart (À CRÉER)
│   │       ├── compte_service.dart (À CRÉER)
│   │       └── transaction_service.dart (À CRÉER)
│   ├── core/
│   │   ├── theme/
│   │   │   ├── app_colors.dart
│   │   │   ├── app_text_styles.dart
│   │   │   └── app_theme.dart
│   │   ├── widgets/
│   │   │   ├── balance_card.dart
│   │   │   ├── carousel_image.dart
│   │   │   ├── custom_button.dart
│   │   │   ├── custom_drawer.dart
│   │   │   ├── custom_snackbar.dart
│   │   │   ├── custom_text_field.dart
│   │   │   ├── rainbow_decorator.dart
│   │   │   ├── transaction_card.dart
│   │   │   └── transaction_type_toggle.dart
│   │   ├── utils/
│   │   │   ├── constants.dart
│   │   │   ├── error_messages.dart
│   │   │   ├── error_message_en.dart
│   │   │   └── error_message_wolof.dart
│   │   └── enums/
│   │       ├── role.dart
│   │       ├── statut.dart
│   │       ├── statut_transaction.dart
│   │       └── type_transaction.dart
│   └── main.dart
├── assets/
│   └── images/
├── pubspec.yaml
└── README.md
```

---

## 📝 PROCHAINES ÉTAPES (À FAIRE)

### Étape 5 : Créer les Services GetX
- [ ] Créer `api_provider.dart` (gestion HTTP + token)
- [ ] Créer `auth_service.dart` (login, register, logout)
- [ ] Créer `compte_service.dart` (solde)
- [ ] Créer `transaction_service.dart` (transferts, historique)

### Étape 6 : Modifier main.dart
- [ ] Configurer GetMaterialApp
- [ ] Initialiser les services avec Get.put()
- [ ] Configurer le thème

### Étape 7 : Ajuster app_pages.dart
- [ ] Changer INITIAL de HOME vers SPLASH
- [ ] Vérifier les routes

### Étape 8 : Implémenter les Controllers
- [ ] SplashController (vérification auth)
- [ ] LoginController (logique de connexion)
- [ ] RegisterController (logique d'inscription)
- [ ] ActivateController (activation compte)
- [ ] HomeController (logique page d'accueil)

### Étape 9 : Implémenter les Views
- [ ] SplashView (écran de démarrage)
- [ ] LoginView (formulaire de connexion)
- [ ] RegisterView (formulaire d'inscription)
- [ ] ActivateView (formulaire d'activation)
- [ ] HomeView (page d'accueil)

### Étape 10 : Tests et Validation
- [ ] Tester la navigation
- [ ] Tester l'authentification
- [ ] Tester les transactions
- [ ] Corriger les bugs

---

## 📚 COMMANDES UTILES

### Commandes get_cli

```bash
# Créer une nouvelle page
get create page:nom_page

# Créer un controller dans un module existant
get create controller:nom_controller on home

# Créer une view dans un module existant
get create view:nom_view on home

# Mettre à jour get_cli
get update

# Voir la version
get --version

# Aide
get help
```

### Commandes Flutter

```bash
# Installer les dépendances
flutter pub get

# Nettoyer le projet
flutter clean

# Lancer l'application
flutter run

# Vérifier les erreurs
flutter analyze
```

---

## 🔧 CONFIGURATION PUBSPEC.YAML

```yaml
dependencies:
  flutter:
    sdk: flutter
  get: ^4.7.2              # GetX
  cupertino_icons: ^1.0.8
  http: ^1.1.0             # Requêtes HTTP
  shared_preferences: ^2.2.2  # Stockage local
  mailer: ^6.0.1           # Envoi emails
  qr_flutter: ^4.1.0       # QR codes
  mobile_scanner: ^3.5.5   # Scanner QR

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^5.0.0
```

---

## ✅ CHECKLIST DE CRÉATION

- [x] Installer get_cli
- [x] Ajouter get_cli au PATH
- [x] Initialiser GetX avec `get init`
- [x] Créer page splash
- [x] Créer page login
- [x] Créer page register
- [x] Créer page activate
- [x] Créer page home (déjà créée par get init)
- [x] Copier theme de l'ancien projet
- [x] Copier widgets de l'ancien projet
- [x] Copier utils de l'ancien projet
- [x] Copier dto de l'ancien projet
- [x] Copier enums de l'ancien projet
- [x] Copier assets de l'ancien projet
- [ ] Créer ApiProvider
- [ ] Créer AuthService
- [ ] Créer CompteService
- [ ] Créer TransactionService
- [ ] Modifier main.dart
- [ ] Ajuster app_pages.dart
- [ ] Implémenter tous les controllers
- [ ] Implémenter toutes les views
- [ ] Tester l'application

---

## 📖 RESSOURCES

- **Documentation GetX** : https://pub.dev/packages/get
- **Get CLI** : https://pub.dev/packages/get_cli
- **Guide GetX Pattern** : https://github.com/kauemurakami/getx_pattern

---

## 👤 AUTEUR

**Projet** : OM Pay - Application de paiement mobile Orange Money
**Framework** : Flutter avec GetX Pattern
**Date** : Novembre 2025

---

## 📌 NOTES IMPORTANTES

1. **get_cli simplifie énormément la création** : Au lieu de créer 3 fichiers manuellement (controller, view, binding), une seule commande `get create page:nom` fait tout.

2. **Structure GetX Pattern** : Séparation claire entre :
   - **Controllers** : Logique métier
   - **Views** : Interface utilisateur
   - **Bindings** : Injection de dépendances

3. **Avantages de cette structure** :
   - Code testable facilement
   - Réutilisable
   - Maintenable
   - Performance optimale

4. **Ne pas oublier** :
   - Toujours mettre à jour `app_pages.dart` après création d'une page
   - Les routes sont générées automatiquement dans `app_routes.dart`
   - Le binding est automatiquement lié à la route

---

**Fin du document de création**
