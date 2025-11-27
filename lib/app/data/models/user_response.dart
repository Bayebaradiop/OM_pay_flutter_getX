class UserResponse {
  final int id;
  final String nom;
  final String prenom;
  final String telephone;
  final String email;
  final String role;

  UserResponse({
    required this.id,
    required this.nom,
    required this.prenom,
    required this.telephone,
    required this.email,
    required this.role,
  });

  factory UserResponse.fromJson(Map<String, dynamic> json) {
    return UserResponse(
      id: json['id'],
      nom: json['nom'] ?? '',
      prenom: json['prenom'] ?? '',
      telephone: json['telephone'] ?? '',
      email: json['email'] ?? '',
      role: json['role'] ?? 'CLIENT',
    );
  }
}
