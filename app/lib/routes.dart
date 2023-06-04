import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:superfleet_courier/features/orders/widgets/cancel_order_view.dart';
import 'package:superfleet_courier/features/orders/widgets/new_orders/new_order_popup_screen.dart';
import 'package:superfleet_courier/features/orders/widgets/new_orders/new_order_screen.dart';
import 'package:superfleet_courier/features/orders/widgets/order_view.dart';
import 'package:superfleet_courier/features/home/success_page.dart';
import 'features/home/home_page.dart';
import 'features/login/logic/auth_notifier.dart';
import 'features/login/widgets/login_page.dart';
import 'features/login/widgets/splash_page.dart';

part 'routes.g.dart';

@riverpod
// ignore: unsupported_provider_value
GoRouter router(RouterRef ref) {
  final authState = ref.watch(authNotifierProvider).value;
  return GoRouter(
    routes: $appRoutes,
    debugLogDiagnostics: true,
    initialLocation: const SplashRoute().location,
    redirect: (context, state) {
      if (authState == null) {
        return const SplashRoute().location;
      }
      final bool loggedIn = authState is AuthStateLoggedIn;

      // check just the matchedLocation in case there are query parameters
      final String splashLoc = const SplashRoute().location;
      final bool onSplashPage = state.matchedLocation == splashLoc;

      // the user is not logged in and not headed to /login, they need to login
      if (!loggedIn) {
        return const LoginRoute().location;
      }

      // the user is logged in and headed to /login, no need to login again
      if (loggedIn && onSplashPage) {
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

@TypedGoRoute<HomeRoute>(path: '/', routes: [
  TypedGoRoute<OrderViewRoute>(path: 'view_order/:id', routes: [
      TypedGoRoute<CancelOrderViewRoute>(path: 'cancel'),
    ],
  ),
  TypedGoRoute<NewOrderPopupRoute>(path: 'new_orders_popup'),
  TypedGoRoute<NewOrderRoute>(path: 'new_order/:id')
])
class HomeRoute extends GoRouteData {
  const HomeRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const HomePage();
  }
}

class OrderViewRoute extends GoRouteData {
  const OrderViewRoute(this.id);
  final int id;

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return OrderView(
      orderId: id,
    );
  }
}

class CancelOrderViewRoute extends GoRouteData {
  const CancelOrderViewRoute(this.id);
  final int id;

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return CancelOrderView(orderId: id);
  }
}

@TypedGoRoute<SuccessPageRoute>(path: '/success')
class SuccessPageRoute extends GoRouteData {
  const SuccessPageRoute({required this.$extra, this.$popOnDone});
  final String $extra;
  final bool? $popOnDone;

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return SuccessPage(
      text: $extra,
      popOnDone: $popOnDone,
    );
  }
}


//New Orders
class NewOrderPopupRoute extends GoRouteData {
  const NewOrderPopupRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const NewOrderPopupScreen();
  }
}

class NewOrderRoute extends GoRouteData {
  const NewOrderRoute(this.id);
  final int id;

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return NewOrderScreen(
      orderId: id,
    );
  }
}
