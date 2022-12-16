import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:superfleet_courier/model/model.dart';

part 'new_order_bloc.freezed.dart';

class NewOrderBloc extends StateNotifier<NewOrderState> {
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