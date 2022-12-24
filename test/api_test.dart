import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:superfleet_courier/repository/mock_repository.dart';

void main() {
  test('Login', () async {
    final api = MockRepository();

    expect(
        () => api.login('ketchup@gmail.com', "Aaaa123\$"),
        throwsA(
            predicate((e) => e is DioError && e.response!.statusCode == 401)));

    expect(() => api.login('kalbas@gmail.com', "123456"), isNotNull);
  });
}
