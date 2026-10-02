import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import 'admin_screen.dart';
import 'deliveries_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final authService = AuthService();
  String? error;
  final _formKey = GlobalKey<FormState>();

  void handleLogin() async {
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate()) return;
    AuthSession? session;
    try {
      session = await authService.login(emailController.text.trim(), passwordController.text);
    } catch (_) {
      if (!mounted) return;
      setState(() => error = 'Serveur injoignable');
      return;
    }
    if (!mounted) return;
    if (session == null) {
      setState(() => error = 'Email ou mot de passe incorrect');
      return;
    }
    final s = session;
    setState(() => error = null);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => s.isAdmin
            ? AdminScreen(token: s.token)
            : DeliveriesScreen(driverId: s.userId, token: s.token),
      ),
    );
  }

  InputDecoration _field(String label, IconData icon) => InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.indigo.shade50,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundColor: Colors.indigo,
                      child: const Icon(Icons.local_shipping, size: 40, color: Colors.white),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Delivery Driver Tracker',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Vos livraisons, votre position, en temps voulu.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey.shade700),
                    ),
                    const SizedBox(height: 32),
                    const Text('Connexion', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: emailController,
                      decoration: _field('Email', Icons.email_outlined),
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.isEmpty) return 'Email requis';
                        if (!RegExp(r'^\S+@\S+\.\S+$').hasMatch(value)) return 'Email invalide';
                        return null;
                      },
                      textInputAction: TextInputAction.next,
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: passwordController,
                      decoration: _field('Mot de passe', Icons.lock_outline),
                      obscureText: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) return 'Mot de passe requis';
                        if (value.length < 6) return 'Au moins 6 caractères';
                        return null;
                      },
                      textInputAction: TextInputAction.done,
                      onFieldSubmitted: (_) => handleLogin(),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: handleLogin,
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 50),
                        backgroundColor: Colors.indigo,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: const Text('Se connecter'),
                    ),
                    if (error != null) ...[
                      const SizedBox(height: 12),
                      Text(error!, textAlign: TextAlign.center, style: const TextStyle(color: Colors.red)),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
