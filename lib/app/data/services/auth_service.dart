import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../providers/auth_provider.dart';
import '../models/request/login_request.dart';
import '../models/request/register_request.dart';
import '../models/request/verify_code_request.dart';
import '../models/response/auth_response.dart';
import '../models/response/user_response.dart';
import 'compte_service.dart';
import '../providers/compte_provider.dart';
import '../providers/transaction_provider.dart';
import 'transaction_service.dart';

class AuthService extends GetxService {
  final AuthProvider _authProvider = Get.find<AuthProvider>();
  
  final Rx<UserResponse?> currentUser = Rx<UserResponse?>(null);
  final RxString token = ''.obs;
  
  bool get isLoggedIn => currentUser.value != null && token.value.isNotEmpty;
  UserResponse? get user => currentUser.value;

  Future<AuthService> init() async {
    await loadUser();
    return this;
  }

  Future<AuthResponse> login(String telephone, String motDePasse) async {
    try {
      final request = LoginRequest(
        telephone: telephone,
        motDePasse: motDePasse,
      );

      final response = await _authProvider.login(request);

      if (response.body == null) {
        throw Exception('Réponse vide du serveur');
      }

      final authResponse = response.body!;

      if (authResponse.success && authResponse.token != null) {
        token.value = authResponse.token!;
        
        if (authResponse.user != null) {
          currentUser.value = authResponse.user;
          await _saveUser(authResponse.user!, authResponse.token!);
        }
        _authProvider.setToken(authResponse.token!);
        
        try {
          final compteProvider = Get.find<CompteProvider>();
          final compteService = Get.find<CompteService>();
          final transactionProvider = Get.find<TransactionProvider>();
          
          compteProvider.setToken(authResponse.token!);
          transactionProvider.setToken(authResponse.token!);
          await compteService.getSolde();
        } catch (e) {
          // Ignore silently
        }
      }

      return authResponse;
    } catch (e) {
      throw Exception('Erreur de connexion: ${e.toString()}');
    }
  }

  Future<AuthResponse> register(RegisterRequest request) async {
    try {
      final response = await _authProvider.register(request);

      if (response.body == null) {
        throw Exception('Réponse vide du serveur');
      }

      return response.body!;
    } catch (e) {
      throw Exception('Erreur d\'inscription: ${e.toString()}');
    }
  }

  Future<AuthResponse> verifyCode(String telephone, String codeSecret) async {
    try {
      final request = VerifyCodeRequest(
        telephone: telephone,
        codeSecret: codeSecret,
      );

      final response = await _authProvider.verifyCode(request);

      if (response.body == null) {
        throw Exception('Réponse vide du serveur');
      }

      final authResponse = response.body!;

      if (authResponse.success && authResponse.token != null) {
        token.value = authResponse.token!;
        if (authResponse.user != null) {
          currentUser.value = authResponse.user;
          await _saveUser(authResponse.user!, authResponse.token!);
        }
        _authProvider.setToken(authResponse.token!);
      }

      return authResponse;
    } catch (e) {
      throw Exception('Erreur de vérification: ${e.toString()}');
    }
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('user');
    await prefs.remove('token');
    
    currentUser.value = null;
    token.value = '';
    _authProvider.removeToken();
    
    try {
      final compteProvider = Get.find<CompteProvider>();
      final compteService = Get.find<CompteService>();
      final transactionProvider = Get.find<TransactionProvider>();
      final transactionService = Get.find<TransactionService>();
      
      compteProvider.removeToken();
      transactionProvider.removeToken();
      compteService.resetSolde();
      compteService.resetCache(); // Réinitialiser le cache du numeroCompte
      transactionService.resetTransactions();
    } catch (e) {
      // Ignore silently
    }
  }

  Future<void> _saveUser(UserResponse user, String userToken) async {
    final prefs = await SharedPreferences.getInstance();
    
    final userJson = jsonEncode({
      'id': user.id,
      'nom': user.nom,
      'prenom': user.prenom,
      'telephone': user.telephone,
      'email': user.email,
      'role': user.role.name,
      'statut': user.statut.name,
      'premiereConnexion': user.premiereConnexion,
      'dateCreation': user.dateCreation,
    });
    
    await prefs.setString('user', userJson);
    await prefs.setString('token', userToken);
  }

  Future<void> loadUser() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userJson = prefs.getString('user');
      final savedToken = prefs.getString('token');

      if (userJson != null && savedToken != null) {
        final userData = jsonDecode(userJson);
        currentUser.value = UserResponse.fromJson(userData);
        token.value = savedToken;
        _authProvider.setToken(savedToken);

        try {
          final compteProvider = Get.find<CompteProvider>();
          final compteService = Get.find<CompteService>();
          final transactionProvider = Get.find<TransactionProvider>();
          
          compteProvider.setToken(savedToken);
          transactionProvider.setToken(savedToken);
          await compteService.getSolde();
        } catch (e) {
          // Ignore silently
        }
      }
    } catch (e) {
      // Ignore silently
    }
  }
}