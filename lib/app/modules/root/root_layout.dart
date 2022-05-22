import 'package:conecta/app/core/presenter/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

import 'root_store.dart';

class RootLayout extends StatelessWidget {
  const RootLayout({
    Key? key,
    required this.child,
    required this.currentIndex,
  }) : super(key: key);

  final Widget child;
  final int currentIndex;
  static const _switcherKey = ValueKey('switcherKey');
  static const _navigationRailKey = ValueKey('navigationRailKey');

  @override
  Widget build(BuildContext context) {
    final store = Modular.get<RootStore>();

    return ValueListenableBuilder<RootStoreState>(
      valueListenable: store.selectState,
      builder: (context, state, _) => LayoutBuilder(
        builder: (context, dimens) {
          void onSelected(int index) {
            store.setIndex(index);
            if (index == 0) {
              Modular.to.navigate('/app/home/');
            } else if (index == 1) {
              Modular.to.navigate('/app/mural/');
            } else if (index == 2) {
              Modular.to.navigate('/app/atividades/');
            } else if (index == 3) {
              Modular.to.navigate('/app/preferences/');
            }
          }

          //    return AdaptiveNavigation(
          //   key: _navigationRailKey,
          //   destinations: destinations
          //       .map((e) => NavigationDestination(
          //             icon: e.icon,
          //             label: e.label,
          //           ))
          //       .toList(),
          //   selectedIndex: currentIndex,
          //   onDestinationSelected: onSelected,
          //   child: LayoutSwitcher(key: _switcherKey, child: child),
          // );

          return LayoutSwitcher(key: _switcherKey, child: child);
        },
      ),
    );
  }
}
