class RouteNames {
  // Splash
  static const String splash = '/splash';

  // Auth Routes
  static const String onboarding = '/auth/start';
  static const String phoneLogin = '/auth/phone';
  static const String verifyOTP = '/auth/verify';
  static const String emailLogin = '/auth/email';
  static const String support = '/support';

  // App Routes
  static const String explore = '/app/explore';
  static const String eventsHub = '/app/events';
  static const String search = '/app/search';
  static const String activity = '/app/activity';
  static const String profile = '/app/profile';
  static const String settings = '/app/settings';
  static const String friends = '/app/friends';
  static const String communities = '/app/communities';

  // Event Routes
  static const String createEvent = '/app/events/new';
  static const String myEvents = '/app/events/my';
  static const String eventDetail = '/event/:id';
  static const String ticketPurchase = '/event/:id/tickets';

  // Event Management Routes
  static const String manageEvent = '/event/:id/manage';
  static const String eventOverview = '/event/:id/manage/overview';
  static const String editEvent = '/event/:id/manage/edit';
  static const String eventTeam = '/event/:id/manage/team';
  static const String ticketsManagement = '/event/:id/manage/tickets';
  static const String ordersList = '/event/:id/manage/orders';
  static const String promoCodes = '/event/:id/manage/promo-codes';
  static const String ticketScanner = '/event/:id/manage/scan';
  static const String advancedStats = '/event/:id/manage/stats';

  // Community Routes
  static const String communityDetail = '/community/:id';
  static const String manageCommunity = '/community/:id/admin';

  // User Routes
  static const String userProfile = '/user/:id';

  // Ticket Routes
  static const String myTickets = '/app/tickets/my';
  static const String ticketDetail = '/ticket/:id';

  // Helper methods
  static String eventDetailPath(String id) => '/event/$id';
  static String ticketPurchasePath(String id) => '/event/$id/tickets';
  static String manageEventPath(String id) => '/event/$id/manage';
  static String eventOverviewPath(String id) => '/event/$id/manage/overview';
  static String editEventPath(String id) => '/event/$id/manage/edit';
  static String eventTeamPath(String id) => '/event/$id/manage/team';
  static String ticketsManagementPath(String id) => '/event/$id/manage/tickets';
  static String ordersListPath(String id) => '/event/$id/manage/orders';
  static String promoCodesPath(String id) => '/event/$id/manage/promo-codes';
  static String ticketScannerPath(String id) => '/event/$id/manage/scan';
  static String advancedStatsPath(String id) => '/event/$id/manage/stats';
  static String communityDetailPath(String id) => '/community/$id';
  static String manageCommunityPath(String id) => '/community/$id/admin';
  static String userProfilePath(String id) => '/user/$id';
  static String ticketDetailPath(String id) => '/ticket/$id';
}
