import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:superfleet_courier/model/courier.dart';
import 'package:superfleet_courier/repository/superfleet_api.dart';

part 'courier_bloc.freezed.dart';

class CourierBloc extends Bloc<CourierEvent, CourierState> {
  CourierBloc(SuperfleetAPI repository)
      : super(const CourierState.checkingLoginStatus()) {
    on<CourierEventCheckIsLoggedIn>(
      (event, emit) async {
        try {
          final courier = await repository.getCourier();
          if (courier == null) {
            emit(const CourierState.loggedOut());
            return;
          }
          //repository.getOrdersForCourier(courierId: courier.id);
          emit(CourierState.loggedIn(courier: courier));
        } catch (e) {
          emit(const CourierState.loggedOut());
        }
      },
    );
    add(const CourierEvent.checkIsLoggedIn());

    on<CourierEventChangeStatus>(
      (event, emit) async {
        final loggedInState = state as CourierStateLoggedIn;
        final active = event.active ??
            (loggedInState.courier.status == 'ACTIVE' ? false : true);
        final targetStatus = active ? 'ACTIVE' : 'INACTIVE';
        final updatedCourier =
            await repository.updateCourierStatus(status: targetStatus);

        emit(loggedInState.copyWith(courier: updatedCourier));
      },
    );

    on<CourierEventLogin>(
      (event, emit) async {
        // final user = await repository.login(event.username, event.password);
        // add(CourierEvent.checkIsLoggedIn());
      },
    );
  }

  @override
  void onError(Object error, StackTrace stackTrace) {
    if (error is DioError) {
      print('object');
    }
    super.onError(error, stackTrace);
  }

  @override
  Future<void> close() {
    return super.close();
  }
}

@freezed
class CourierState with _$CourierState {
  const factory CourierState.checkingLoginStatus() =
      CourierStateCheckingLoginStatus;

  const factory CourierState.loggedOut() = CourierStateLoggedOut;
  const factory CourierState.loggedIn({required Courier courier}) =
      CourierStateLoggedIn;
}

@freezed
class CourierEvent with _$CourierEvent {
  const factory CourierEvent.login(
      {required String username, required String password}) = CourierEventLogin;
  const factory CourierEvent.checkIsLoggedIn() = CourierEventCheckIsLoggedIn;
  const factory CourierEvent.changeStatus([bool? active]) =
      CourierEventChangeStatus;
}
