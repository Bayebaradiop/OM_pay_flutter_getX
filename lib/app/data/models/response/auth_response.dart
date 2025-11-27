import 'user_response.dart';

class AuthResponse {
  final bool success;
  final String message;
  final String? token;
  final String? codeSecret;
  final UserResponse? user;

  AuthResponse({
    required this.success,
    required this.message,
    this.token,
    this.codeSecret,
    this.user,
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    // Le backend peut retourner les données dans 'data' ou directement à la racine
    final data = json['data'] ?? json;
    
    // Créer UserResponse à partir de data s'il contient nom, prenom, telephone
    UserResponse? userResponse;
    if (data['user'] != null) {
      userResponse = UserResponse.fromJson(data['user']);
    } else if (data['nom'] != null && data['prenom'] != null) {
      // L'API retourne les infos user directement dans data
      userResponse = UserResponse.fromJson(data);
    }
    
    return AuthResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      token: data['token'],
      codeSecret: data['codeSecret'],
      user: userResponse,
    );
  }
}
