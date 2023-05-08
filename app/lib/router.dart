import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'app/pages.dart';
import 'model/model.dart';

final GoRouter router = GoRouter(
  routes: <GoRoute>[
    GoRoute(
      path: '/',
      builder: (BuildContext context, GoRouterState state) {
        return const SplashPage();
      },
    ),
    GoRoute(
      path: '/login',
      builder: (BuildContext context, GoRouterState state) {
        return const LoginPage();
      },
    ),
    GoRoute(
      path: '/home',
      builder: (BuildContext context, GoRouterState state) {
        return const HomePage(
          debugTools: true,
        );
      },
    ),
    GoRoute(
      path: '/profile',
      builder: (BuildContext context, GoRouterState state) {
        return const ProfilePage();
      },
    ),
    GoRoute(
      path: '/new_order',
      builder: (BuildContext context, GoRouterState state) {
        final order = state.extra! as Order;
        return NewOrderPage(order: order);
      },
    ),
    GoRoute(
      path: '/new_order/map_view',
      builder: (BuildContext context, GoRouterState state) {
        final order = state.extra! as Order;
        return NewOrderMapViewPage(
          order: order,
        );
      },
    ),
    GoRoute(
      path: '/order',
      builder: (BuildContext context, GoRouterState state) {
        final order = state.extra! as Order;
        return OrderPage(order: order);
      },
    ),
  ],
);
