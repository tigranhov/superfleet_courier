import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:superfleet_courier/features/transports/model/transport.dart';
import 'package:superfleet_courier/model/courier_notifier.dart';

part 'selected_transport_provider.g.dart';

@riverpod
class SelectedTransport extends _$SelectedTransport {
  @override
  Future<Transport> build() async {
    final courier = await ref.watch(courierNotifierProvider.future);
    return Transport.fromString(courier!.transport!);
  }

  void selectTransport(Transport transport) {
    final courier = ref.read(courierNotifierProvider.notifier);
    courier.selectTransport(transport.key);
  }
}
