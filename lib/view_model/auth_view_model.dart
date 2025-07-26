import 'package:flutter/material.dart';
import '../service/auth_service.dart';

class AuthViewModel extends ChangeNotifier {
  final AuthService _authService = AuthService();

  Future<void> login(String email, String password) async {
    try {
      await _authService.signIn(email, password);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> register(String email, String password) async {
    try {
      await _authService.signUp(email, password);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> logout() async {
    await _authService.signOut();
  }
}
