import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:modular_triple_bind/modular_triple_bind.dart';

import '../../../main.dart';
import 'domain/usecases/usecases.dart';
import 'external/datasouces/local_datasource.dart';
import 'external/datasouces/remote_datasource.dart';
import 'infra/repositories/courses_repository.dart';
import 'presenter/details/course_details_page.dart';
import 'presenter/details/course_details_store.dart';

class CoursesModule extends Module {
  @override
  final List<Bind> binds = [
    // Hive box
    Bind.lazySingleton<Box>(
      (i) => box,
      export: true,
      onDispose: (b) => b.close(),
    ),

    // repositories
    Bind.lazySingleton((i) => CoursesRepository(i(), i(), i()), export: true),

    // usecases
    Bind.lazySingleton((i) => GetCourses(i()), export: true),
    Bind.lazySingleton((i) => GetCourseById(i())),

    // datasources
    Bind.lazySingleton((i) => CoursesLocalDatasource(i()), export: true),
    Bind.lazySingleton((i) => CoursesRemoteDatasource(i()), export: true),

    // stores
    TripleBind.singleton((i) => CourseDetailsStore(i())),
  ];

  @override
  final List<ModularRoute> routes = [
    ChildRoute(
      '/:id/',
      child: (_, args) => CourseDetailsPage(
        courseId: int.tryParse(args.params['id']) ?? 1,
      ),
      children: [
        ChildRoute(
          '/atividades/',
          child: (_, args) => Container(),
        ),
      ],
    ),
  ];
}
