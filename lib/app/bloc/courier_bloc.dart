import 'package:dio/dio.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:superfleet_courier/repository/superfleet_api.dart';

import '../../model/model.dart';

part 'courier_bloc.freezed.dart';

class CourierBloc extends StateNotifier<CourierState> {
  CourierBloc(this.repository)
      : super(const CourierState.checkingLoginStatus()) {
    validateLoggedInState();
  }

  final SuperfleetAPI repository;

  void validateLoggedInState() async {
    try {
      final courier = await repository.getCourier();
      if (courier == null) {
        state = const CourierState.loggedOut();
        return;
      }
      //repository.getOrdersForCourier(courierId: courier.id);
      state = CourierState.loggedIn(courier: courier, orders: []);
    } on DioError {
      state = const CourierState.loggedOut();
    }
  }

  void changeStatus([bool? active]) async {
    final loggedInState = state as CourierStateLoggedIn;
    final activeState =
        active ?? (loggedInState.courier.status == 'ACTIVE' ? false : true);
    final targetStatus = activeState ? 'ACTIVE' : 'INACTIVE';
    final updatedCourier = await repository.updateCourierStatus(
        courier: loggedInState.courier, status: targetStatus);

    state = loggedInState.copyWith(courier: updatedCourier);
  }

  Future<Courier> login(String username, String password) async {
    return await repository.login(username, password);
  }
}

@freezed
class CourierState with _$CourierState {
  const factory CourierState.checkingLoginStatus() =
      CourierStateCheckingLoginStatus;

  const factory CourierState.loggedOut() = CourierStateLoggedOut;
  const factory CourierState.loggedIn(
      {required Courier courier,
      required List<Order> orders}) = CourierStateLoggedIn;
}
