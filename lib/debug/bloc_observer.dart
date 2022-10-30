import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';

class AppObserver extends BlocObserver {
  final logger = Logger(
      printer: PrettyPrinter(
    methodCount: 0,
    colors: false,
    noBoxingByDefault: true,
  ));

  @override
  void onCreate(BlocBase bloc) {
    logger.d("${bloc.runtimeType} created");
    super.onCreate(bloc);
  }

  @override
  void onEvent(Bloc bloc, Object? event) {
    logger.d("${bloc.runtimeType} $event called");
    super.onEvent(bloc, event);
  }
//Kalbas lav bana
  @override
  void onChange(BlocBase bloc, Change change) {
    logger.i("${bloc.runtimeType} $change");
    super.onChange(bloc, change);
  }

  @override
  void onClose(BlocBase bloc) {
    logger.d("${bloc.runtimeType} ${bloc.runtimeType} closed");

    super.onClose(bloc);
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    logger.d("$error");

    super.onError(bloc, error, stackTrace);
  }
}
