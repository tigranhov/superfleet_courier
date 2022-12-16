import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:superfleet_courier/model/model.dart';

part 'order_state.freezed.dart';

@freezed
class OrderState with _$OrderState {
  const factory OrderState.data({required List<Order> orders}) =
      OrderStateLoaded;
  const factory OrderState.loading() = OrderStateLoading;

  const factory OrderState.invalid() = OrderStateLoggedOut;
}
