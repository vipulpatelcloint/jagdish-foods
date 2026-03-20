// lib/services/payment_service.dart
import 'package:flutter/material.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import '../core/constants/app_constants.dart';

typedef PaymentSuccessCallback = void Function(PaymentSuccessResponse);
typedef PaymentFailureCallback = void Function(PaymentFailureResponse);
typedef PaymentExternalWalletCallback = void Function(ExternalWalletResponse);

class PaymentService {
  static final PaymentService _instance = PaymentService._internal();
  factory PaymentService() => _instance;
  PaymentService._internal();

  late Razorpay _razorpay;
  PaymentSuccessCallback? _onSuccess;
  PaymentFailureCallback? _onFailure;
  PaymentExternalWalletCallback? _onExternalWallet;

  void init() {
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handleSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handleFailure);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  void _handleSuccess(PaymentSuccessResponse response) {
    _onSuccess?.call(response);
  }

  void _handleFailure(PaymentFailureResponse response) {
    _onFailure?.call(response);
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    _onExternalWallet?.call(response);
  }

  /// Opens Razorpay checkout
  Future<void> openCheckout({
    required double amount, // In rupees (will be converted to paise)
    required String orderId,
    required String customerName,
    required String customerPhone,
    String? customerEmail,
    String? description,
    PaymentSuccessCallback? onSuccess,
    PaymentFailureCallback? onFailure,
    PaymentExternalWalletCallback? onExternalWallet,
  }) async {
    _onSuccess = onSuccess;
    _onFailure = onFailure;
    _onExternalWallet = onExternalWallet;

    final options = {
      'key': AppConstants.razorpayKey,
      'amount': (amount * 100).toInt(), // Convert to paise
      'order_id': orderId,
      'name': 'Jagdish Foods',
      'description': description ?? 'Authentic Gujarati Snacks',
      'image': 'https://jagdishfoods.com/logo.png',
      'prefill': {
        'name': customerName,
        'contact': customerPhone,
        if (customerEmail != null) 'email': customerEmail,
      },
      'theme': {
        'color': '#0083BC', // Jagdish Foods blue
      },
      'modal': {
        'confirm_close': true,
        'animation': true,
        'backdropclose': false,
      },
      'config': {
        'display': {
          'blocks': {
            'upi': {
              'name': 'Pay via UPI',
              'instruments': [
                {'method': 'upi', 'flows': ['qr', 'collect', 'intent']},
              ],
            },
            'card': {
              'name': 'Card',
              'instruments': [
                {'method': 'card'},
              ],
            },
            'cod': {
              'name': 'Cash on Delivery',
              'instruments': [
                {'method': 'cod'},
              ],
            },
          },
          'sequence': ['block.upi', 'block.card', 'block.cod'],
          'preferences': {
            'show_default_blocks': false,
          },
        },
      },
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      debugPrint('Razorpay error: $e');
      rethrow;
    }
  }

  void dispose() {
    _razorpay.clear();
  }
}
