import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'features/home/home_page.dart';
import 'features/login/logic/auth_notifier.dart';
import 'features/login/widgets/login_page.dart';
import 'features/login/widgets/splash_page.dart';

part 'routes.g.dart';

@riverpod
// ignore: unsupported_provider_value
GoRouter router(RouterRef ref) {
  final courierState = ref.watch(authNotifierProvider).value;
  return GoRouter(
    routes: $appRoutes,
    debugLogDiagnostics: true,
    initialLocation: const SplashRoute().location,
    redirect: (context, state) {
      if (courierState == null) {
        return const SplashRoute().location;
      }
      if (courierState is AuthStateLoggedOut) {
        return const LoginRoute().location;
      }
      if (courierState is AuthStateLoggedIn) {
        return const HomeRoute().location;
      }
      return null;
    },
  );
}

@TypedGoRoute<SplashRoute>(
  path: '/splash',
)
class SplashRoute extends GoRouteData {
  const SplashRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const SplashPage();
  }
}

@TypedGoRoute<LoginRoute>(path: '/login')
class LoginRoute extends GoRouteData {
  const LoginRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const LoginPage();
  }
}

@TypedGoRoute<HomeRoute>(path: '/')
class HomeRoute extends GoRouteData {
  const HomeRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const HomePage();
  }
}
