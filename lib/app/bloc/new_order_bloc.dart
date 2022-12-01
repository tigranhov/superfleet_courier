import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:superfleet_courier/model/model.dart';

part 'new_order_bloc.freezed.dart';

class NewOrderBloc extends Bloc<NewOrderEvent, NewOrderState> {
  NewOrderBloc()
      : super(NewOrderStateValid(
            order: Order(id: 1, to: const ToLocation(), from: [
          FromLocation(
              availableFrom: DateTime.now(),
              id: 23,
              location: Location(),
              pickedUp: false)
        ])));
}

@freezed
class NewOrderState with _$NewOrderState {
  const factory NewOrderState.valid({required Order order}) =
      NewOrderStateValid;
}

@freezed
class NewOrderEvent with _$NewOrderEvent {
  const factory NewOrderEvent.create() = NewOrderEventCreate;
}
