import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:milestory_crm/features/auth/presentation/auth_bloc/auth_bloc.dart';
import 'package:milestory_crm/features/auth/presentation/screen/auth_page.dart';
import 'package:milestory_crm/features/home.dart/home.dart';

import '../core_export.dart';
import '../utils/widgets/nav_bar.dart';

class AppRouter {
  final BuildContext context;
  AppRouter({required this.context});
  final _rootNavigatorKey = GlobalKey<NavigatorState>();
  final _shellNavigatorKey = GlobalKey<NavigatorState>();
  late AuthStatus previousStatus = AuthStatus.unknown;

  final tabs = const [
    NavBarItem(initialLocation: '/home', icon: Icon(Icons.arrow_back), label: ""),
    NavBarItem(initialLocation: '/home', icon: Icon(Icons.home), label: "Home"),
    NavBarItem(initialLocation: '/dashboard', icon: Icon(Icons.dashboard), label: "Dashboard"),
    NavBarItem(initialLocation: '', icon: Icon(Icons.exit_to_app), label: "Logout"),
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
                return NavBar(
                  tabs: tabs,
                  child: child,
                );
              },
              routes: [
                GoRoute(
                  name: RouteConstants.home,
                  path: '/home',
                  pageBuilder: (context, state) => NoTransitionPage(child: const HomePage(), key: state.pageKey),
                ),
              ],
            ),
          ]);

  GoRouter get router => _router();
}
