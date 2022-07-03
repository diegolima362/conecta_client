import 'package:conecta/app/core/presenter/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_triple/flutter_triple.dart';

import '../../../../core/domain/errors/erros.dart';
import 'feed_store.dart';
import 'widgets/course_feed_header.dart';
import 'widgets/feed_post_card.dart';

class CourseFeed extends StatefulWidget {
  const CourseFeed({super.key});

  @override
  State<CourseFeed> createState() => _CourseFeedState();
}

class _CourseFeedState extends State<CourseFeed> {
  late final FeedStore store;

  @override
  void initState() {
    super.initState();
    store = Modular.get();
    final courseId = int.tryParse(
            Modular.to.path.split('/courses/').last.split('/feed/').first) ??
        0;
    store.getData(courseId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: AnimatedBuilder(
        animation: store.selectState,
        builder: (context, _) => Visibility(
          visible: store.isOwner,
          child: FloatingActionButton(
            tooltip: 'Criar Post',
            onPressed: () {
              Modular.to.pushNamed(
                '/app/courses/${store.state.course.toNullable()?.id ?? 0}/feed/edit/',
                forRoot: true,
              );
            },
            child: const Icon(Icons.add),
          ),
        ),
      ),
      body: ScopedBuilder<FeedStore, AppContentFailure, FeedState>(
        store: store,
        onLoading: (_) => const LoadingIndicator(),
        onError: (_, error) => EmptyCollection.error(message: ''),
        onState: (context, state) {
          final course = state.course.toNullable();

          if (course == null) {
            return const EmptyCollection(
              text: 'Nada por aqui ainda',
              icon: Icons.filter_none_rounded,
            );
          }

          final items = <Widget>[];

          items.add(
            CourseFeedHeader(course: course),
          );

          if (state.feed.isEmpty) {
            items.add(
              const Padding(
                padding: EdgeInsets.only(top: 64.0),
                child: EmptyCollection(
                  text: "Nada por aqui ainda",
                  icon: Icons.feed_outlined,
                ),
              ),
            );
          } else {
            final course = store.state.course.toNullable();
            final url = '/app/courses/${course?.id ?? 0}/feed/details/';
            items.addAll(
              state.feed.map(
                (e) => FeedPostCard(
                  post: e,
                  onTap: () => Modular.to.pushNamed(
                    url,
                    arguments: e,
                    forRoot: true,
                  ),
                ),
              ),
            );
          }

          return ArticleContent(
            child: ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, index) => items[index],
            ),
          );
        },
      ),
    );
  }
}
