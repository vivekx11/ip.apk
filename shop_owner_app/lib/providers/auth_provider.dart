import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../models/shop_owner_model.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();
  bool _isLoading = false;
  String? _error;
  ShopOwnerModel? _currentOwner;

  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isLoggedIn => _currentOwner != null;
  ShopOwnerModel? get currentOwner => _currentOwner;

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
      _currentOwner = await _authService.loadSavedAuth();
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
    } finally {
      setLoading(false);
    }
  }

  Future<bool> verifyOTP(String phoneNumber, String otp) async {
    setLoading(true);
    setError(null);
    try {
      _currentOwner = await _authService.verifyOTP(phoneNumber, otp);
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
      _currentOwner = null;
    } catch (e) {
      setError(e.toString());
    } finally {
      setLoading(false);
    }
  }
}