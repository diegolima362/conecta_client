import 'package:conecta/app/core/domain/extensions/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../widgets/widgets.dart';
import 'course_details_store.dart';

class CourseDetailsPage extends StatelessWidget {
  late final CourseDetailsStore store;

  final int courseId;

  CourseDetailsPage({super.key, required this.courseId}) {
    store = Modular.get();
    store.clear();
    store.getData(courseId);

    jumpToPage(0);
  }

  void jumpToPage(int index) {
    if (index == 0) {
      Modular.to.navigate('/app/courses/$courseId/feed/');
    } else if (index == 1) {
      Modular.to.navigate('/app/courses/$courseId/assignments/');
    } else if (index == 2) {
      Modular.to.navigate('/app/courses/$courseId/registrations/');
    }

    store.jumpToPage(index);
  }

  ButtonStyle? getStyle(BuildContext context, int index) {
    return store.state.page != index
        ? ButtonStyle(
            foregroundColor: MaterialStateProperty.resolveWith(
              (_) => context.colors.outline,
            ),
          )
        : null;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) => Scaffold(
        appBar: AppBar(
          centerTitle: false,
          leading: BackButton(
            onPressed: () => Modular.to.navigate('/app/home/'),
          ),
          title: AnimatedBuilder(
            animation: store.selectState,
            builder: (context, _) {
              final course = store.state.course.toNullable();

              if (course == null) {
                return const SizedBox.shrink();
              }
              return Row(
                mainAxisAlignment: constraints.isMobile
                    ? MainAxisAlignment.start
                    : MainAxisAlignment.center,
                children: [
                  if (!constraints.isMobile) ...[
                    Text(
                      store.state.course.toNullable()?.name ?? '',
                    ),
                    const Expanded(child: SizedBox(width: 16)),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: TextButton.icon(
                        style: getStyle(context, 0),
                        onPressed: () => jumpToPage(0),
                        icon: const Icon(Icons.filter_none_rounded),
                        label: const Text('Mural'),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: TextButton.icon(
                        style: getStyle(context, 1),
                        onPressed: () => jumpToPage(1),
                        icon: const Icon(Icons.assignment_outlined),
                        label: const Text('Atividades'),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: TextButton.icon(
                        style: getStyle(context, 2),
                        onPressed: () => jumpToPage(2),
                        icon: const Icon(Icons.people_alt_outlined),
                        label: const Text('Pessoas'),
                      ),
                    ),
                    const Expanded(child: SizedBox(width: 16)),
                  ] else if (constraints.isMobile && store.state.page != 0)
                    Text(course.name),
                ],
              );
            },
          ),
          actions: [
            AnimatedBuilder(
              animation: store.selectState,
              builder: (context, _) {
                final course = store.state.course.toNullable();
                if (course == null) return const SizedBox.shrink();
                return CourseMenu(
                  owner: store.isOwner,
                  course: course,
                );
              },
            ),
          ],
        ),
        bottomNavigationBar: AnimatedBuilder(
            animation: store.selectState,
            builder: (context, _) {
              final course = store.state.course.toNullable();
              return Visibility(
                visible: constraints.isMobile,
                child: course == null
                    ? const SizedBox.shrink()
                    : NavigationBar(
                        selectedIndex: store.state.page,
                        onDestinationSelected: (i) => jumpToPage(i),
                        destinations: const [
                          NavigationDestination(
                            icon: Icon(Icons.filter_none_rounded),
                            label: 'Mural',
                          ),
                          NavigationDestination(
                            icon: Icon(Icons.assignment_outlined),
                            label: 'Atividades',
                          ),
                          NavigationDestination(
                            icon: Icon(Icons.people_alt_outlined),
                            label: 'Pessoas',
                          ),
                        ],
                      ),
              );
            }),
        body: const RouterOutlet(),
      ),
    );
  }
}
