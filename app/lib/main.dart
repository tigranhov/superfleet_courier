import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:superfleet_courier/routes.dart';
import 'package:stack_trace/stack_trace.dart' as stack_trace;

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
        enabled: false,
        defaultDevice: Devices.ios.iPhoneSE,
        isToolbarVisible: false,
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

    return MaterialApp.router(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      title: 'Courier',
      routerConfig: router,
      builder: DevicePreview.appBuilder,
      locale: DevicePreview.locale(context),
      theme: ThemeData(
              primarySwatch: Colors.blue,
              textTheme: GoogleFonts.robotoTextTheme(),
              backgroundColor: const Color(0xffCCCCCC))
          .copyWith(extensions: [SFTheme.light]),
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
