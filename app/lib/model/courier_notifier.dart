import 'package:audioplayers/audioplayers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'api.dart';
import 'courier.dart';

part 'courier_notifier.g.dart';

@riverpod
class CourierNotifier extends _$CourierNotifier {
  AudioPlayer? player;
  @override
  Future<Courier?> build() async {
    final api = ref.watch(apiProvider);
    player = AudioPlayer();
    ref.onDispose(() {
      player?.dispose();
    });

    //TODO timer for demonstration, remove later
    await Future.delayed(const Duration(seconds: 1));
    final response = await api.get('/auth/me');
    return response.data['data'] == null
        ? null
        : Courier.fromJson(response.data['data']);
  }

  void changeStatus([bool? active]) async {
    if (player?.source == null) {
      await player?.setSource(AssetSource('sounds/go_online.mp3'));
    }
    state = await AsyncValue.guard(() async {
      final courier = state.value!;
      final dio = ref.read(apiProvider);
      final activeState = active ?? (courier.status == 'ACTIVE' ? false : true);
      final targetStatus = activeState ? 'ACTIVE' : 'INACTIVE';
      final response = await dio
          .patch('/couriers/${courier.id}', data: {'status': targetStatus});
      if (targetStatus == 'ACTIVE') {
        await player?.stop();
        player?.resume();
      }
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
