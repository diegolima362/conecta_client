import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

import '../../stores/auth_store.dart';
import '../../widgets/my_app_icon.dart';

class LandingPage extends StatelessWidget {
  LandingPage({Key? key}) : super(key: key) {
    final authStore = Modular.get<AuthStore>();

    authStore.checkLogin().whenComplete(() {
      FlutterNativeSplash.remove();

      if (authStore.isLogged) {
        Modular.to.navigate('/app/home/');
        // Modular.to.navigate('/durations/');
      } else {
        Modular.to.navigate('/auth/');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return const SafeArea(
      child: Center(
        child: Hero(
          tag: 'splah_to_login',
          child: MyAppIcon(height: 175),
        ),
      ),
    );
  }
}
