import 'package:flutter/material.dart';
import 'package:listinhax/app/features/login/login_viewmodel.dart';

class LoginScreen extends StatefulWidget {
  final LoginViewmodel loginViewmodel;

  const LoginScreen({super.key, required this.loginViewmodel});

  @override
  State createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  void _login() {
    if (_formKey.currentState?.validate() ?? false) {
      final email = _emailController.text.trim();
      final password = _passwordController.text.trim();
      widget.loginViewmodel.login(email, password);
    }
  }

  void _createUser() {
    if (_formKey.currentState?.validate() ?? false) {
      final email = _emailController.text.trim();
      final password = _passwordController.text.trim();
      widget.loginViewmodel.createUserAndLoggedIn(email, password);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Acesse sua Conta'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(labelText: 'Email'),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Informe seu email';
                  }
                  return null;
                },
              ),
              SizedBox(height: 24),
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(labelText: 'Password'),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Informe sua senha';
                  }
                  if (value.length < 8) {
                    return 'Senha deve ter 8 caracteres';
                  }
                  return null;
                },
              ),
              SizedBox(height: 24),
              FilledButton(
                onPressed: _login,
                child: Text('Entrar'),
              ),
              SizedBox(height: 24),
              OutlinedButton(
                onPressed: _createUser,
                child: Text('Criar conta e entrar'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
