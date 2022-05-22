import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_triple/flutter_triple.dart';
import 'package:hydrated_triple/hydrated_triple.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app/app_module.dart';
import 'app/app_widget.dart';

const debugLayoutMode = false;

late final SharedPreferences prefs;

Future<void> main() async {
  final widgetsBinding = WidgetsFlutterBinding.ensureInitialized();

  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  await initialization();

  runApp(
    ModularApp(
      module: AppModule(),
      child: const AppWidget(),
    ),
  );

  // runApp(
  //   DevicePreview(
  //     enabled: debugLayoutMode,
  //     builder: (BuildContext context) {
  //       return ModularApp(
  //         module: AppModule(),
  //         child: const AppWidget(),
  //       );
  //     },
  //   ),
  // );
}

Future<void> initialization() async {
  prefs = await SharedPreferences.getInstance();

  setTripleHydratedDelegate(SharedPreferencesHydratedDelegate());
}
