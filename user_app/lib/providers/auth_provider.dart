import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../models/user_model.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();
  bool _isLoading = false;
  String? _error;
  UserModel? _currentUser;

  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isLoggedIn => _currentUser != null;
  UserModel? get currentUser => _currentUser;

  void setUser(UserModel user) {
    _currentUser = user;
    notifyListeners();
  }

  void setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void setError(String? error) {
    _error = error;
    notifyListeners();
  }

  Future<void> loadSavedAuth() async {
    setLoading(true);
    try {
      await _authService.loadSavedAuth();
      _currentUser = _authService.currentUser;
    } catch (e) {
      setError(e.toString());
    } finally {
      setLoading(false);
    }
  }

  Future<void> sendOTP(String phoneNumber) async {
    setLoading(true);
    setError(null);
    try {
      await _authService.sendOTP(phoneNumber);
    } catch (e) {
      setError(e.toString());
      rethrow;
    } finally {
      setLoading(false);
    }
  }

  Future<bool> verifyOTP(String phoneNumber, String otp) async {
    setLoading(true);
    setError(null);
    try {
      _currentUser = await _authService.verifyOTP(phoneNumber, otp);
      return true;
    } catch (e) {
      setError(e.toString());
      return false;
    } finally {
      setLoading(false);
    }
  }

  Future<void> logout() async {
    setLoading(true);
    try {
      await _authService.logout();
      _currentUser = null;
    } catch (e) {
      setError(e.toString());
    } finally {
      setLoading(false);
    }
  }

  Future<void> updateProfile({
    String? name,
    String? email,
    String? address,
  }) async {
    setLoading(true);
    setError(null);
    try {
      await _authService.updateProfile(
        name: name,
        email: email,
        address: address,
      );
      _currentUser = _authService.currentUser;
    } catch (e) {
      setError(e.toString());
      rethrow;
    } finally {
      setLoading(false);
    }
  }
}
