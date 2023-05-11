import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:superfleet_courier/features/deliver_methods/model/delivery_method.dart';
import 'package:superfleet_courier/model/courier.dart';

part 'selected_transport_provider.g.dart';

@riverpod
class SelectedTransport extends _$SelectedTransport {
  @override
  Future<DeliveryMethod> build() async {
    final courier = await ref.watch(courierNotifierProvider.future);
    return DeliveryMethod.fromString(courier!.transport!);
  }

  void selectTransport(DeliveryMethod transport) {
    final courier = ref.read(courierNotifierProvider.notifier);
    courier.selectTransport(transport.toString());
  }
}
