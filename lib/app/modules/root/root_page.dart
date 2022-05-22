import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

import 'root_layout.dart';
import 'root_store.dart';

class RootPage extends StatelessWidget {
  const RootPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final store = Modular.get<RootStore>();

    return ValueListenableBuilder<RootStoreState>(
      valueListenable: store.selectState,
      builder: (context, state, __) => WillPopScope(
        onWillPop: () async {
          if (store.state.currentIndex == 0) {
            return true;
          } else {
            store.setIndex(0);
            Modular.to.navigate('/app/home/');
            return false;
          }
        },
        child: Scaffold(
          appBar: AppBar(toolbarHeight: 0, automaticallyImplyLeading: false),
          body: RootLayout(
            currentIndex: state.currentIndex,
            child: const RouterOutlet(),
          ),
        ),
      ),
    );
  }
}
