import 'package:conecta/app/core/domain/extensions/extensions.dart';
import 'package:conecta/app/core/presenter/widgets/widgets.dart';
import 'package:conecta/app/modules/courses/domain/entities/course_entity.dart';
import 'package:flutter/material.dart';

final courseColors = <Color>[
  Colors.blue.shade100,
  Colors.red.shade100,
  Colors.yellow.shade100,
  Colors.cyan.shade100,
  Colors.green.shade100,
  Colors.orange.shade100,
  Colors.purple.shade100,
  Colors.teal.shade100,
];

class CourseCard extends StatelessWidget {
  final CourseEntity course;
  final VoidCallback? onTap;
  final int index;

  const CourseCard({
    super.key,
    required this.course,
    this.onTap,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: OutlinedCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Container(
                color: courseColors[index % courseColors.length],
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    course.name,
                    style: context.headlineSmall!.copyWith(
                      fontWeight: FontWeight.bold,
                      color: const Color(0xff121212),
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                  ),
                ),
              ),
            ),
            const Divider(height: 0),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Professor',
                    overflow: TextOverflow.ellipsis,
                    style: context.bodySmall,
                    maxLines: 2,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    course.professorName,
                    overflow: TextOverflow.ellipsis,
                    style: context.bodyLarge,
                    maxLines: 2,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
