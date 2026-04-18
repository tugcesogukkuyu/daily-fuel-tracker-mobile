import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthStore extends ChangeNotifier {
  static const FlutterSecureStorage _storage = FlutterSecureStorage();

  static const String _userIdKey = 'auth_user_id';
  static const String _fullNameKey = 'auth_full_name';
  static const String _emailKey = 'auth_email';
  static const String _tokenKey = 'auth_token';

  int? _userId;
  String? _fullName;
  String? _email;
  String? _token;

  int? get userId => _userId;
  String? get fullName => _fullName;
  String? get email => _email;
  String? get token => _token;

  bool get isLoggedIn => _userId != null && _token != null;

  Future<void> restoreSession() async {
    final userIdRaw = await _storage.read(key: _userIdKey);
    final fullName = await _storage.read(key: _fullNameKey);
    final email = await _storage.read(key: _emailKey);
    final token = await _storage.read(key: _tokenKey);

    if (userIdRaw == null || fullName == null || email == null || token == null) {
      return;
    }

    _userId = int.tryParse(userIdRaw);
    _fullName = fullName;
    _email = email;
    _token = token;

    notifyListeners();
  }

  Future<void> setSession({
    required int userId,
    required String fullName,
    required String email,
    required String token,
  }) async {
    _userId = userId;
    _fullName = fullName;
    _email = email;
    _token = token;

    await _storage.write(key: _userIdKey, value: userId.toString());
    await _storage.write(key: _fullNameKey, value: fullName);
    await _storage.write(key: _emailKey, value: email);
    await _storage.write(key: _tokenKey, value: token);

    notifyListeners();
  }

  Future<void> clearSession() async {
    _userId = null;
    _fullName = null;
    _email = null;
    _token = null;

    await _storage.delete(key: _userIdKey);
    await _storage.delete(key: _fullNameKey);
    await _storage.delete(key: _emailKey);
    await _storage.delete(key: _tokenKey);

    notifyListeners();
  }
}

final AuthStore authStore = AuthStore();
