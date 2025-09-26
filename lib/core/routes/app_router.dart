import 'package:flutter/material.dart';
import '../../presentation/pages/splash/splash_page.dart';
import '../../presentation/pages/auth/login_page.dart';
import '../../presentation/pages/auth/register_page.dart';
import '../../presentation/pages/home/home_page.dart';
import '../../presentation/pages/listing/listing_list_page.dart';
import '../../presentation/pages/listing/listing_detail_page.dart';
import '../../presentation/pages/listing/create_listing/create_listing_page.dart';
import '../../presentation/pages/notification/notification_list_page.dart';
import '../../presentation/pages/notification/notification_settings_page.dart';
import '../../presentation/pages/chat/chat_list_page.dart';
import '../../presentation/pages/chat/chat_room_page.dart';
import '../../presentation/pages/map/map_page.dart';
import '../../presentation/pages/help/help_page.dart';
import '../../presentation/pages/help/help_search_page.dart';
import '../../presentation/pages/help/help_category_page.dart';
import '../../presentation/pages/help/help_faq_page.dart';
import '../../presentation/pages/help/help_article_detail_page.dart';
import '../../presentation/pages/help/help_bookmarks_page.dart';

class AppRouter {
  static const String splash = '/';
  static const String login = '/login';
  static const String register = '/register';
  static const String home = '/home';
  static const String listings = '/listings';
  static const String listingDetail = '/listing-detail';
  static const String createListing = '/create-listing';
  static const String notifications = '/notifications';
  static const String notificationSettings = '/notification-settings';
  static const String chats = '/chats';
      static const String chatRoom = '/chat-room';
      static const String map = '/map';
      static const String help = '/help';
      static const String helpSearch = '/help/search';
      static const String helpCategory = '/help/category';
      static const String helpFAQ = '/help/faq';
      static const String helpArticle = '/help/article';
      static const String helpBookmarks = '/help/bookmarks';

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splash:
        return MaterialPageRoute(builder: (_) => const SplashPage());
      case login:
        return MaterialPageRoute(builder: (_) => const LoginPage());
      case register:
        return MaterialPageRoute(builder: (_) => const RegisterPage());
      case home:
        return MaterialPageRoute(builder: (_) => const HomePage());
      case listings:
        return MaterialPageRoute(builder: (_) => const ListingListPage());
      case listingDetail:
        final args = settings.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(
          builder: (_) => ListingDetailPage(listingId: args?['id']),
        );
      case createListing:
        return MaterialPageRoute(builder: (_) => const CreateListingPage());
      case notifications:
        return MaterialPageRoute(builder: (_) => const NotificationListPage());
      case notificationSettings:
        return MaterialPageRoute(builder: (_) => const NotificationSettingsPage());
      case chats:
        return MaterialPageRoute(builder: (_) => const ChatListPage());
          case chatRoom:
            final args = settings.arguments as Map<String, dynamic>?;
            return MaterialPageRoute(
              builder: (_) => ChatRoomPage(
                chatId: args?['chatId'] ?? '',
                chat: args?['chat'],
              ),
            );
          case map:
            final args = settings.arguments as Map<String, dynamic>?;
            return MaterialPageRoute(
              builder: (_) => MapPage(
                initialPosition: args?['position'],
                markers: args?['markers'] ?? {},
                showSearchBar: args?['showSearchBar'] ?? true,
              ),
            );
          case help:
            return MaterialPageRoute(builder: (_) => const HelpPage());
          case helpSearch:
            return MaterialPageRoute(builder: (_) => const HelpSearchPage());
          case helpCategory:
            final args = settings.arguments as Map<String, dynamic>?;
            return MaterialPageRoute(
              builder: (_) => HelpCategoryPage(categoryId: args?['categoryId'] ?? ''),
            );
          case helpFAQ:
            return MaterialPageRoute(builder: (_) => const HelpFAQPage());
          case helpArticle:
            final args = settings.arguments as Map<String, dynamic>?;
            return MaterialPageRoute(
              builder: (_) => HelpArticleDetailPage(articleId: args?['articleId'] ?? ''),
            );
          case helpBookmarks:
            return MaterialPageRoute(builder: (_) => const HelpBookmarksPage());
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          ),
        );
    }
  }
}
