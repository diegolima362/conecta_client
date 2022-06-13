import 'package:flutter/material.dart';

import '../../domain/entities/entities.dart';

class CourseHomeCard extends StatelessWidget {
  final CourseEntity course;
  final int weekDay;
  final VoidCallback? onTap;
  final VoidCallback? onAddAlert;
  final bool showCurrentClass;

  const CourseHomeCard({
    Key? key,
    required this.course,
    required this.weekDay,
    this.onTap,
    this.onAddAlert,
    this.showCurrentClass = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final textTheme = theme.textTheme;

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(course.name, style: textTheme.bodyLarge),
                        Text(course.professor, style: textTheme.bodyMedium),
                      ],
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(left: 8.0),
                    child: Icon(
                      Icons.timelapse,
                      size: 24,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
