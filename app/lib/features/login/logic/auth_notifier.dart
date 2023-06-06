import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:superfleet_courier/model/api.dart';
import 'package:superfleet_courier/model/courier_notifier.dart';

part 'auth_notifier.freezed.dart';
part 'auth_notifier.g.dart';

@riverpod
class AuthNotifier extends _$AuthNotifier {
  @override
  AsyncValue<AuthState> build() {
    validateLoggedInState();
    return const AsyncLoading();
  }

  Future<void> validateLoggedInState() async {
    state = await AsyncValue.guard(() async {
      try {
        final result = await ref.read(courierNotifierProvider.future);
        if (result == null) {
          return const AuthState.loggedOut();
        } else {
          return const AuthState.loggedIn();
        }
      } on DioError catch (e) {
        if (e.response?.statusCode == 401) {
          return const AuthState.loggedOut();
        } else {
          rethrow;
        }
      }
    });
  }

  login() async {
    state = await AsyncValue.guard(() async {
      final dio = ref.read(apiProvider);
      final apiNotifier = ref.read(apiProvider.notifier);
      final response = await dio.post('/auth/login',
          data: {
            'username': 'ketchup@gmail.com',
            'password': 'Aaaa123\$',
          },
          options: Options(headers: {'x-account-type': 'COURIER'}));
      await apiNotifier.updateToken(response.data['data']['accessToken'],
          response.data['data']['refreshToken']);
      return const AuthState.loggedIn();
    });
  }
}

@freezed
class AuthState with _$AuthState {
  const factory AuthState.loggedOut() = AuthStateLoggedOut;
  const factory AuthState.loggedIn() = AuthStateLoggedIn;
}
