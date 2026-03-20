// lib/providers/auth_provider.dart
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../data/models/models.dart';
import '../core/constants/app_constants.dart';

enum AuthStatus { initial, loading, authenticated, unauthenticated, error }

class AuthProvider extends ChangeNotifier {
  static const _storage = FlutterSecureStorage();

  AuthStatus _status = AuthStatus.initial;
  UserModel? _user;
  String? _error;
  String? _pendingPhone;

  AuthStatus get status => _status;
  UserModel? get user => _user;
  String? get error => _error;
  String? get pendingPhone => _pendingPhone;
  bool get isAuthenticated => _status == AuthStatus.authenticated;

  Future<void> checkAuth() async {
    _status = AuthStatus.loading;
    notifyListeners();

    try {
      final token = await _storage.read(key: AppConstants.kAuthToken);
      if (token != null) {
        // In real app: validate token with API and fetch user
        _user = _getMockUser();
        _status = AuthStatus.authenticated;
      } else {
        _status = AuthStatus.unauthenticated;
      }
    } catch (_) {
      _status = AuthStatus.unauthenticated;
    }
    notifyListeners();
  }

  Future<bool> sendOtp(String phone) async {
    _status = AuthStatus.loading;
    _error = null;
    _pendingPhone = phone;
    notifyListeners();

    // Simulate API
    await Future.delayed(const Duration(seconds: 1));

    // In real app: POST /auth/send-otp
    _status = AuthStatus.unauthenticated;
    notifyListeners();
    return true;
  }

  Future<bool> verifyOtp(String otp) async {
    _status = AuthStatus.loading;
    _error = null;
    notifyListeners();

    await Future.delayed(const Duration(seconds: 1));

    // Mock: accept any 6-digit OTP
    if (otp.length == AppConstants.otpLength) {
      final token = 'mock_jwt_token_${DateTime.now().millisecondsSinceEpoch}';
      await _storage.write(key: AppConstants.kAuthToken, value: token);
      _user = _getMockUser();
      _status = AuthStatus.authenticated;
      notifyListeners();
      return true;
    } else {
      _error = 'Invalid OTP. Please try again.';
      _status = AuthStatus.unauthenticated;
      notifyListeners();
      return false;
    }
  }

  Future<bool> updateProfile({
    required String name,
    String? email,
  }) async {
    if (_user == null) return false;
    _user = UserModel(
      id: _user!.id,
      name: name,
      phone: _user!.phone,
      email: email ?? _user!.email,
      membershipTier: _user!.membershipTier,
      totalOrders: _user!.totalOrders,
      totalSaved: _user!.totalSaved,
    );
    notifyListeners();
    return true;
  }

  Future<void> logout() async {
    await _storage.delete(key: AppConstants.kAuthToken);
    await _storage.delete(key: AppConstants.kRefreshToken);
    _user = null;
    _status = AuthStatus.unauthenticated;
    notifyListeners();
  }

  UserModel _getMockUser() => const UserModel(
    id: 'user_001',
    name: 'Rajesh Patel',
    phone: '+91 98765 43210',
    email: 'rajesh@example.com',
    membershipTier: 'gold',
    totalOrders: 23,
    totalSaved: 480,
    addresses: [
      AddressModel(
        id: 'addr_1',
        label: 'Home',
        recipientName: 'Rajesh Patel',
        phone: '+91 98765 43210',
        line1: '12, Shyamal Society, Alkapuri',
        city: 'Vadodara',
        state: 'Gujarat',
        pincode: '390007',
        isDefault: true,
      ),
      AddressModel(
        id: 'addr_2',
        label: 'Work',
        recipientName: 'Rajesh Patel',
        phone: '+91 98765 43210',
        line1: 'Plot 45, GIDC, Makarpura',
        city: 'Vadodara',
        state: 'Gujarat',
        pincode: '390010',
      ),
    ],
  );
}
