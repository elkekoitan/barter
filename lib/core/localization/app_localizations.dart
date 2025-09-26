import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import '../../domain/entities/listing.dart';
import '../../domain/entities/barter_offer.dart';

class AppLocalizations {
  final Locale locale;
  late Map<String, dynamic> _localizedStrings;
  late Map<String, dynamic> _validationMessages;
  late Map<String, dynamic> _authValidation;
  late Map<String, dynamic> _barterValidation;

  AppLocalizations(this.locale);

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  Future<bool> load() async {
    String jsonString = await rootBundle.loadString('assets/translations/${locale.languageCode}.json');
    Map<String, dynamic> jsonMap = json.decode(jsonString);

    _localizedStrings = jsonMap;
    _validationMessages = jsonMap['validation_messages'] ?? {};
    _authValidation = jsonMap['auth_validation'] ?? {};
    _barterValidation = jsonMap['barter_validation'] ?? {};

    return true;
  }

  String translate(String key, {List<String>? args}) {
    String? value = _getNestedValue(_localizedStrings, key);
    if (value == null) {
      return key; // Fallback to key if translation not found
    }

    if (args != null && args.isNotEmpty) {
      return _replaceArguments(value, args);
    }

    return value;
  }

  // Generic translation methods
  String get appName => translate('app_name');
  String get smartBarterPlatform => translate('smart_barter_platform');
  String get welcome => translate('welcome');
  String get welcomeBack => translate('welcome_back');
  String get discoverAmazingBarters => translate('discover_amazing_barters');

  // Navigation
  String get explore => translate('explore');
  String get categories => translate('categories');
  String get createListing => translate('create_listing');
  String get messages => translate('messages');
  String get profile => translate('profile');

  // Common UI
  String get next => translate('next');
  String get previous => translate('previous');
  String get cancel => translate('cancel');
  String get confirm => translate('confirm');
  String get save => translate('save');
  String get delete => translate('delete');
  String get edit => translate('edit');
  String get loading => translate('loading');
  String get error => translate('error');
  String get success => translate('success');
  String get warning => translate('warning');
  String get info => translate('info');

  // Authentication
  String get login => translate('login');
  String get register => translate('register');
  String get logout => translate('logout');
  String get forgotPassword => translate('forgot_password');
  String get resetPassword => translate('reset_password');
  String get email => translate('email');
  String get password => translate('password');
  String get confirmPassword => translate('confirm_password');
  String get phone => translate('phone');
  String get fullName => translate('full_name');

  // Listing Creation Steps
  String get category => translate('category');
  String get details => translate('details');
  String get media => translate('media');
  String get pricing => translate('pricing');
  String get review => translate('review');
  String get publish => translate('publish');
  String get saveDraft => translate('save_draft');
  String get draftSaved => translate('draft_saved');

  String get listings => translate('listings');
  String get myListings => translate('my_listings');
  String get featured => translate('featured');
  String get urgent => translate('urgent');
  String get condition => translate('condition');
  String get brand => translate('brand');
  String get model => translate('model');
  String get year => translate('year');
  String get description => translate('description');

  // Barter
  String get barterAvailable => translate('barter_available');
  String get negotiable => translate('negotiable');
  String get fixedPrice => translate('fixed_price');
  String get startingPrice => translate('starting_price');

  // Delivery
  String get deliveryOptions => translate('delivery_options');
  String get freeShipping => translate('free_shipping');
  String get shippingCost => translate('shipping_cost');
  String get estimatedDelivery => translate('estimated_delivery');

  // Steps
  String get categoryStep => translate('category_step');
  String get selectCategory => translate('select_category');
  String get subcategories => translate('subcategories');
  String get noCategorySelected => translate('no_category_selected');

  String get detailsStep => translate('details_step');
  String get listingTitle => translate('listing_title');
  String get listingDescription => translate('listing_description');
  String get productCondition => translate('product_condition');
  String get productBrand => translate('product_brand');
  String get productModel => translate('product_model');
  String get productYear => translate('product_year');

  String get mediaStep => translate('media_step');
  String get addPhotos => translate('add_photos');
  String get photoRequirements => translate('photo_requirements');
  String get primaryPhoto => translate('primary_photo');
  String get dragToReorder => translate('drag_to_reorder');

  String get pricingStep => translate('pricing_step');
  String get cashPrice => translate('cash_price');
  String get barterOptions => translate('barter_options');
  String get preferredItems => translate('preferred_items');
  String get minCashDifference => translate('min_cash_difference');
  String get maxCashDifference => translate('max_cash_difference');

  String get deliveryStep => translate('delivery_step');
  String get deliveryMethod => translate('delivery_method');
  String get cargoProvider => translate('cargo_provider');
  String get trackingNumber => translate('tracking_number');
  String get pickupLocation => translate('pickup_location');
  String get deliveryLocation => translate('delivery_location');

  String get reviewStep => translate('review_step');
  String get listingSummary => translate('listing_summary');
  String get publishListing => translate('publish_listing');
  String get editStep => translate('edit_step');

  // Validation
  String get validationError => translate('validation_error');
  String fieldRequired(String fieldName) => translate('field_required', args: [fieldName]);
  String get invalidEmail => translate('invalid_email');
  String get passwordTooShort => translate('password_too_short');
  String get passwordsNotMatch => translate('passwords_not_match');
  String get invalidPhone => translate('invalid_phone');
  String get titleTooShort => translate('title_too_short');
  String get descriptionTooShort => translate('description_too_short');
  String get selectAtLeastOneImage => translate('select_at_least_one_image');
  String get priceTooHigh => translate('price_too_high');

  // Success/Error Messages
  String get loginSuccess => translate('login_success');
  String get registerSuccess => translate('register_success');
  String get logoutSuccess => translate('logout_success');
  String get profileUpdated => translate('profile_updated');

  String get listingCreatedSuccessfully => translate('listing_created_successfully');
  String get listingUpdatedSuccessfully => translate('listing_updated_successfully');
  String get listingDeletedSuccessfully => translate('listing_deleted_successfully');

  String get offerSentSuccessfully => translate('offer_sent_successfully');
  String get offerAccepted => translate('offer_accepted');
  String get offerRejected => translate('offer_rejected');
  String get offerCountered => translate('offer_countered');

  String get transactionCreated => translate('transaction_created');
  String get deliveryConfirmed => translate('delivery_confirmed');
  String get paymentCompleted => translate('payment_completed');
  String get transactionCompleted => translate('transaction_completed');

  String get pleaseCompleteAllRequiredFields => translate('please_complete_all_required_fields');
  String get pleaseSelectCategory => translate('please_select_category');
  String get pleaseAddAtLeastOneImage => translate('please_add_at_least_one_image');

  String get viewListing => translate('view_listing');
  String get backToHome => translate('back_to_home');
  String navigateToListingDetail(String listingId) => translate('navigate_to_listing_detail', args: [listingId]);

  String get searchListings => translate('search_listings');
  String get noListingsFound => translate('no_listings_found');
  String get beFirstToCreateListing => translate('be_first_to_create_listing');
  String get createFirstListing => translate('create_first_listing');

  String get pendingReview => translate('pending_review');
  String get underReview => translate('under_review');
  String get needsReview => translate('needs_review');

  String get featuredListing => translate('featured_listing');
  String get premiumListing => translate('premium_listing');
  String get boostListing => translate('boost_listing');

  // Formatted values
  String get currencySymbol => translate('currency_symbol');
  String get numberFormat => translate('number_format.decimal_separator');
  String get thousandSeparator => translate('number_format.thousand_separator');

  // Enums
  String getBoostTypeDisplayName(BoostType type) {
    String key = 'boost_types.${type.value}';
    return translate(key);
  }

  String getListingStatusDisplayName(ListingStatus status) {
    String key = 'listing_status.${status.value}';
    return translate(key);
  }

  String getModerationStatusDisplayName(ModerationStatus status) {
    String key = 'moderation_status.${status.value}';
    return translate(key);
  }

  String getOfferStatusDisplayName(OfferStatus status) {
    return translate('offer_status.${status.value}');
  }

  String getTransactionStatusDisplayName(TransactionStatus status) {
    return translate('transaction_status.${status.value}');
  }

  // Date formatting
  String formatDate(DateTime date, {bool short = false, bool withTime = false}) {
    String pattern;
    if (withTime) {
      pattern = translate('date_format.with_time');
    } else if (short) {
      pattern = translate('date_format.short');
    } else {
      pattern = translate('date_format.long');
    }

    final DateFormat formatter = DateFormat(pattern, locale.languageCode);
    return formatter.format(date);
  }

  // Number formatting
  String formatNumber(double number) {
    final NumberFormat formatter = NumberFormat.currency(
      locale: locale.languageCode,
      symbol: currencySymbol,
      decimalDigits: 2,
    );
    return formatter.format(number);
  }

  String formatPrice(double price, {String? currency}) {
    final String symbol = currency ?? currencySymbol;
    final String formattedNumber = _formatNumberWithSeparators(price);
    return '$formattedNumber $symbol';
  }

  String _formatNumberWithSeparators(double number) {
    final String decimalSep = '.';
    final String thousandSep = ',';

    final List<String> parts = number.toStringAsFixed(2).split('.');
    String integerPart = parts[0];
    String decimalPart = parts[1];

    // Add thousand separators
    final RegExp regex = RegExp(r'(\d)(?=(\d{3})+(?!\d))');
    integerPart = integerPart.replaceAllMapped(regex, (match) => '${match.group(1)}$thousandSep');

    return '$integerPart$decimalSep$decimalPart';
  }

  // Relative time
  String getRelativeTime(DateTime dateTime) {
    final Duration difference = DateTime.now().difference(dateTime);

    if (difference.inMinutes < 1) {
      return translate('just_now');
    } else if (difference.inHours < 1) {
      return translate('minutes_ago', args: [difference.inMinutes.toString()]);
    } else if (difference.inDays < 1) {
      return translate('hours_ago', args: [difference.inHours.toString()]);
    } else {
      return translate('days_ago', args: [difference.inDays.toString()]);
    }
  }

  // Validation helpers
  String getValidationMessage(String key, {List<String>? args}) {
    String? message = _getNestedValue(_validationMessages, key);
    if (message == null) {
      return translate('validation_error');
    }

    if (args != null && args.isNotEmpty) {
      return _replaceArguments(message, args);
    }

    return message;
  }

  String getAuthValidationMessage(String key) {
    String? message = _getNestedValue(_authValidation, key);
    return message ?? translate('error');
  }

  String getBarterValidationMessage(String key) {
    String? message = _getNestedValue(_barterValidation, key);
    return message ?? translate('error');
  }

  // Private helper methods
  String? _getNestedValue(Map<String, dynamic> map, String key) {
    final List<String> keys = key.split('.');
    dynamic current = map;

    for (String k in keys) {
      if (current is Map<String, dynamic> && current.containsKey(k)) {
        current = current[k];
      } else {
        return null;
      }
    }

    return current is String ? current : null;
  }

  String _replaceArguments(String template, List<String> args) {
    String result = template;
    for (int i = 0; i < args.length; i++) {
      result = result.replaceFirst('{}', args[i]);
    }
    return result;
  }
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['tr', 'en', 'ar'].contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    AppLocalizations localizations = AppLocalizations(locale);
    await localizations.load();
    return localizations;
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}
