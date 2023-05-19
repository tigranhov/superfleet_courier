import 'package:superfleet_courier/model/model.dart';

import 'location_indicator_state.dart';

class LocationProgress {
  final List<LocationSteps> steps = [];

  void register(Order order) {
    steps.clear();
    steps.add(MeLocationSteps(order.orderProgress));
    for (final pLoc in order.from) {
      final currentStep = order.orderProgress - maxSteps();
      steps.add(PickupLocationSteps(currentStep, pLoc));
    }
    steps.add(DropoffLocationSteps(order.orderProgress - maxSteps(), order.to));
    print(currentStepString(order.orderProgress));
  }

  int maxSteps() {
    return steps.fold(
        0, (previousValue, element) => previousValue + element.stepCount);
  }

  LocationSteps? currentStep(int orderProgress) {
    int index = 0;
    for (int i = 0; i < steps.length; i++) {
      index += steps[i].stepCount;
      if (orderProgress < index) {
        return steps[i];
      }
    }
    return steps.last;
  }

  String? currentStepString(int orderProgress) {
    return currentStep(orderProgress)?.actionString();
  }

  String? nextStepString(int orderProgress) {
    for (int i = 0; i < steps.length; i++) {
      if (steps[i] == currentStep(orderProgress) && i + 1 < steps.length) {
        return steps[i + 1].actionString();
      }
    }
    return null;
  }
}

mixin LocationSteps {
  Location? get location;
  String actionString();
  int get stepCount;
  get currentStep;
  LocationIndicatorState get indicatorState;
}

class MeLocationSteps with LocationSteps {
  @override
  final int stepCount = 2;

  @override
  final int currentStep;

  @override
  final Location? location = null;

  MeLocationSteps(this.currentStep);

  @override
  String actionString() {
    return switch (currentStep) {
      0 => 'Start order',
      _ => 'Reached Pickup Location',
    };
  }

  @override
  LocationIndicatorState get indicatorState => switch (currentStep) {
        0 => LocationIndicatorState.inactive,
        1 => LocationIndicatorState.active,
        _ => LocationIndicatorState.exhausted
      };
}

class PickupLocationSteps with LocationSteps {
  @override
  final int stepCount = 3;

  @override
  final int currentStep;

  @override
  final Location location;

  PickupLocationSteps(this.currentStep, this.location);

  @override
  String actionString() {
    return switch (currentStep) {
      0 => 'Kalbas',
      1 => 'Kalbas2',
      _ => 'sad[sopkfdas'
    };
  }

  @override
  LocationIndicatorState get indicatorState => switch (currentStep) {
        0 => LocationIndicatorState.active,
        1 => LocationIndicatorState.active,
        2 => LocationIndicatorState.exhausted,
        < 0 => LocationIndicatorState.inactive,
        _ => LocationIndicatorState.exhausted
      };
}

class DropoffLocationSteps with LocationSteps {
  @override
  final int stepCount = 2;
  @override
  final int currentStep;

  @override
  final Location location;

  DropoffLocationSteps(this.currentStep, this.location);

  @override
  String actionString() {
    // Adjust the string according to current step.
    // Here is a placeholder implementation
    return "Drop-off location - step $currentStep";
  }

  @override
  LocationIndicatorState get indicatorState => switch (currentStep) {
        0 => LocationIndicatorState.active,
        1 => LocationIndicatorState.exhausted,
        < 0 => LocationIndicatorState.inactive,
        _ => LocationIndicatorState.exhausted
      };
}
