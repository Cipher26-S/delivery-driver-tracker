import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../config.dart';

class AdminScreen extends StatefulWidget {
  final String token;

  const AdminScreen({super.key, required this.token});

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  String? _message;
  bool _isError = false;

  Future<void> _addDriver() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _message = null;
      _isError = false;
    });

    final response = await http.post(
      Uri.parse('$apiBaseUrl/auth/register'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${widget.token}',
      },
      body: json.encode({
        'name': nameController.text,
        'email': emailController.text,
        'password': passwordController.text,
        'role': 'driver',
      }),
    );

    if (!mounted) return;
    if (response.statusCode == 201) {
      setState(() {
        _message = 'Chauffeur ajouté avec succès !';
        _isError = false;
      });
      nameController.clear();
      emailController.clear();
      passwordController.clear();
    } else {
      final errorData = json.decode(response.body);
      setState(() {
        _message = 'Erreur: ${errorData['error'] ?? 'Impossible d\'ajouter le chauffeur.'}';
        _isError = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Administration'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Ajouter un nouveau chauffeur',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: 'Nom',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer un nom';
                  }
                  return null;
                },
              ),
              SizedBox(height: 15),
              TextFormField(
                controller: emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer un email';
                  }
                  if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                    return 'Veuillez entrer un email valide';
                  }
                  return null;
                },
              ),
              SizedBox(height: 15),
              TextFormField(
                controller: passwordController,
                decoration: InputDecoration(
                  labelText: 'Mot de passe',
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer un mot de passe';
                  }
                  if (value.length < 6) {
                    return 'Le mot de passe doit contenir au moins 6 caractères';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _addDriver,
                child: Text('Ajouter le chauffeur'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.indigo,
                  minimumSize: Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              SizedBox(height: 20),
              if (_message != null)
                Text(
                  _message!,
                  style: TextStyle(
                    color: _isError ? Colors.red : Colors.green,
                    fontWeight: FontWeight.bold,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
