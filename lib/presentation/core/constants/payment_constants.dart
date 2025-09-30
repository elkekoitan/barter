import 'package:flutter/material.dart';

class PaymentConstants {
  // ========== PAPARA ==========
  static const String PAPARA_API_KEY = String.fromEnvironment('PAPARA_API_KEY');
  static const String PAPARA_SECRET = String.fromEnvironment('PAPARA_SECRET');
  static const String PAPARA_BASE_URL = 'https://merchant-api.papara.com.tr/v1';

  // ========== TOSLA ==========
  static const String TOSLA_MERCHANT_ID = String.fromEnvironment('TOSLA_MERCHANT_ID');
  static const String TOSLA_API_KEY = String.fromEnvironment('TOSLA_API_KEY');
  static const String TOSLA_BASE_URL = 'https://api.tosla.com.tr/v2';

  // ========== İYZICO ==========
  static const String IYZICO_API_KEY = String.fromEnvironment('IYZICO_API_KEY');
  static const String IYZICO_SECRET_KEY = String.fromEnvironment('IYZICO_SECRET_KEY');
  static const String IYZICO_BASE_URL = 'https://sandbox-api.iyzipay.com'; // Prod: https://api.iyzipay.com

  // ========== PAYTR ==========
  static const String PAYTR_MERCHANT_ID = String.fromEnvironment('PAYTR_MERCHANT_ID');
  static const String PAYTR_MERCHANT_KEY = String.fromEnvironment('PAYTR_MERCHANT_KEY');
  static const String PAYTR_MERCHANT_SALT = String.fromEnvironment('PAYTR_MERCHANT_SALT');
  static const String PAYTR_BASE_URL = 'https://www.paytr.com/odeme/api/get-token';

  // ========== BKM EXPRESS ==========
  static const String BKM_EXPRESS_MERCHANT_ID = String.fromEnvironment('BKM_MERCHANT_ID');
  static const String BKM_EXPRESS_BASE_URL = 'https://sanalpos.bkmexpress.com.tr';

  // ========== PAYCELL ==========
  static const String PAYCELL_APP_ID = String.fromEnvironment('PAYCELL_APP_ID');
  static const String PAYCELL_APP_SECRET = String.fromEnvironment('PAYCELL_APP_SECRET');
  static const String PAYCELL_BASE_URL = 'https://api-sandbox.paycell.com.tr';

  // ========== PARAM ==========
  static const String PARAM_CLIENT_CODE = String.fromEnvironment('PARAM_CLIENT_CODE');
  static const String PARAM_API_KEY = String.fromEnvironment('PARAM_API_KEY');
  static const String PARAM_BASE_URL = 'https://paramws.param.com.tr';

  // ========== COMMISSIONS ==========
  static const double BARTER_COMMISSION_RATE = 0.03; // %3
  static const double FEATURED_LISTING_PRICE = 49.90;
  static const double PREMIUM_MEMBERSHIP_MONTHLY = 99.90;
  static const double ESCROW_HOLD_FEE = 1.50; // Sabit TL emanet ücreti

  // ========== PAYMENT PROVIDERS ENUM ==========
  static const List<String> SUPPORTED_PROVIDERS = [
    // Enabled providers
    'papara',
    'iyzico',
    // Disabled (not implemented)
    // 'tosla',
    // 'paytr',
    // 'bkm_express',
    // 'paycell',
    // 'param'
  ];

  // ========== PROVIDER COLORS ==========
  static const Map<String, Color> PROVIDER_COLORS = {
    'papara': Color(0xFF00D4AA),
    'tosla': Color(0xFF0066CC),
    'iyzico': Color(0xFF1A1A1A),
    'paytr': Color(0xFF8B5CF6),
    'bkm_express': Color(0xFFFF6B35),
    'paycell': Color(0xFF7C3AED),
    'param': Color(0xFF059669),
  };

  // ========== PROVIDER LOGOS (Asset paths) ==========
  static const Map<String, String> PROVIDER_LOGOS = {
    'papara': 'assets/images/providers/papara.png',
    'tosla': 'assets/images/providers/tosla.png',
    'iyzico': 'assets/images/providers/iyzico.png',
    'paytr': 'assets/images/providers/paytr.png',
    'bkm_express': 'assets/images/providers/bkm_express.png',
    'paycell': 'assets/images/providers/paycell.png',
    'param': 'assets/images/providers/param.png',
  };

  // ========== CURRENCIES ==========
  static const List<String> SUPPORTED_CURRENCIES = ['TRY', 'USD', 'EUR'];
  static const String DEFAULT_CURRENCY = 'TRY';

  // ========== PAYMENT STATUS ==========
  static const String PAYMENT_STATUS_PENDING = 'pending';
  static const String PAYMENT_STATUS_PROCESSING = 'processing';
  static const String PAYMENT_STATUS_COMPLETED = 'completed';
  static const String PAYMENT_STATUS_FAILED = 'failed';
  static const String PAYMENT_STATUS_REFUNDED = 'refunded';
  static const String PAYMENT_STATUS_CANCELLED = 'cancelled';

  // ========== ESCROW STATUS ==========
  static const String ESCROW_STATUS_HELD = 'held';
  static const String ESCROW_STATUS_RELEASED = 'released';
  static const String ESCROW_STATUS_DISPUTED = 'disputed';

  // ========== API ENDPOINTS ==========
  static const String PAYMENT_CALLBACK_URL = 'https://api.bogazicibarter.com/webhooks/payment';
  static const String PAYMENT_FAILURE_URL = 'https://app.bogazicibarter.com/payment/failure';
  static const String PAYMENT_SUCCESS_URL = 'https://app.bogazicibarter.com/payment/success';

  // ========== TIMEOUTS ==========
  static const Duration PAYMENT_TIMEOUT = Duration(minutes: 10);
  static const Duration WEBHOOK_TIMEOUT = Duration(seconds: 30);
  static const Duration REFUND_TIMEOUT = Duration(minutes: 5);

  // ========== RETRY CONFIGURATIONS ==========
  static const int MAX_RETRY_ATTEMPTS = 3;
  static const Duration RETRY_DELAY = Duration(seconds: 2);

  // ========== MIN/MAX AMOUNTS ==========
  static const double MIN_PAYMENT_AMOUNT = 1.0;
  static const double MAX_PAYMENT_AMOUNT = 50000.0;
  static const double MIN_ESCROW_AMOUNT = 50.0;
}
