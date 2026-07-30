import 'package:flutter/material.dart';

class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  Map<String, String> get _localizedStrings {
    if (locale.languageCode == 'ur') {
      return _urduStrings;
    }
    return _englishStrings;
  }

  // English Strings
  static const Map<String, String> _englishStrings = {
    'app_name': 'Pakistan Delivery',
    'welcome': 'Welcome',
    'login': 'Login',
    'register': 'Register',
    'logout': 'Logout',
    'phone_number': 'Phone Number',
    'password': 'Password',
    'email': 'Email',
    'name': 'Name',
    'search': 'Search',
    'search_stores': 'Search stores or products...',
    'home': 'Home',
    'orders': 'Orders',
    'cart': 'Cart',
    'profile': 'Profile',
    'stores': 'Stores',
    'products': 'Products',
    'add_to_cart': 'Add to Cart',
    'checkout': 'Checkout',
    'total': 'Total',
    'delivery_fee': 'Delivery Fee',
    'tax': 'Tax',
    'grand_total': 'Grand Total',
    'payment_method': 'Payment Method',
    'cash_on_delivery': 'Cash on Delivery',
    'card_payment': 'Card Payment',
    'jazzcash': 'JazzCash',
    'easypaisa': 'EasyPaisa',
    'place_order': 'Place Order',
    'order_placed': 'Order Placed Successfully!',
    'order_status': 'Order Status',
    'tracking': 'Tracking',
    'estimated_time': 'Estimated Time',
    'delivery_address': 'Delivery Address',
    'special_instructions': 'Special Instructions',
    'city': 'City',
    'area': 'Area',
    'street': 'Street',
    'house_number': 'House Number',
    'save': 'Save',
    'cancel': 'Cancel',
    'confirm': 'Confirm',
    'ok': 'OK',
    'error': 'Error',
    'success': 'Success',
    'loading': 'Loading...',
    'no_data': 'No data available',
    'retry': 'Retry',
    'karachi': 'Karachi',
    'lahore': 'Lahore',
    'islamabad': 'Islamabad',
    'rawalpindi': 'Rawalpindi',
    'faisalabad': 'Faisalabad',
    'multan': 'Multan',
    'peshawar': 'Peshawar',
    'quetta': 'Quetta',
    'grocery': 'Grocery',
    'food': 'Food',
    'restaurant': 'Restaurant',
    'pharmacy': 'Pharmacy',
    'bakery': 'Bakery',
    'my_orders': 'My Orders',
    'order_history': 'Order History',
    'settings': 'Settings',
    'language': 'Language',
    'change_language': 'Change Language',
    'english': 'English',
    'urdu': 'اردو',
    'dark_mode': 'Dark Mode',
    'notifications': 'Notifications',
    'help_support': 'Help & Support',
    'about': 'About',
    'version': 'Version',
    'made_in_pakistan': 'Made with ❤️ in Pakistan',
  };

  // Urdu Strings
  static const Map<String, String> _urduStrings = {
    'app_name': 'پاکستان ڈیلیوری',
    'welcome': 'خوش آمدید',
    'login': 'لاگ ان',
    'register': 'رجسٹریشن',
    'logout': 'لاگ آؤٹ',
    'phone_number': 'فون نمبر',
    'password': 'پاسورڈ',
    'email': 'ای میل',
    'name': 'نام',
    'search': 'تلاش',
    'search_stores': 'دکان یا پروڈکٹ تلاش کریں...',
    'home': 'ہوم',
    'orders': 'آرڈرز',
    'cart': 'کارٹ',
    'profile': 'پروفائل',
    'stores': 'دکانیں',
    'products': 'پروڈکٹس',
    'add_to_cart': 'کارٹ میں شامل کریں',
    'checkout': 'چیک آؤٹ',
    'total': 'کل',
    'delivery_fee': 'ڈیلیوری فیس',
    'tax': 'ٹیکس',
    'grand_total': 'کل رقم',
    'payment_method': 'ادائیگی کا طریقہ',
    'cash_on_delivery': 'کیش آن ڈیلیوری',
    'card_payment': 'کارڈ ادائیگی',
    'jazzcash': 'جیز کیش',
    'easypaisa': 'ایزی پیسہ',
    'place_order': 'آرڈر کریں',
    'order_placed': 'آرڈر کامیابی سے ہو گیا!',
    'order_status': 'آرڈر کی حیثیت',
    'tracking': 'ٹریکنگ',
    'estimated_time': 'متوقع وقت',
    'delivery_address': 'ڈیلیوری پتہ',
    'special_instructions': 'خاص ہدایات',
    'city': 'شہر',
    'area': 'علاقہ',
    'street': 'گلی',
    'house_number': 'گھر نمبر',
    'save': 'محفوظ کریں',
    'cancel': 'منسوخ',
    'confirm': 'تصدیق',
    'ok': 'ٹھیک ہے',
    'error': 'غلطی',
    'success': 'کامیابی',
    'loading': 'لوڈ ہو رہا ہے...',
    'no_data': 'کوئی ڈیٹا دستیاب نہیں',
    'retry': 'دوبارہ کوشش کریں',
    'karachi': 'کراچی',
    'lahore': 'لاہور',
    'islamabad': 'اسلام آباد',
    'rawalpindi': 'راولپنڈی',
    'faisalabad': 'فیصل آباد',
    'multan': 'ملتان',
    'peshawar': 'پشاور',
    'quetta': 'کوئٹہ',
    'grocery': 'گروسری',
    'food': 'کھانا',
    'restaurant': 'ریسٹورنٹ',
    'pharmacy': 'فارمیسی',
    'bakery': 'بیکری',
    'my_orders': 'میرے آرڈرز',
    'order_history': 'آرڈر کی تاریخ',
    'settings': 'ترتیبات',
    'language': 'زبان',
    'change_language': 'زبان تبدیل کریں',
    'english': 'انگریزی',
    'urdu': 'اردو',
    'dark_mode': 'ڈارک موڈ',
    'notifications': 'اطلاعات',
    'help_support': 'مدد اور سپورٹ',
    'about': 'بارے میں',
    'version': 'ورژن',
    'made_in_pakistan': 'پاکستان میں ❤️ کے ساتھ بنایا گیا',
  };

  String get appName => _localizedStrings['app_name']!;
  String get welcome => _localizedStrings['welcome']!;
  String get login => _localizedStrings['login']!;
  String get register => _localizedStrings['register']!;
  String get logout => _localizedStrings['logout']!;
  String get phoneNumber => _localizedStrings['phone_number']!;
  String get password => _localizedStrings['password']!;
  String get email => _localizedStrings['email']!;
  String get name => _localizedStrings['name']!;
  String get search => _localizedStrings['search']!;
  String get searchStores => _localizedStrings['search_stores']!;
  String get home => _localizedStrings['home']!;
  String get orders => _localizedStrings['orders']!;
  String get cart => _localizedStrings['cart']!;
  String get profile => _localizedStrings['profile']!;
  String get stores => _localizedStrings['stores']!;
  String get products => _localizedStrings['products']!;
  String get addToCart => _localizedStrings['add_to_cart']!;
  String get checkout => _localizedStrings['checkout']!;
  String get total => _localizedStrings['total']!;
  String get deliveryFee => _localizedStrings['delivery_fee']!;
  String get tax => _localizedStrings['tax']!;
  String get grandTotal => _localizedStrings['grand_total']!;
  String get paymentMethod => _localizedStrings['payment_method']!;
  String get cashOnDelivery => _localizedStrings['cash_on_delivery']!;
  String get cardPayment => _localizedStrings['card_payment']!;
  String get jazzcash => _localizedStrings['jazzcash']!;
  String get easypaisa => _localizedStrings['easypaisa']!;
  String get placeOrder => _localizedStrings['place_order']!;
  String get orderPlaced => _localizedStrings['order_placed']!;
  String get orderStatus => _localizedStrings['order_status']!;
  String get tracking => _localizedStrings['tracking']!;
  String get estimatedTime => _localizedStrings['estimated_time']!;
  String get deliveryAddress => _localizedStrings['delivery_address']!;
  String get specialInstructions => _localizedStrings['special_instructions']!;
  String get city => _localizedStrings['city']!;
  String get area => _localizedStrings['area']!;
  String get street => _localizedStrings['street']!;
  String get houseNumber => _localizedStrings['house_number']!;
  String get save => _localizedStrings['save']!;
  String get cancel => _localizedStrings['cancel']!;
  String get confirm => _localizedStrings['confirm']!;
  String get ok => _localizedStrings['ok']!;
  String get error => _localizedStrings['error']!;
  String get success => _localizedStrings['success']!;
  String get loading => _localizedStrings['loading']!;
  String get noData => _localizedStrings['no_data']!;
  String get retry => _localizedStrings['retry']!;
  String get karachi => _localizedStrings['karachi']!;
  String get lahore => _localizedStrings['lahore']!;
  String get islamabad => _localizedStrings['islamabad']!;
  String get rawalpindi => _localizedStrings['rawalpindi']!;
  String get faisalabad => _localizedStrings['faisalabad']!;
  String get multan => _localizedStrings['multan']!;
  String get peshawar => _localizedStrings['peshawar']!;
  String get quetta => _localizedStrings['quetta']!;
  String get grocery => _localizedStrings['grocery']!;
  String get food => _localizedStrings['food']!;
  String get restaurant => _localizedStrings['restaurant']!;
  String get pharmacy => _localizedStrings['pharmacy']!;
  String get bakery => _localizedStrings['bakery']!;
  String get myOrders => _localizedStrings['my_orders']!;
  String get orderHistory => _localizedStrings['order_history']!;
  String get settings => _localizedStrings['settings']!;
  String get language => _localizedStrings['language']!;
  String get changeLanguage => _localizedStrings['change_language']!;
  String get english => _localizedStrings['english']!;
  String get urdu => _localizedStrings['urdu']!;
  String get darkMode => _localizedStrings['dark_mode']!;
  String get notifications => _localizedStrings['notifications']!;
  String get helpSupport => _localizedStrings['help_support']!;
  String get about => _localizedStrings['about']!;
  String get version => _localizedStrings['version']!;
  String get madeInPakistan => _localizedStrings['made_in_pakistan']!;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['en', 'ur'].contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    return AppLocalizations(locale);
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}
