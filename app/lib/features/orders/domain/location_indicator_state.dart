// enum LocationState {
//   orderNotStarted,
//   orderStarted,
//   goingToLocation,
//   atLocation,
//   actionCompleted,
//   leftLocation,
//   inactiveLocation;
//
//   String nextString() {
//     print(this);
//     switch (this) {
//       case LocationState.orderNotStarted:
//         return "Start Order";
//       case LocationState.orderStarted:
//         return "I am at the pickup location";
//       case LocationState.goingToLocation:
//         return "I am at the pickup location";
//       case LocationState.atLocation:
//         return "Order picked up";
//       case LocationState.actionCompleted:
//         return "I am at the pickup";
//       case LocationState.leftLocation:
//         return "leftLocation";
//       case LocationState.inactiveLocation:
//         return "inactiveLocation";
//     }
//   }
//
//   static LocationState from(int locationIndex, int orderProgress) {
//     if (locationIndex == 0) {
//       switch (orderProgress) {
//         case 0:
//           return LocationState.orderNotStarted;
//         case 1:
//           return LocationState.orderStarted;
//         case 2:
//           return LocationState.leftLocation;
//         default:
//           return LocationState.leftLocation;
//       }
//     } else {
//       if (orderProgress < 2) return LocationState.inactiveLocation;
//       var op = orderProgress - 2;
//       var li = locationIndex - 1;
//       op = op - (li * 3);
//       if (op < 0) return LocationState.inactiveLocation;
//       switch (op) {
//         case 0:
//           return LocationState.atLocation;
//         case 1:
//           return LocationState.actionCompleted;
//         case 2:
//           return LocationState.leftLocation;
//         default:
//           return LocationState.leftLocation;
//       }
//     }
//   }
// }

enum LocationIndicatorState {
  inactive,
  active,
  exhausted;
}
//
//   static LocationIndicatorState from(int locationIndex, int orderProgress) {
//     final locationState = LocationState.from(locationIndex, orderProgress);
//     switch (locationState) {
//       case LocationState.orderNotStarted:
//         return LocationIndicatorState.inactive;
//       case LocationState.orderStarted:
//         return LocationIndicatorState.active;
//       case LocationState.goingToLocation:
//         return LocationIndicatorState.inactive;
//       case LocationState.atLocation:
//         return LocationIndicatorState.active;
//       case LocationState.actionCompleted:
//         return LocationIndicatorState.active;
//       case LocationState.leftLocation:
//         return LocationIndicatorState.exhausted;
//       case LocationState.inactiveLocation:
//         return LocationIndicatorState.inactive;
//       default:
//         return LocationIndicatorState.inactive;
//     }
//   }
// }
