import 'package:asuka/asuka.dart' as asuka;
import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_modular/flutter_modular.dart';

import 'core/presenter/stores/prefs_store.dart';
import 'core/presenter/theme/theme.dart';

class AppWidget extends StatefulWidget {
  const AppWidget({Key? key}) : super(key: key);

  @override
  State<AppWidget> createState() => _AppWidgetState();
}

class _AppWidgetState extends State<AppWidget> {
  final store = Modular.get<PreferencesStore>();

  @override
  void initState() {
    super.initState();

    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(statusBarColor: Colors.transparent),
    );

    store.getData();
  }

  @override
  Widget build(BuildContext context) {
    return DynamicColorBuilder(
      builder: (lightDynamic, darkDynamic) => ThemeProvider(
        lightDynamic: lightDynamic,
        darkDynamic: darkDynamic,
        settings: store.selectState,
        child: NotificationListener<OverscrollIndicatorNotification>(
          onNotification: (notification) {
            notification.disallowIndicator();
            return false;
          },
          child: ValueListenableBuilder<PreferencesState>(
            valueListenable: store.selectState,
            builder: (context, value, _) {
              final theme = ThemeProvider.of(context);
              final seedColor = Color(store.state.seedColor);

              return MaterialApp.router(
                title: 'Conecta',
                theme: theme.light(seedColor),
                darkTheme: theme.dark(seedColor),
                themeMode: store.state.themeMode,
                debugShowCheckedModeBanner: false,
                showPerformanceOverlay: false,
                builder: asuka.builder,
                useInheritedMediaQuery: true,
                supportedLocales: const [Locale('pt', 'BR')],
                routeInformationParser: Modular.routeInformationParser,
                routerDelegate: Modular.routerDelegate,
                localizationsDelegates: GlobalMaterialLocalizations.delegates,
              );
            },
          ),
        ),
      ),
    );
  }
}
