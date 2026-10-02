import 'package:http/http.dart' as http;
import 'dart:convert';

class AuthService {
  Future<String?> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('http://localhost:3000/api/auth/login'), // Remplace localhost par l’IP de ton PC si tu testes sur mobile
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'email': email, 'password': password}),
    );
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['token'];
    } else {
      return null;
    }
  }
}