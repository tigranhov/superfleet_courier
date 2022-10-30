import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:superfleet_courier/model/courier.dart';
import 'package:superfleet_courier/model/user.dart';
import 'package:superfleet_courier/repository/superfleet_repository.dart';

part 'user_bloc.freezed.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  UserBloc(SuperfleetRepository repository)
      : super(const UserState.checkingLoginStatus()) {
    on<UserEventCheckIsLoggedIn>(
      (event, emit) async {
        try {
          final user = event.user ?? await repository.getCurrentUser();
          if (user == null) {
            emit(const UserState.loggedOut());
            return;
          }
          final courier = await repository.getCourier(id: 14);
          //repository.getOrdersForCourier(courierId: courier.id);
          emit(UserState.loggedIn(user: user, courier: courier));
        } catch (e) {
          emit(const UserState.loggedOut());
        }
      },
    );
    add(const UserEvent.checkIsLoggedIn());

    on<UserEventChangeStatus>(
      (event, emit) async {
        final loggedInState = state as UserStateLoggedIn;
        final active = event.active ??
            (loggedInState.courier.status == 'ACTIVE' ? false : true);
        final targetStatus = active ? 'ACTIVE' : 'INACTIVE';
        final updatedCourier = await repository.updateCourierStatus(
            id: loggedInState.courier.id, status: targetStatus);

        emit(loggedInState.copyWith(courier: updatedCourier));
      },
    );

    on<UserEventLogin>(
      (event, emit) async {
        final user = await repository.login(event.username, event.password);
        add(UserEvent.checkIsLoggedIn(user: user));
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
class UserState with _$UserState {
  const factory UserState.checkingLoginStatus() = UserStateCheckingLoginStatus;

  const factory UserState.loggedOut() = UserStateLoggedOut;
  const factory UserState.loggedIn(
      {required User user, required Courier courier}) = UserStateLoggedIn;
}

@freezed
class UserEvent with _$UserEvent {
  const factory UserEvent.login(
      {required String username, required String password}) = UserEventLogin;
  const factory UserEvent.checkIsLoggedIn({User? user}) =
      UserEventCheckIsLoggedIn;
  const factory UserEvent.changeStatus([bool? active]) = UserEventChangeStatus;
}
