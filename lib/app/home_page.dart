import 'package:animations/animations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:superfleet_courier/app/bloc/user_bloc.dart';
import 'package:superfleet_courier/app/profile_page.dart';
import 'package:superfleet_courier/model/model.dart';
import 'package:superfleet_courier/repository/superfleet_repository.dart';
import 'package:superfleet_courier/theme/sf_theme.dart';
import 'package:superfleet_courier/widgets/buttons/sf_button.dart';
import 'package:superfleet_courier/theme/colors.dart';
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
                child: TabBarView(
                    controller: tabController,
                    children: const [_OrderTab(), _HistoryTab()]),
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
    return OpenContainer(
      transitionType: ContainerTransitionType.fadeThrough,
      openBuilder: (context, action) => ProfilePage(),
      closedBuilder: (context, action) => BlocBuilder<UserBloc, UserState>(
        builder: (context, state) {
          if (state is UserStateLoggedIn) {
            return Container(
              color: Colors.white,
              height: 48.r,
              child: Row(
                children: [
                  SizedBox(width: 12.r),
                  Container(
                      width: 36.r,
                      height: 36.r,
                      padding: EdgeInsets.only(top: 6.r, bottom: 6.r),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                            color: const Color(0xffDFDFDF), width: 2.r),
                      ),
                      alignment: Alignment.center,
                      child: Icon(
                        Icons.pedal_bike,
                        size: 24.r,
                        color: superfleetBlue,
                      )),
                  SizedBox(width: 8.r),
                  Padding(
                    padding: EdgeInsets.only(top: 8.r),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${state.courier.firstName} ${state.courier.lastName}',
                          style: context.text14,
                        ),
                        Text(
                          '${state.courier.transport}',
                          style: context.text12grey,
                        )
                      ],
                    ),
                  ),
                  const Expanded(child: SizedBox()),
                  GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: (() => context
                        .read<UserBloc>()
                        .add(const UserEvent.changeStatus())),
                    child: Row(children: [
                      Container(
                        height: double.infinity,
                        alignment: Alignment.center,
                        child: Text(
                          'Online',
                          style: context.text12grey,
                        ),
                      ),
                      SizedBox(width: 12.r),
                      SizedBox(
                        height: 20.r,
                        width: 40.r,
                        child: CupertinoSwitch(
                          value: state.courier.status == "ACTIVE",
                          activeColor: const Color(0xff4F9E52),
                          onChanged: (value) {
                            context
                                .read<UserBloc>()
                                .add(UserEvent.changeStatus(value));
                          },
                        ),
                      ),
                      SizedBox(width: 12.r)
                    ]),
                  )
                ],
              ),
            );
          }
          throw Exception('At home page without logged in user');
        },
      ),
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

class _OrderTab extends StatelessWidget {
  const _OrderTab({super.key});

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
              finalWidget = value.orders.isNotEmpty
                  ? _OrderList(orders: value.orders)
                  : const _NoContent(
                      description: 'You don’t have any orders, yet',
                      explanation:
                          'Orders will appear here once you accept them',
                      icon: Icons.remove_shopping_cart,
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

class _OrderList extends StatelessWidget {
  const _OrderList({super.key, required this.orders});
  final List<Order> orders;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      key: const ValueKey(1),
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
      separatorBuilder: (context, index) => SizedBox(
        height: 12.h,
      ),
      itemBuilder: (context, index) {
        return OrderTile(
          order: orders[index],
          width: 296.w,
        );
      },
      itemCount: orders.length,
    );
  }
}

class _HistoryTab extends StatelessWidget {
  const _HistoryTab({super.key});

  @override
  Widget build(BuildContext context) {
    return const _NoContent(
      description: 'You don’t have any order history, yet',
      explanation: 'Order history will appear here once you complete one',
      icon: Icons.watch_later_outlined,
    );
  }
}

class _NoContent extends StatelessWidget {
  const _NoContent(
      {super.key,
      required this.icon,
      required this.description,
      required this.explanation});
  final IconData icon;
  final String description;
  final String explanation;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.only(top: 80.r),
            width: 88.r,
            height: 88.r,
            alignment: Alignment.center,
            decoration: const BoxDecoration(
                color: Colors.white, shape: BoxShape.circle),
            child: Icon(
              size: 36.72.r,
              icon,
              color: const Color(0xff888888),
            ),
          ),
          24.verticalSpaceFromWidth,
          Container(
              width: double.infinity,
              height: 22.r,
              alignment: Alignment.center,
              child: Text(
                description,
                style:
                    context.text16grey88.copyWith(fontWeight: FontWeight.bold),
              )),
          4.verticalSpaceFromWidth,
          Container(
              width: double.infinity,
              height: 44.r,
              alignment: Alignment.center,
              child: Text(
                explanation,
                style: context.text16grey88,
                textAlign: TextAlign.center,
              )),
        ],
      ),
    );
  }
}
