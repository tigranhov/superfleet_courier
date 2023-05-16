import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:superfleet_courier/model/api.dart';
import 'package:superfleet_courier/model/location.dart';

part 'courier.freezed.dart';
part 'courier.g.dart';

@freezed
class Courier with _$Courier {
  const factory Courier(
      {required int id,
      required String firstName,
      required String lastName,
      String? profileImageId,
      String? status,
      String? transport,
      LocationData? location,
      String? email}) = _Courier;

  factory Courier.fromJson(Map<String, dynamic> json) =>
      _$CourierFromJson(json);
}

@riverpod
class CourierNotifier extends _$CourierNotifier {
  @override
  Future<Courier?> build() async {
    final api = ref.watch(apiProvider);
    final response = await api.get('/auth/me');
    return response.data['data'] == null
        ? null
        : Courier.fromJson(response.data['data']);
  }

  void changeStatus([bool? active]) async {
    state = await AsyncValue.guard(() async {
      final courier = state.value!;
      final dio = ref.read(apiProvider);
      final activeState = active ?? (courier.status == 'ACTIVE' ? false : true);
      final targetStatus = activeState ? 'ACTIVE' : 'INACTIVE';
      final response = await dio
          .patch('/couriers/${courier.id}', data: {'status': targetStatus});
      return Courier.fromJson(response.data['data']);
    });
  }

  void selectTransport(String transport) async {
    state = await AsyncValue.guard(() async {
      final courier = state.value!;
      final dio = ref.read(apiProvider);
      final response = await dio.patch('/couriers/${courier.id}',
          data: {'transport': transport.toUpperCase()});
      return Courier.fromJson(response.data['data']);
    });
  }
}
