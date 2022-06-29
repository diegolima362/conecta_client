import 'package:conecta/app/core/domain/extensions/build_context_extensions.dart';
import 'package:conecta/app/core/domain/extensions/datetime_extensions.dart';
import 'package:conecta/app/core/presenter/widgets/widgets.dart';
import 'package:conecta/app/modules/profile/profile_avatar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_triple/flutter_triple.dart';

import '../../../../core/domain/errors/erros.dart';
import '../details/course_details_store.dart';

class CourseFeed extends StatefulWidget {
  const CourseFeed({super.key});

  @override
  State<CourseFeed> createState() => _CourseFeedState();
}

class _CourseFeedState extends State<CourseFeed> {
  late final CourseDetailsStore store;

  @override
  void initState() {
    super.initState();
    store = Modular.get();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Visibility(
        visible: true,
        child: FloatingActionButton(
          tooltip: 'Criar Post',
          onPressed: () {},
          child: const Icon(Icons.add),
        ),
      ),
      body: ScopedBuilder<CourseDetailsStore, AppContentFailure,
          CoursetDetailsState>(
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
            Card(
              child: SizedBox(
                height: 200,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
                      child: Align(
                        alignment: Alignment.topRight,
                        child: RichText(
                          text: TextSpan(
                            text: 'Código: ',
                            style: context.textTheme.titleMedium,
                            children: [
                              TextSpan(
                                text: course.code,
                                style: context.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const Expanded(child: SizedBox(height: 16)),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(24, 0, 0, 0),
                      child: Text(
                        course.name,
                        style: context.textTheme.headlineMedium,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(24, 4, 0, 16),
                      child: Text(
                        course.professorName,
                        style: context.textTheme.titleLarge,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );

          if (state.feed.isEmpty) {
            return const EmptyCollection(
              text: "Nada por aqui ainda",
              icon: Icons.feed_outlined,
            );
          } else {
            items.addAll(
              state.feed.map(
                (e) => Card(
                  margin: const EdgeInsets.all(8.0),
                  color: context.colors.surface,
                  elevation: 2,
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxHeight: 250),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ListTile(
                          leading: ProfileAvatar(
                            name: e.authorName,
                            radius: 25,
                            fontSize: 24,
                          ),
                          title: Text(e.authorName),
                          subtitle: Text(e.creationDate.simpleDate),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
                          child: Text(
                            e.title,
                            maxLines: 3,
                            style: context.textTheme.titleMedium,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
                          child: Text(
                            e.content,
                            maxLines: 3,
                            style: context.textTheme.bodyMedium,
                          ),
                        ),
                        const Divider(),
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(16, 0, 8, 0),
                              child: ProfileAvatar(
                                name: state.user.toNullable()?.name ?? 'A',
                                fontSize: 24,
                                radius: 28,
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: SizedBox(
                                  height: 48,
                                  child: TextField(
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(30.0),
                                      ),
                                      hintText:
                                          "Adicionar comentário para a turma...",
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: IconButton(
                                icon: const Icon(Icons.send),
                                onPressed: () {},
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
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
