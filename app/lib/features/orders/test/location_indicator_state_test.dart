import 'package:test/test.dart';

import '../domain/location_indicator_state.dart'; // Replace with your actual import

void main() {
  for (int locationIndex = 0; locationIndex <= 3; locationIndex++) {
    for (int orderProgress = 0; orderProgress <= 16; orderProgress++) {
      LocationIndicatorState state =
          LocationIndicatorState.from(locationIndex, orderProgress);
      print(
          'locationIndex: $locationIndex, orderProgress: $orderProgress, LocationIndicatorState: $state');
    }
    print('---');
  }
  group('LocationIndicatorState from()', () {
    test(
        'Returns exhausted when orderProgress is 0, otherwise returns inactive when orderProgress is less than or equal to 3 times locationIndex',
        () {
      expect(LocationIndicatorState.from(0, 0),
          equals(LocationIndicatorState.inactive));
      expect(LocationIndicatorState.from(0, 1),
          equals(LocationIndicatorState.inactive));
      expect(LocationIndicatorState.from(1, 4),
          equals(LocationIndicatorState.inactive));
    });

    test(
        'Returns active when orderProgress is less than or equal to 3 times locationIndex plus 2',
        () {
      expect(LocationIndicatorState.from(0, 2),
          equals(LocationIndicatorState.active));
      expect(LocationIndicatorState.from(1, 5),
          equals(LocationIndicatorState.active));
    });

    test(
        'Returns exhausted when orderProgress is less than or equal to 3 times locationIndex plus 3',
        () {
      expect(LocationIndicatorState.from(0, 3),
          equals(LocationIndicatorState.exhausted));
      expect(LocationIndicatorState.from(1, 6),
          equals(LocationIndicatorState.exhausted));
    });

    test(
        'Returns exhausted when orderProgress is greater than 3 times locationIndex plus 3',
        () {
      expect(LocationIndicatorState.from(1, 7),
          equals(LocationIndicatorState.exhausted));
      expect(LocationIndicatorState.from(2, 10),
          equals(LocationIndicatorState.exhausted));
    });
  });
}
