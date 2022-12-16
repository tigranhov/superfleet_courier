import 'package:flutter_test/flutter_test.dart';
import 'package:superfleet_courier/repository/superfleet_repository.dart';

void main() {
  test('superfleet_api_login', () async {
    final api = SuperfleetRepository();
    api.login('ketchup@gmail.com', "Aaaa123\$");
  });
}
