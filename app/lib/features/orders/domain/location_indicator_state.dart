enum LocationIndicatorState {
  inactive,
  active,
  exhausted;

  static LocationIndicatorState from(int locationIndex, int orderProgress) {
    if (locationIndex == 0) {
      switch (orderProgress) {
        case 0:
          return LocationIndicatorState.inactive;
        case 1:
          return LocationIndicatorState.active;
        case 2:
          return LocationIndicatorState.exhausted;
        default:
          return LocationIndicatorState.exhausted;
      }
    } else {
      if (orderProgress < 2) return LocationIndicatorState.inactive;
      var op = orderProgress - 2;
      var li = locationIndex - 1;
      op = op - (li * 3);
      if (op < 0) return LocationIndicatorState.inactive;
      switch (op) {
        case 0:
          return LocationIndicatorState.active;
        case 1:
          return LocationIndicatorState.active;
        case 2:
          return LocationIndicatorState.exhausted;
        default:
          return LocationIndicatorState.exhausted;
      }
    }
  }
}
