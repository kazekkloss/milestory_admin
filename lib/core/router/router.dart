import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:milestory_admin/features/auth/presentation/screen/auth_screen.dart';
import 'package:milestory_admin/features/home/presentation/screen/home.dart';
import 'package:milestory_admin/features/tour/tour_export.dart';

import '../../features/auth/auth_export.dart';
import '../../features/auth/presentation/screen/splash_screen.dart';
import '../../features/creator/presentation/screen/creator_page.dart';
import '../../features/user_management/presentation/screen/users_screen.dart';
import '../core_export.dart';
import '../utils/widgets/nav_bar.dart';

class AppRouter {
  final BuildContext context;
  AppRouter({required this.context});
  final _rootNavigatorKey = GlobalKey<NavigatorState>();
  final _shellNavigatorKey = GlobalKey<NavigatorState>();

  final tabs = const [
    NavBarItem(
      initialLocation: '/home',
      icon: FaIcon(FontAwesomeIcons.house),
      label: "",
    ),
    NavBarItem(
      initialLocation: '/dashboard',
      icon: FaIcon(FontAwesomeIcons.gauge),
      label: "",
    ),
    NavBarItem(
      initialLocation: '/users',
      icon: FaIcon(FontAwesomeIcons.users),
      label: "",
    ),
    NavBarItem(
      initialLocation: '',
      icon: FaIcon(FontAwesomeIcons.rightFromBracket),
      label: "",
    ),
  ];

  GoRouter _router() => GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/splash',
    redirect: (context, state) {
      final authState = context.read<AuthBloc>().state;
      final loc = state.matchedLocation;

      final isSplash = loc == '/splash';
      final isWelcome = loc == '/auth';

      switch (authState.status) {
        case AuthStatus.unknown:
          return isSplash ? null : '/splash';

        case AuthStatus.unauthenticated:
          return isWelcome ? null : '/auth';

        case AuthStatus.authenticated:
          if (isSplash || isWelcome) return '/home';
          return null;
      }
    },
    refreshListenable: RouterRefreshBloc<AuthBloc, AuthState>(
      BlocProvider.of<AuthBloc>(context, listen: false),
    ),
    routes: [
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        name: RouteConstants.splash,
        path: '/splash',
        builder: (context, state) => const SplashPage(),
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        name: RouteConstants.auth,
        path: '/auth',
        builder: (context, state) => const AuthScreen(),
      ),
      ShellRoute(
        navigatorKey: _shellNavigatorKey,
        builder: (context, state, child) {
          return NavBar(tabs: tabs, child: child);
        },
        routes: [
          GoRoute(
            name: RouteConstants.home,
            path: '/home',
            pageBuilder:
                (context, state) => NoTransitionPage(
                  child: const HomeScreen(),
                  key: state.pageKey,
                ),
          ),
          GoRoute(
            name: RouteConstants.dashboard,
            path: '/dashboard',
            pageBuilder: (context, state) {
              final statusStr = state.uri.queryParameters['status'];
              final initialStatus =
                  statusStr != null && statusStr.isNotEmpty
                      ? TourStatusData.fromApiString(statusStr)
                      : null;
              final userArgs = state.extra is UserToursArgs
                  ? state.extra as UserToursArgs
                  : null;
              return NoTransitionPage(
                child: TourPage(initialStatus: initialStatus, userArgs: userArgs),
                key: state.pageKey,
              );
            },
            routes: [
              GoRoute(
                name: RouteConstants.creator,
                path: 'creator',
                pageBuilder: ((context, state) {
                  Tour tour = state.extra as Tour;
                  debugPrint("Tour ID in Router: ${tour.id}");
                  return NoTransitionPage(child: CreatorPage(tour: tour));
                }),
              ),
            ],
          ),
          GoRoute(
            name: RouteConstants.users,
            path: '/users',
            pageBuilder: (context, state) => NoTransitionPage(
              child: const UsersScreen(),
              key: state.pageKey,
            ),
          ),
        ],
      ),
    ],
  );

  GoRouter get router => _router();
}
