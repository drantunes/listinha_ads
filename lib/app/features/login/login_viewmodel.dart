import 'package:flutter/material.dart';
import 'package:listinhax/app/data/repositories/user_repository.dart';

class LoginViewmodel extends ChangeNotifier {
  final UserRepository userRepository;

  LoginViewmodel({required this.userRepository});

  void login(String email, String password) {
    userRepository.login(email, password);
  }

  void createUserAndLoggedIn(String email, String password) {
    userRepository.createUserAndLogin(email, password);
  }
}
