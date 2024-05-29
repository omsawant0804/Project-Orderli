import 'package:flutter/material.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class Razc {
  late Razorpay _razorpay;
  final BuildContext context;

  Razc(this.context) {
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  void dispose() {
    _razorpay.clear();
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text("Payment Successful: ${response.paymentId}"),
    ));
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text("Payment Error: ${response.code} - ${response.message}"),
    ));
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text("External Wallet Selected: ${response.walletName}"),
    ));
  }

  /*void openCheckout() {
    var options = {
      'key': 'rzp_test_GcZZFDPP0jHtC4', // Use your Razorpay Test API Key
      'amount': 1000, // Amount in paise
      'name': 'orderli.',
      'description': 'Pizza',
      'prefill': {
        'contact': '8888888888',
        'email': 'test@razorpay.com',
      },
      'method': {
        'upi': true,
      }
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      debugPrint('Error: $e');
    }
  }*/

  void openCheckout(double totalAmount) {
    var options = {
      'key': 'rzp_test_GcZZFDPP0jHtC4', // Use your Razorpay Test API Key
      'amount': totalAmount * 100, // Amount in paise
      'name': 'orderli.',
      'prefill': {
        'contact': '8888888888',
        'email': 'test@razorpay.com',
      },
      'method': {
        'upi': true,
      }
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      debugPrint('Error: $e');
    }
  }





}