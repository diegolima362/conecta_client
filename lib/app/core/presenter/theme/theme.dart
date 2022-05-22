import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_color_utilities/material_color_utilities.dart';

import '../stores/prefs_store.dart';

class NoAnimationPageTransitionsBuilder extends PageTransitionsBuilder {
  const NoAnimationPageTransitionsBuilder();

  @override
  Widget buildTransitions<T>(
    PageRoute<T> route,
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return child;
  }
}

class ThemeProvider extends InheritedWidget {
  const ThemeProvider(
      {Key? key,
      required this.settings,
      required this.lightDynamic,
      required this.darkDynamic,
      required Widget child})
      : super(key: key, child: child);

  final ValueListenable<PreferencesState> settings;
  final ColorScheme? lightDynamic;
  final ColorScheme? darkDynamic;

  final pageTransitionsTheme = const PageTransitionsTheme(
    builders: <TargetPlatform, PageTransitionsBuilder>{
      TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
      TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
      TargetPlatform.linux: NoAnimationPageTransitionsBuilder(),
      TargetPlatform.macOS: NoAnimationPageTransitionsBuilder(),
      TargetPlatform.windows: NoAnimationPageTransitionsBuilder(),
    },
  );

  Color custom(CustomColor custom) {
    if (custom.blend) {
      return blend(custom.color);
    } else {
      return custom.color;
    }
  }

  Color blend(Color targetColor) {
    return Color(Blend.harmonize(targetColor.value, settings.value.seedColor));
  }

  Color source(Color? target) {
    Color source = Color(settings.value.seedColor);
    if (target != null) {
      source = blend(target);
    }
    return source;
  }

  ColorScheme colorScheme(Brightness brightness, Color? targetColor) {
    final dynamicPrimary = brightness == Brightness.light
        ? lightDynamic?.primary
        : darkDynamic?.primary;
    return ColorScheme.fromSeed(
      seedColor: dynamicPrimary ?? source(targetColor),
      brightness: brightness,
    );
  }

  ShapeBorder get shapeMedium => RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      );

  RadioThemeData radioTheme(ColorScheme scheme) => RadioThemeData(
        fillColor: MaterialStateProperty.resolveWith((_) => scheme.secondary),
      );

  CardTheme cardTheme(ColorScheme scheme) {
    return CardTheme(
      elevation: 0,
      shape: shapeMedium,
      clipBehavior: Clip.antiAlias,
      color: scheme.surfaceVariant,
      shadowColor: scheme.shadow,
    );
  }

  DialogTheme dialogTheme(ColorScheme scheme) {
    return DialogTheme(
      backgroundColor: scheme.surface,
      elevation: 3,
      titleTextStyle: TextStyle(
        color: scheme.onSurface,
        fontSize: 24,
      ),
      contentTextStyle: TextStyle(
        color: scheme.onSurfaceVariant,
        fontSize: 14,
        letterSpacing: 0.25,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(28),
      ),
    );
  }

  ListTileThemeData listTileTheme(ColorScheme colors) {
    return ListTileThemeData(
      shape: shapeMedium,
      selectedColor: colors.secondary,
    );
  }

  AppBarTheme appBarTheme(ColorScheme colors) {
    return AppBarTheme(
      elevation: 0,
      backgroundColor: colors.surface,
      foregroundColor: colors.onSurface,
    );
  }

  TabBarTheme tabBarTheme(ColorScheme colors) {
    return TabBarTheme(
      labelColor: colors.secondary,
      unselectedLabelColor: colors.onSurfaceVariant,
      indicator: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: colors.secondary,
            width: 2,
          ),
        ),
      ),
    );
  }

  BottomAppBarTheme bottomAppBarTheme(ColorScheme colors) {
    return BottomAppBarTheme(
      color: colors.surface,
      elevation: 0,
    );
  }

  BottomNavigationBarThemeData bottomNavigationBarTheme(ColorScheme colors) {
    return BottomNavigationBarThemeData(
      type: BottomNavigationBarType.fixed,
      backgroundColor: colors.surfaceVariant,
      selectedItemColor: colors.onSurface,
      unselectedItemColor: colors.onSurfaceVariant,
      elevation: 0,
      landscapeLayout: BottomNavigationBarLandscapeLayout.centered,
    );
  }

  NavigationRailThemeData navigationRailTheme(ColorScheme colors) {
    return const NavigationRailThemeData();
  }

  DrawerThemeData drawerTheme(ColorScheme colors) {
    return DrawerThemeData(
      backgroundColor: colors.surface,
    );
  }

  ThemeData light([Color? targetColor]) {
    final colors = colorScheme(Brightness.light, targetColor);
    return ThemeData.light().copyWith(
      primaryColor: Colors.black,
      pageTransitionsTheme: pageTransitionsTheme,
      colorScheme: colors,
      appBarTheme: appBarTheme(colors),
      cardTheme: cardTheme(colors),
      dialogTheme: dialogTheme(colors),
      listTileTheme: listTileTheme(colors),
      bottomAppBarTheme: bottomAppBarTheme(colors),
      bottomNavigationBarTheme: bottomNavigationBarTheme(colors),
      navigationRailTheme: navigationRailTheme(colors),
      tabBarTheme: tabBarTheme(colors),
      drawerTheme: drawerTheme(colors),
      scaffoldBackgroundColor: colors.background,
      radioTheme: radioTheme(colors),
      useMaterial3: true,
    );
  }

  ThemeData dark([Color? targetColor]) {
    final colors = colorScheme(Brightness.dark, targetColor);
    return ThemeData.dark().copyWith(
      primaryColor: Colors.white,
      pageTransitionsTheme: pageTransitionsTheme,
      colorScheme: colors,
      appBarTheme: appBarTheme(colors),
      cardTheme: cardTheme(colors),
      dialogTheme: dialogTheme(colors),
      listTileTheme: listTileTheme(colors),
      bottomAppBarTheme: bottomAppBarTheme(colors),
      bottomNavigationBarTheme: bottomNavigationBarTheme(colors),
      navigationRailTheme: navigationRailTheme(colors),
      tabBarTheme: tabBarTheme(colors),
      drawerTheme: drawerTheme(colors),
      scaffoldBackgroundColor: colors.background,
      radioTheme: radioTheme(colors),
      useMaterial3: true,
    );
  }

  ThemeMode themeMode() {
    return settings.value.themeMode;
  }

  ThemeData theme(BuildContext context, [Color? targetColor]) {
    final brightness = MediaQuery.of(context).platformBrightness;
    return brightness == Brightness.light
        ? light(targetColor)
        : dark(targetColor);
  }

  static ThemeProvider of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<ThemeProvider>()!;
  }

  @override
  bool updateShouldNotify(covariant ThemeProvider oldWidget) {
    return oldWidget.settings != settings;
  }
}

class ThemeSettings {
  ThemeSettings({
    required this.sourceColor,
    required this.themeMode,
  });

  final Color sourceColor;
  final ThemeMode themeMode;
}

Color randomColor() {
  return Color(Random().nextInt(0xFFFFFFFF));
}

// Custom Colors
const linkColor = CustomColor(
  name: 'Link Color',
  color: Color(0xFF00B0FF),
);

class CustomColor {
  const CustomColor({
    required this.name,
    required this.color,
    this.blend = true,
  });

  final String name;
  final Color color;
  final bool blend;

  Color value(ThemeProvider provider) {
    return provider.custom(this);
  }
}

class AppTheme {
  static ThemeData theme(Color seedColor, {bool darkMode = false}) {
    late Brightness brightness;

    if (darkMode) {
      brightness = Brightness.dark;
    } else {
      brightness = Brightness.light;
    }

    final scheme = ColorScheme.fromSeed(
      seedColor: seedColor,
      brightness: brightness,
    );

    return ThemeData(
      brightness: brightness,
      primaryColor: darkMode ? Colors.white : Colors.black,
      useMaterial3: true,
      colorScheme: scheme,
      indicatorColor: scheme.secondary,
      appBarTheme: AppBarTheme(
        elevation: 0,
        toolbarHeight: 64,
        backgroundColor: scheme.surface,
        foregroundColor: scheme.onSurface,
        titleTextStyle: TextStyle(
          color: scheme.onSurface,
          fontSize: 22,
          fontWeight: FontWeight.w400,
        ),
        iconTheme: IconThemeData(
          color: scheme.onSurface,
        ),
        actionsIconTheme: IconThemeData(
          color: scheme.onSurfaceVariant,
        ),
      ),
      canvasColor: scheme.background,
      backgroundColor: scheme.background,
      cardTheme: CardTheme(
        color: scheme.surfaceVariant,
        shadowColor: scheme.shadow,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: scheme.primaryContainer,
        foregroundColor: scheme.onPrimaryContainer,
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: ButtonStyle(
          elevation: MaterialStateProperty.resolveWith((states) => 0),
          foregroundColor: MaterialStateProperty.resolveWith(
            (states) => scheme.primary,
          ),
          textStyle: MaterialStateProperty.resolveWith((states) => TextStyle(
                color: scheme.primary,
                fontSize: 14,
                letterSpacing: 0.1,
                fontWeight: FontWeight.w500,
              )),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
          elevation: MaterialStateProperty.resolveWith((states) => 1),
          backgroundColor: MaterialStateProperty.resolveWith(
            (states) => scheme.surface,
          ),
          foregroundColor: MaterialStateProperty.resolveWith(
            (states) => scheme.primary,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: ButtonStyle(
          elevation: MaterialStateProperty.resolveWith((states) => 0),
          backgroundColor: MaterialStateProperty.resolveWith(
            (states) => scheme.surface,
          ),
          foregroundColor: MaterialStateProperty.resolveWith(
            (states) => scheme.primary,
          ),
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: scheme.secondaryContainer.withOpacity(0.25),
        indicatorColor: scheme.primaryContainer,
        labelTextStyle: MaterialStateProperty.resolveWith(
          (_) => TextStyle(
            color: scheme.onSurface,
          ),
        ),
        iconTheme: MaterialStateProperty.resolveWith(
          (_) => IconThemeData(
            color: scheme.onSecondaryContainer,
          ),
        ),
      ),
      dialogTheme: DialogTheme(
        backgroundColor: scheme.surface,
        elevation: 3,
        titleTextStyle: TextStyle(
          color: scheme.onSurface,
          fontSize: 24,
        ),
        contentTextStyle: TextStyle(
          color: scheme.onSurfaceVariant,
          fontSize: 14,
          letterSpacing: 0.25,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(28),
        ),
      ),
      timePickerTheme: TimePickerThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(28),
        ),
      ),
      checkboxTheme: CheckboxThemeData(
        checkColor: MaterialStateProperty.resolveWith((_) => scheme.secondary),
      ),
      radioTheme: RadioThemeData(
        fillColor: MaterialStateProperty.resolveWith((_) => scheme.secondary),
      ),
      textTheme: GoogleFonts.montserratTextTheme(),
    );
  }
}
