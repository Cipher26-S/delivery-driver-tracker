import 'package:http/http.dart' as http;
import 'dart:convert';
import '../config.dart';

class AuthSession {
  final String token;
  final String userId;
  final String name;
  final String role;

  AuthSession({required this.token, required this.userId, required this.name, required this.role});

  bool get isAdmin => role == 'admin';
}

class AuthService {
  /// Renvoie la session si la connexion réussit, sinon `null`.
  Future<AuthSession?> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$apiBaseUrl/auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'email': email, 'password': password}),
    );
    if (response.statusCode != 200) return null;

    final data = json.decode(response.body);
    final user = data['user'];
    return AuthSession(
      token: data['token'],
      userId: user['id'],
      name: user['name'],
      role: user['role'],
    );
  }
}
