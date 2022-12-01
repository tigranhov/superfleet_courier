import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:superfleet_courier/model/model.dart';
import 'package:superfleet_courier/repository/superfleet_api.dart';

part 'order_bloc.freezed.dart';

class OrderBloc extends Bloc<OrderEvent, OrderState> {
  OrderBloc(
      {required SuperfleetAPI repository, required Courier courier})
      : super(const OrderStateLoading()) {
    on<OrderEventLoad>(
      (event, emit) async {
        final orders =
            await repository.getOrders();

        emit(OrderState.loaded(orders: orders, courier: courier));
      },
    );
    add(const OrderEvent.load());
  }
}

@freezed
class OrderState with _$OrderState {
  const factory OrderState.loaded(
      {required List<Order> orders,
      required Courier courier}) = OrderStateLoaded;
  const factory OrderState.loading() = OrderStateLoading;
  
}

@freezed
class OrderEvent with _$OrderEvent {
  const factory OrderEvent.load() = OrderEventLoad;
}
