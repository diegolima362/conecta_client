import 'package:conecta/app/core/domain/errors/erros.dart';
import 'package:conecta/app/core/domain/extensions/extensions.dart';
import 'package:conecta/app/core/presenter/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_triple/flutter_triple.dart';

import '../feed/feed_page.dart';
import '../registrations/registrations_page.dart';
import '../widgets/widgets.dart';
import 'course_details_store.dart';

class CourseDetailsPage extends StatefulWidget {
  const CourseDetailsPage({Key? key, required this.courseId}) : super(key: key);

  final int courseId;

  @override
  State<CourseDetailsPage> createState() => _CourseDetailsPageState();
}

class _CourseDetailsPageState extends State<CourseDetailsPage> {
  late final CourseDetailsStore store;
  late final PageController pageController;
  late final ValueNotifier<int> currentIndex;

  @override
  void initState() {
    super.initState();

    store = Modular.get();

    store.getData(widget.courseId);

    pageController = PageController();

    currentIndex = ValueNotifier(0);
  }

  @override
  void dispose() {
    pageController.dispose();
    currentIndex.dispose();

    super.dispose();
  }

  void jumpToPage(int index) {
    pageController.jumpToPage(index);
    currentIndex.value = index;
  }

  ButtonStyle? getStyle(int index) {
    return currentIndex.value != index
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
          centerTitle: true,
          title: AnimatedBuilder(
            animation: currentIndex,
            builder: (_, __) => Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (!constraints.isMobile) ...[
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: TextButton.icon(
                      style: getStyle(0),
                      onPressed: () => jumpToPage(0),
                      icon: const Icon(Icons.filter_none_rounded),
                      label: const Text('Mural'),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: TextButton.icon(
                      style: getStyle(1),
                      onPressed: () => jumpToPage(1),
                      icon: const Icon(Icons.assignment_outlined),
                      label: const Text('Atividades'),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: TextButton.icon(
                      style: getStyle(2),
                      onPressed: () => jumpToPage(2),
                      icon: const Icon(Icons.people_alt_outlined),
                      label: const Text('Pessoas'),
                    ),
                  ),
                ],
              ],
            ),
          ),
          actions: [
            AnimatedBuilder(
              animation: store.selectState,
              builder: (context, _) => CourseMenu(owner: store.isOwner),
            ),
          ],
        ),
        bottomNavigationBar: Visibility(
          visible: constraints.isMobile,
          child: AnimatedBuilder(
            animation: currentIndex,
            builder: (_, __) => NavigationBar(
              selectedIndex: currentIndex.value,
              onDestinationSelected: jumpToPage,
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
          ),
        ),
        body: ArticleContent(
          child: ScopedBuilder<CourseDetailsStore, AppContentFailure,
              CoursetDetailsState>(
            store: store,
            onLoading: (_) => const LoadingIndicator(),
            onError: (_, error) =>
                EmptyCollection.error(message: error?.message),
            onState: (context, state) {
              final course = state.course.toNullable();
              if (course == null) {
                return const EmptyCollection(
                  text: 'Nada por aqui!',
                  icon: Icons.error_outline_sharp,
                );
              }

              return PageView(
                controller: pageController,
                children: [
                  CourseFeed(course: course),
                  Container(color: Colors.red),
                  RegistrationsPage(courseId: course.id),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
