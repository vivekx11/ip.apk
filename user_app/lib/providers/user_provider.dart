import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserProvider extends ChangeNotifier {
  String? _username;
  bool _isLoading = false;

  String? get username => _username;
  bool get isLoading => _isLoading;
  bool get hasUsername => _username != null && _username!.isNotEmpty;

  Future<void> loadUsername() async {
    _isLoading = true;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      _username = prefs.getString('username');
    } catch (e) {
      print('Error loading username: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> saveUsername(String username) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('username', username);
      _username = username;
      notifyListeners();
    } catch (e) {
      print('Error saving username: $e');
      throw Exception('Failed to save username');
    }
  }

  Future<void> clearUsername() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('username');
      _username = null;
      notifyListeners();
    } catch (e) {
      print('Error clearing username: $e');
    }
  }
}