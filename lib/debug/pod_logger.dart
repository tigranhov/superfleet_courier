import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger/logger.dart';

class PodLogger extends ProviderObserver {
  final logger = Logger(
      printer: PrettyPrinter(
    methodCount: 0,
    colors: false,
    noBoxingByDefault: true,
  ));

  @override
  void didAddProvider(
      ProviderBase provider, Object? value, ProviderContainer container) {
    logger.d('''
{
  "added": "${provider.name ?? provider.runtimeType}",
  "value": "$value"
}''');
    super.didAddProvider(provider, value, container);
  }

  @override
  void didDisposeProvider(ProviderBase provider, ProviderContainer container) {
    logger.d('''"disposed": "${provider.name ?? provider.runtimeType}"}''');
    super.didDisposeProvider(provider, container);
  }

  @override
  void didUpdateProvider(
    ProviderBase provider,
    Object? previousValue,
    Object? newValue,
    ProviderContainer container,
  ) {
    logger.d('''
{
  "updated": "${provider.name ?? provider.runtimeType}",
  "newValue": "$newValue"
}''');
  }
}
