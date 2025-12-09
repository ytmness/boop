import 'package:flutter/cupertino.dart';
import 'route_names.dart';
import '../core/splash/splash_screen.dart';
import '../features/auth/screens/onboarding_screen.dart';
import '../features/auth/screens/phone_login_screen.dart';
import '../features/auth/screens/verify_otp_screen.dart';
import '../features/auth/screens/email_login_screen.dart';
import '../features/auth/screens/support_screen.dart';
import '../features/explore/screens/explore_screen.dart';
import '../features/profile/screens/profile_screen.dart';
import '../features/profile/screens/settings_screen.dart';
import '../features/explore/screens/search_screen.dart';
import '../features/explore/screens/activity_feed_screen.dart';
import '../features/events/screens/event_detail_screen.dart';
import '../features/communities/screens/communities_screen.dart';
import '../features/communities/screens/community_detail_screen.dart';
import '../features/friends/screens/friends_screen.dart';
import '../features/events/screens/create_event_screen.dart';
import '../features/events/screens/my_events_screen.dart';
import '../features/events/screens/manage_event_screen.dart';
import '../features/events/screens/manage/event_overview_screen.dart';
import '../features/events/screens/manage/edit_event_screen.dart';
import '../features/events/screens/manage/event_team_screen.dart';
import '../features/events/screens/manage/tickets_management_screen.dart';
import '../features/events/screens/manage/orders_list_screen.dart';

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;
    
    switch (settings.name) {
      case RouteNames.splash:
        return CupertinoPageRoute(
          builder: (_) => const SplashScreen(),
        );
      
      case RouteNames.onboarding:
        return CupertinoPageRoute(
          builder: (_) => const OnboardingScreen(),
        );
      
      case RouteNames.phoneLogin:
        return CupertinoPageRoute(
          builder: (_) => const PhoneLoginScreen(),
        );
      
      case RouteNames.verifyOTP:
        if (args is Map) {
          final phoneOrEmail = args['phoneOrEmail'] as String? ?? '';
          final isEmail = args['isEmail'] as bool? ?? false;
          return CupertinoPageRoute(
            builder: (_) => VerifyOTPScreen(
              phoneOrEmail: phoneOrEmail,
              isEmail: isEmail,
            ),
          );
        } else {
          final phoneOrEmail = args as String? ?? '';
          return CupertinoPageRoute(
            builder: (_) => VerifyOTPScreen(phoneOrEmail: phoneOrEmail),
          );
        }
      
      case RouteNames.emailLogin:
        return CupertinoPageRoute(
          builder: (_) => const EmailLoginScreen(),
        );
      
      case RouteNames.support:
        return CupertinoPageRoute(
          builder: (_) => const SupportScreen(),
        );
      
      case RouteNames.explore:
        return CupertinoPageRoute(
          builder: (_) => const ExploreScreen(),
        );
      
      case RouteNames.profile:
        return CupertinoPageRoute(
          builder: (_) => const ProfileScreen(),
        );
      
      case RouteNames.settings:
        return CupertinoPageRoute(
          builder: (_) => const SettingsScreen(),
        );
      
      case RouteNames.search:
        return CupertinoPageRoute(
          builder: (_) => const SearchScreen(),
        );
      
      case RouteNames.activity:
        return CupertinoPageRoute(
          builder: (_) => const ActivityFeedScreen(),
        );
      
      default:
        // Manejar rutas dinámicas como /event/:id
        if (settings.name != null && settings.name!.startsWith('/event/')) {
          final eventId = settings.name!.split('/event/')[1].split('/')[0];
          return CupertinoPageRoute(
            builder: (_) => EventDetailScreen(eventId: eventId),
          );
        }
        
        if (settings.name != null && settings.name!.startsWith('/community/')) {
          final communityId = settings.name!.split('/community/')[1].split('/')[0];
          return CupertinoPageRoute(
            builder: (_) => CommunityDetailScreen(communityId: communityId),
          );
        }
        
        // Rutas estáticas adicionales
        if (settings.name == RouteNames.communities) {
          return CupertinoPageRoute(
            builder: (_) => const CommunitiesScreen(),
          );
        }
        
        if (settings.name == RouteNames.friends) {
          return CupertinoPageRoute(
            builder: (_) => const FriendsScreen(),
          );
        }
        
        if (settings.name == RouteNames.createEvent) {
          return CupertinoPageRoute(
            builder: (_) => const CreateEventScreen(),
          );
        }
        
        if (settings.name == RouteNames.myEvents) {
          return CupertinoPageRoute(
            builder: (_) => const MyEventsScreen(),
          );
        }
        
        // Rutas de administración de eventos
        if (settings.name != null && settings.name!.contains('/manage')) {
          final parts = settings.name!.split('/');
          final eventId = parts[2]; // /event/:id/manage/...
          
          if (settings.name!.endsWith('/overview')) {
            return CupertinoPageRoute(
              builder: (_) => EventOverviewScreen(eventId: eventId),
            );
          }
          
          if (settings.name!.endsWith('/edit')) {
            return CupertinoPageRoute(
              builder: (_) => EditEventScreen(eventId: eventId),
            );
          }
          
          if (settings.name!.endsWith('/team')) {
            return CupertinoPageRoute(
              builder: (_) => EventTeamScreen(eventId: eventId),
            );
          }
          
          if (settings.name!.endsWith('/tickets')) {
            return CupertinoPageRoute(
              builder: (_) => TicketsManagementScreen(eventId: eventId),
            );
          }
          
          if (settings.name!.endsWith('/orders')) {
            return CupertinoPageRoute(
              builder: (_) => OrdersListScreen(eventId: eventId),
            );
          }
          
          // Ruta por defecto de manage
          return CupertinoPageRoute(
            builder: (_) => ManageEventScreen(eventId: eventId),
          );
        }
        
        if (settings.name != null && settings.name!.startsWith('/event/') && settings.name!.contains('/tickets')) {
          final eventId = settings.name!.split('/event/')[1].split('/tickets')[0];
          // TODO: Navegar a pantalla de compra de tickets
          return CupertinoPageRoute(
            builder: (_) => EventDetailScreen(eventId: eventId),
          );
        }
        
        return CupertinoPageRoute(
          builder: (_) => CupertinoPageScaffold(
            navigationBar: const CupertinoNavigationBar(
              middle: Text('Página no encontrada'),
            ),
            child: Center(
              child: Text('Ruta no encontrada: ${settings.name}'),
            ),
          ),
        );
    }
  }
}

