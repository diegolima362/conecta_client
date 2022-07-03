import 'package:conecta/app/core/domain/extensions/extensions.dart';
import 'package:conecta/app/modules/courses/domain/entities/entities.dart';
import 'package:flutter/material.dart';

class CourseFeedHeader extends StatelessWidget {
  const CourseFeedHeader({
    Key? key,
    required this.course,
  }) : super(key: key);

  final CourseEntity course;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: SizedBox(
        height: 200,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
                child: Align(
                  alignment: Alignment.topRight,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Código: ',
                        style: context.textTheme.titleMedium,
                      ),
                      SelectableText(
                        course.code,
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
    );
  }
}
