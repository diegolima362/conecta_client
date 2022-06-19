import 'package:conecta/app/modules/courses/domain/usecases/usecases.dart';
import 'package:conecta/app/modules/courses/presenter/edit/course_edit_page.dart';
import 'package:conecta/app/modules/courses/presenter/edit/course_edit_store.dart';
import 'package:conecta/app/modules/courses/presenter/join/join_store.dart';
import 'package:conecta/app/modules/courses/presenter/registrations/registrations_page.dart';
import 'package:conecta/app/modules/courses/presenter/registrations/registrations_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:modular_triple_bind/modular_triple_bind.dart';

import 'domain/usecases/usecases.dart';
import 'external/datasouces/local_datasource.dart';
import 'external/datasouces/remote_datasource.dart';
import 'infra/repositories/courses_repository.dart';
import 'presenter/details/course_details_page.dart';
import 'presenter/details/course_details_store.dart';
import 'presenter/join/join_page.dart';

class CoursesModule extends Module {
  @override
  final List<Bind> binds = [
    // repositories
    Bind.lazySingleton((i) => CoursesRepository(i(), i(), i()), export: true),

    // usecases
    Bind.lazySingleton((i) => CreateCourse(i()), export: true),
    Bind.lazySingleton((i) => DeleteCourse(i()), export: true),
    Bind.lazySingleton((i) => EditCourse(i()), export: true),
    Bind.lazySingleton((i) => GetCourseById(i()), export: true),
    Bind.lazySingleton((i) => GetCourses(i()), export: true),
    Bind.lazySingleton((i) => JoinCourse(i()), export: true),
    Bind.lazySingleton((i) => GetCourseRegistrations(i()), export: true),

    // datasources
    Bind.lazySingleton((i) => CoursesLocalDatasource(), export: true),
    Bind.lazySingleton((i) => CoursesRemoteDatasource(i()), export: true),

    // stores
    TripleBind.singleton((i) => CourseDetailsStore(i(), i(), i())),
    TripleBind.singleton((i) => CourseEditStore(i(), i(), i())),
    TripleBind.singleton((i) => RegistrationsStore(i())),
    TripleBind.singleton((i) => JoinStore(i())),
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
        ChildRoute(
          '/registrations/',
          child: (_, args) => RegistrationsPage(
            courseId: int.tryParse(args.params['id']) ?? 0,
          ),
        ),
      ],
    ),
    ChildRoute(
      '/edit/:id/',
      child: (_, args) => CourseEditPage(
        courseId: int.tryParse(args.params['id']),
      ),
    ),
    ChildRoute(
      '/join/',
      child: (_, args) => const JointCoursePage(),
    ),
  ];
}
