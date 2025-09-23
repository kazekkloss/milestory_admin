import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:milestory_crm/features/auth/presentation/auth_bloc/auth_bloc.dart';
import 'package:milestory_crm/features/auth/presentation/screen/auth_page.dart';
import 'package:milestory_crm/features/home/home.dart';
import 'package:milestory_crm/features/user_management/presentation/screen/user_page.dart';
import 'package:milestory_crm/features/tour_management/tour_managenent_export.dart';

import '../../features/creator/creator_export.dart';
import '../../features/guide_application_management/guide_application_export.dart';
import '../core_export.dart';
import '../utils/widgets/nav_bar.dart';

class AppRouter {
  final BuildContext context;
  AppRouter({required this.context});
  final _rootNavigatorKey = GlobalKey<NavigatorState>();
  final _shellNavigatorKey = GlobalKey<NavigatorState>();
  late AuthStatus previousStatus = AuthStatus.unknown;

  final tabs = const [
    NavBarItem(initialLocation: '/home', icon: Icon(FontAwesomeIcons.house), label: ""),
    NavBarItem(initialLocation: '/user_management', icon: Icon(FontAwesomeIcons.user), label: ""),
    NavBarItem(initialLocation: '/guide_application_management', icon: Icon(FontAwesomeIcons.message), label: ""),
    NavBarItem(initialLocation: '/tour_management', icon: Icon(FontAwesomeIcons.map), label: ""),
    NavBarItem(initialLocation: '', icon: Icon(FontAwesomeIcons.rightFromBracket), label: ""),
  ];

  GoRouter _router() => GoRouter(
    navigatorKey: _rootNavigatorKey,
    redirect: (context, state) {
      var authState = context.read<AuthBloc>().state;
      switch (authState.status) {
        case AuthStatus.unknown:
          return state.namedLocation(RouteConstants.auth);
        case AuthStatus.unauthenticated:
          if (previousStatus != authState.status) {
            previousStatus = authState.status;
            return state.namedLocation(RouteConstants.auth);
          }
        case AuthStatus.authenticated:
          if (previousStatus != authState.status) {
            previousStatus = authState.status;
            return state.namedLocation(RouteConstants.home);
          }
      }
      return null;
    },
    refreshListenable: RouterRefreshBloc<AuthBloc, AuthState>(BlocProvider.of<AuthBloc>(context, listen: false)),
    routes: [
      GoRoute(parentNavigatorKey: _rootNavigatorKey, name: RouteConstants.auth, path: '/auth', builder: (context, state) => const AuthPage()),
      ShellRoute(
        navigatorKey: _shellNavigatorKey,
        builder: (context, state, child) {
          return NavBar(tabs: tabs, child: child);
        },
        routes: [
          GoRoute(
            name: RouteConstants.home,
            path: '/home',
            pageBuilder: (context, state) => NoTransitionPage(child: const HomePage(), key: state.pageKey),
          ),
          GoRoute(
            name: RouteConstants.userManagement,
            path: '/user_management',
            pageBuilder: (context, state) => NoTransitionPage(child: const UserManagementPage(), key: state.pageKey),
          ),
          GoRoute(
            name: RouteConstants.guideApplication,
            path: '/guide_application_management',
            pageBuilder: (context, state) => NoTransitionPage(child: const GuideApplicationManagementPage(), key: state.pageKey),
          ),
          GoRoute(
            name: RouteConstants.tourManagement,
            path: '/tour_management',
            pageBuilder: (context, state) => NoTransitionPage(child: const TourPage(), key: state.pageKey),
            routes: [
              GoRoute(
                name: RouteConstants.creator,
                path: 'creator',
                pageBuilder: ((context, state) {
                  Tour tour = state.extra as Tour;
                  print("Tour ID in Router: ${tour.id}");
                  return NoTransitionPage(child: CreatorPage(tour: tour));
                }),
              ),
            ],
          ),
        ],
      ),
    ],
  );

  GoRouter get router => _router();
}
