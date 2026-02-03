import 'package:apollo_tracker_mobile/commons/utils/security.util.dart';
import 'package:apollo_tracker_mobile/pages/asset-tracker/asset_tracker.dart';
import 'package:apollo_tracker_mobile/pages/attendance/attendance.page.dart';
import 'package:apollo_tracker_mobile/pages/dashboard/dashboard.dart';
import 'package:apollo_tracker_mobile/pages/fsr/create_fsr.page.dart';
import 'package:apollo_tracker_mobile/pages/fsr/fsr.page.dart';
import 'package:apollo_tracker_mobile/pages/initialize.dart';
import 'package:apollo_tracker_mobile/pages/locations/locations.page.dart';
import 'package:apollo_tracker_mobile/pages/profile/profile.dart';
import 'package:apollo_tracker_mobile/pages/public/login.dart';
import 'package:apollo_tracker_mobile/pages/tickets/search.page.dart';
import 'package:apollo_tracker_mobile/pages/tickets/ticket-fsr.dart';
import 'package:apollo_tracker_mobile/pages/tickets/comment.dart';
import 'package:apollo_tracker_mobile/pages/tickets/ticket.dart';
import 'package:apollo_tracker_mobile/pages/tickets/ticket_response.dart';
import 'package:apollo_tracker_mobile/widgets/_layouts/bottom_navigation.dart';
import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';

final _rootNavigationKey = GlobalKey<NavigatorState>(debugLabel: 'root');

final GoRouter appRouter = GoRouter(
  initialLocation: '/asset-tracker',
  navigatorKey: _rootNavigationKey,
  redirect: (context, state) {
    // Always redirect unless we're already there
    if (state.matchedLocation != '/asset-tracker') {
      return '/asset-tracker';
    }
    return null;
  },
  routes: [
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) => BottomNavigation(
        child: navigationShell
      ),
      branches: [
        StatefulShellBranch(routes: [
          GoRoute(
            path: '/tickets',
            redirect: isAuthenticated,
            builder: (context, state) => DashboardPage()
          )
        ]),
        StatefulShellBranch(routes: [
          GoRoute(
              path: '/asset-tracker',
              redirect: isAuthenticated,
              builder: (context, state) => const AssetTrackingPage())
        ]),
        StatefulShellBranch(routes: [
          GoRoute(
            path: '/profile',
            builder: (context, state) => ProfilePage()
          )
        ]),
      ],
    ),
    // GoRoute(
    //   path: '/login',
    //   redirect: alreadyLogin,
    //   builder: (context, state) => LoginPage(),
    // ),
    GoRoute(
      path: '/initialize',
      redirect: alreadyLogin,
      builder: (context, state) => InitializePage(),
    ),
    
    // Ticket router
    GoRoute(
      parentNavigatorKey: _rootNavigationKey,
      path: '/ticket/:id',
      builder: (context, state) => TicketPage(id: state.pathParameters['id']),
    ),
    // Dashboard router
    GoRoute(
      parentNavigatorKey: _rootNavigationKey,
      path: '/ticket-fsr/:id',
      builder: (context, state) => TicketFSRPage(id: state.pathParameters['id']),
    ),
    GoRoute(
      parentNavigatorKey: _rootNavigationKey,
      path: '/ticket-response/:id',
      builder: (context, state) => TicketResponsePage(id: state.pathParameters['id']),
    ),
    // Ticket router
    GoRoute(
      parentNavigatorKey: _rootNavigationKey,
      path: '/ticket/:id/comment',
      builder: (context, state) => TicketCommentPage(id: state.pathParameters['id']),
    ),
    // Attendance
    GoRoute(
      parentNavigatorKey: _rootNavigationKey,
      path: '/attendance',
      builder: (context, state) => AttendancePage(),
    ),
    // Attendance
    GoRoute(
      parentNavigatorKey: _rootNavigationKey,
      path: '/view-locations',
      builder: (context, state) => LocationsPage(),
    ),
    GoRoute(
      parentNavigatorKey: _rootNavigationKey,
      path: '/fsr',
      builder: (context, state) => FieldServiceReportPage(),
    ),
    GoRoute(
      parentNavigatorKey: _rootNavigationKey,
      path: '/create-fsr',
      builder: (context, state) {
        final id = state.uri.queryParameters['id']; 
        return CreateFieldServiceReportPage(id: id);
      },
    ),
    GoRoute(
      parentNavigatorKey: _rootNavigationKey,
      path: '/tickets-search',
      builder: (context, state) => TicketsSearchPage(),
    ),
  ],
);