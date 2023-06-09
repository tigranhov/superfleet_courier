import 'package:device_preview/device_preview.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:superfleet_courier/model/api.dart';
import 'package:superfleet_courier/routes.dart';
import 'package:stack_trace/stack_trace.dart' as stack_trace;
import 'package:superfleet_courier/theme/colors.dart';
import 'model/interceptors/mock_interceptor.dart' as mock_interceptor;
import 'model/location.dart';
import 'model/order/order.dart';
import 'model/order/order_status.dart';
import 'theme/sf_theme.dart';

void main() async {
  await GetStorage.init();
  FlutterError.demangleStackTrace = (StackTrace stack) {
    if (stack is stack_trace.Trace) return stack.vmTrace;
    if (stack is stack_trace.Chain) return stack.toTrace().vmTrace;
    return stack;
  };
  runApp(ProviderScope(
    child: DevicePreview(
        enabled: kIsWeb,
        defaultDevice: Devices.ios.iPhoneSE,
        isToolbarVisible: true,
        builder: (context) {
          return const MyApp();
        }),
  ));
}

class MyApp extends HookConsumerWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context, ref) {
    final router = ref.watch(routerProvider);

    return Directionality(
      textDirection: TextDirection.ltr,
      child: Stack(
        children: [
          MaterialApp.router(
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            title: 'Courier',
            routerConfig: router,
            builder: DevicePreview.appBuilder,
            theme: ThemeData(
              primarySwatch: Colors.blue,
              textTheme: GoogleFonts.robotoTextTheme(),
              colorScheme: const ColorScheme.light(
                surface: Colors.white,
                background: Colors.white,
                primaryContainer: Colors.white,
                primary: superfleetBlue,
                secondary: superfleetGreen,
                surfaceTint: Colors.transparent,
              ),
            ).copyWith(extensions: [SFTheme.light]),
          ),
          Positioned(
              bottom: 0,
              left: 0,
              child: TextButton(
                child: const Text('New order'),
                onPressed: () {
                  mock_interceptor.orders.add(
                    Order(
                        id: 1,
                        to: const ToLocation(
                            id: 2,
                            locationData: LocationData(
                                lat: 40.172456,
                                lng: 44.509642,
                                address: 'Movses Khorenatsi Street, 56/1')),
                        from: [
                          FromLocation(
                              id: 1,
                              availableFrom: DateTime.now().add(
                                const Duration(minutes: 5),
                              ),
                              locationData: const LocationData(
                                  lat: 40.182352,
                                  lng: 44.515472,
                                  address: 'Hin Yerevantsu Street')),
                          FromLocation(
                              id: 1,
                              availableFrom: DateTime.now().add(
                                const Duration(minutes: 10),
                              ),
                              locationData: const LocationData(
                                  lat: 40.180056,
                                  lng: 44.514238,
                                  address: 'Khachatur Abovyan Street, 1/3')),
                        ],
                        courier: mock_interceptor.courier,
                        deliverUntil:
                            DateTime.now().add(const Duration(minutes: 30)),
                        canAcceptUntil:
                            DateTime.now().add(const Duration(seconds: 60)),
                        status: OrderStatus.open.toString()),
                  );
                },
              )),
          if (kDebugMode)
            Positioned(
                bottom: 0,
                right: 0,
                child: TextButton(
                    child: const Text('Copy token'),
                    onPressed: () async {
                      final token = await ref.read(accessTokenProvider.future);
                      if (token != null) {
                        await Clipboard.setData(
                            ClipboardData(text: token.accessToken));
                      }
                    })),
        ],
      ),
    );
  }
}

// class MyHomePage extends StatefulWidget {
//   const MyHomePage({super.key, required this.title});

//   // This widget is the home page of your application. It is stateful, meaning
//   // that it has a State object (defined below) that contains fields that affect
//   // how it looks.

//   // This class is the configuration for the state. It holds the values (in this
//   // case the title) provided by the parent (in this case the App widget) and
//   // used by the build method of the State. Fields in a Widget subclass are
//   // always marked "final".

//   final String title;

//   @override
//   State<MyHomePage> createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {
//   int _counter = 0;

//   void _incrementCounter() {
//     setState((F) {
//       // This call to setState tells the Flutter framework that something has
//       // changed in this State, which causes it to rerun the build method below
//       // so that the display can reflect the updated values. If we changed
//       // _counter without calling setState(), then the build method would not be
//       // called again, and so nothing would appear to happen.
//       _counter++;
//     });
//   }

//   @override
//   void initState() {
//     function() async {
//       final repo = SuperfleetRepository();
//       // await repo.login('harut.martirosyan@gmail.com', '''Aaaa123\$''');
//       User user = await repo.getCurrentUser();
//       print('a');
//     }

//     function();
//     // someFunction()async{
//     //   Location location = new Location();
//     //   location.enableBackgroundMode(enable: true);
//     //   bool _serviceEnabled;
//     //   PermissionStatus _permissionGranted;
//     //   LocationData _locationData;

//     //   _serviceEnabled = await location.serviceEnabled();
//     //   if (!_serviceEnabled) {
//     //     _serviceEnabled = await location.requestService();
//     //     if (!_serviceEnabled) {
//     //       return;
//     //     }
//     //   }

//     //   _permissionGranted = await location.hasPermission();
//     //   if (_permissionGranted == PermissionStatus.denied) {
//     //     _permissionGranted = await location.requestPermission();
//     //     if (_permissionGranted != PermissionStatus.granted) {
//     //       return;
//     //     }
//     //   }

//     //   _locationData = await location.getLocation();
//     //   location.onLocationChanged.listen((LocationData currentLocation) {
//     //     print('${DateTime.now()}   $currentLocation');
//     //   });
//     // }
//     // someFunction();
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     // This method is rerun every time setState is called, for instance as done
//     // by the _incrementCounter method above.
//     //
//     // The Flutter framework has been optimized to make rerunning build methods
//     // fast, so that you can just rebuild anything that needs updating rather
//     // than having to individually change instances of widgets.
//     return Scaffold(
//       appBar: AppBar(
//         // Here we take the value from the MyHomePage object that was created by
//         // the App.build method, and use it to set our appbar title.
//         title: Text(widget.title),
//       ),
//       body: ListView(children: const [
//         SizedBox(height: 5),
//         Center(child: SwipeToOrder()),
//         SizedBox(height: 5),
//         Center(child: GoOnlineButton()),
//         SizedBox(height: 5),
//         Center(child: RejectButton()),
//         SizedBox(height: 5),
//         Center(
//             child: ReasonCheckbox(
//           text: 'Reason 1',
//           value: false,
//         )),
//         SizedBox(height: 5),
//         Center(
//             child: ReasonCheckbox(
//           text: 'Reason 1',
//           value: true,
//         )),
//         SizedBox(height: 5),
//         Center(
//             child: ReasonCheckbox(
//           text:
//               'Reason 2 with very long text goes into this cell up to 2 lines',
//           value: true,
//         )),
//         SizedBox(height: 5),
//         Center(
//           child: OrderTabBar(),
//         ),
//         SizedBox(height: 5),
//         Center(
//           child: AddressTile(),
//         )
//       ]),
//       floatingActionButton: FloatingActionButton(
//         onPressed: _incrementCounter,
//         tooltip: 'Increment',
//         child: const Icon(Icons.add),
//       ), // This trailing comma makes auto-formatting nicer for build methods.
//     );
//   }
// }
