import 'package:animations/animations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:superfleet_courier/app/bloc/user_bloc.dart';
import 'package:superfleet_courier/app/profile_page.dart';
import 'package:superfleet_courier/repository/superfleet_repository.dart';
import 'package:superfleet_courier/widgets/buttons/sf_button.dart';
import 'package:superfleet_courier/widgets/colors.dart';
import 'package:superfleet_courier/widgets/order_tile.dart';

import 'bloc/order_bloc.dart';

class HomePage extends HookWidget {
  const HomePage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final tabController = useTabController(initialLength: 2);
    return BlocProvider(
      create: ((context) {
        final courier =
            (context.read<UserBloc>().state as UserStateLoggedIn).courier;
        return OrderBloc(
            repository: context.read<SuperfleetRepository>(), courier: courier);
      }),
      child: SafeArea(
        child: Scaffold(
          body: Column(
            children: [
              _TopPanel(),
              _TabBar(
                controller: tabController,
              ),
              Expanded(
                child: TabBarView(controller: tabController, children: [
                  _OrderList(),
                  Container(
                    color: Colors.green,
                  )
                ]),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class _TopPanel extends StatelessWidget {
  const _TopPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserBloc, UserState>(
      builder: (context, state) {
        if (state is UserStateLoggedIn) {
          return OpenContainer(
            tappable: true,
            transitionDuration: const Duration(milliseconds: 500),
            openBuilder: (context, action) => ProfilePage(),
            closedBuilder: (context, action) => Container(
              color: Colors.white,
              height: 48.h,
              child: Row(
                children: [
                  SizedBox(width: 12.w),
                  Container(
                      width: 36.w,
                      height: 36.h,
                      padding: EdgeInsets.only(top: 6.h, bottom: 6.h),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.grey),
                      ),
                      alignment: Alignment.center,
                      child: Icon(
                        Icons.pedal_bike,
                        size: 24.w,
                        color: superfleetBlue,
                      )),
                  SizedBox(width: 8.w),
                  Padding(
                    padding: EdgeInsets.only(top: 8.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${state.courier.firstName} ${state.courier.lastName}',
                          style: TextStyle(
                              fontSize: 14.sp, fontWeight: FontWeight.w400),
                        ),
                        Text(
                          '${state.courier.transport}',
                          style: TextStyle(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w400,
                              color: const Color(0xff888888)),
                        )
                      ],
                    ),
                  ),
                  const Expanded(child: SizedBox()),
                  Container(
                    height: double.infinity,
                    alignment: Alignment.center,
                    child: Text(
                      'Online',
                      style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w400,
                          color: const Color(0xff888888)),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  CupertinoSwitch(
                    value: state.courier.status == "ACTIVE",
                    activeColor: const Color(0xff4F9E52),
                    onChanged: (value) {
                      context
                          .read<UserBloc>()
                          .add(UserEvent.changeStatus(value));
                    },
                  ),
                  SizedBox(width: 12.w)
                ],
              ),
            ),
          );
        }
        throw Exception('At home page without logged in user');
      },
    );
  }
}

class _TabBar extends StatelessWidget {
  const _TabBar({super.key, this.controller});
  final TabController? controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: TabBar(
        controller: controller,
        labelColor: superfleetBlue,
        unselectedLabelColor: const Color(0xff888888),
        indicatorColor: superfleetBlue,
        labelStyle: TextStyle(fontSize: 14.sp),
        tabs: const [
          Tab(
            text: 'Order List',
          ),
          Tab(
            text: 'History',
          )
        ],
      ),
    );
  }
}

class _OrderList extends StatelessWidget {
  const _OrderList({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OrderBloc, OrderState>(
      builder: (context, state) {
        return state.map(
          loaded: (value) {
            late final Widget finalWidget;
            if (context.select((UserBloc value) =>
                (value.state as UserStateLoggedIn).courier.status ==
                'INACTIVE')) {
              finalWidget = const _InactiveOrders(
                key: ValueKey(0),
              );
            } else {
              finalWidget = ListView.separated(
                key: const ValueKey(1),
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
                separatorBuilder: (context, index) => SizedBox(
                  height: 12.h,
                ),
                itemBuilder: (context, index) {
                  return OrderTile(
                    order: value.orders[index],
                    width: 296.w,
                    height: 178.h,
                  );
                },
                itemCount: value.orders.length,
              );
            }

            return PageTransitionSwitcher(
              transitionBuilder:
                  (child, primaryAnimation, secondaryAnimation) =>
                      SharedAxisTransition(
                animation: primaryAnimation,
                secondaryAnimation: secondaryAnimation,
                transitionType: SharedAxisTransitionType.scaled,
                child: child,
              ),
              duration: const Duration(milliseconds: 400),
              child: finalWidget,
            );
          },
          loading: (value) => const Center(child: CircularProgressIndicator()),
        );
      },
    );
  }
}

class _InactiveOrders extends StatelessWidget {
  const _InactiveOrders({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
            padding: const EdgeInsets.only(top: 80, left: 116, right: 116),
            child: Image.asset('assets/offline.png')),
        const SizedBox(height: 24),
        const Text(
          'You are currently offline',
          style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Color(0xff888888)),
        ),
        const SizedBox(height: 4),
        const Text(
          'Come online to start delivering',
          style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: Color(0xff888888)),
        ),
        const SizedBox(height: 32),
        SFButton(
            text: 'Go Online',
            onPressed: () => context
                .read<UserBloc>()
                .add(const UserEvent.changeStatus(true))),
        const Expanded(child: SizedBox())
      ],
    );
  }
}
