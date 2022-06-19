import 'package:conecta/app/core/presenter/widgets/widgets.dart';
import 'package:conecta/app/modules/courses/domain/entities/entities.dart';
import 'package:flutter/material.dart';

class CourseFeed extends StatelessWidget {
  final CourseEntity course;

  const CourseFeed({super.key, required this.course});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Card(
          margin: const EdgeInsets.all(16),
          child: ListTile(
            title: Text(course.name),
            subtitle: Text(course.professorName),
            trailing: Text(course.code),
          ),
        ),
        const Expanded(
          child: EmptyCollection(
            text: 'Nada por aqui ainda!',
            icon: Icons.content_paste_off_sharp,
          ),
        ),
      ],
    );
  }
}
