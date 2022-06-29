import 'package:conecta/app/core/presenter/pages/wildcard/not_found_page.dart';
import 'package:conecta/app/modules/courses/domain/usecases/usecases.dart';
import 'package:conecta/app/modules/courses/presenter/assignments/assignments_page.dart';
import 'package:conecta/app/modules/courses/presenter/assignments/details/details_page.dart';
import 'package:conecta/app/modules/courses/presenter/edit/course_edit_page.dart';
import 'package:conecta/app/modules/courses/presenter/edit/course_edit_store.dart';
import 'package:conecta/app/modules/courses/presenter/feed/feed_page.dart';
import 'package:conecta/app/modules/courses/presenter/join/join_store.dart';
import 'package:conecta/app/modules/courses/presenter/registrations/registrations_page.dart';
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
    Bind.lazySingleton((i) => GetCourseAssignments(i()), export: true),
    Bind.lazySingleton((i) => GetCourseFeed(i()), export: true),

    // datasources
    Bind.lazySingleton((i) => CoursesLocalDatasource(), export: true),
    Bind.lazySingleton((i) => CoursesRemoteDatasource(i()), export: true),

    // stores
    TripleBind.singleton(
      (i) => CourseDetailsStore(
        getCourse: i(),
        deleteCourse: i(),
        getLoggedUser: i(),
        getFeed: i(),
        getAssignments: i(),
        getRegistrations: i(),
      ),
    ),
    TripleBind.singleton((i) => CourseEditStore(i(), i(), i())),
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
          '/feed/',
          child: (_, args) => const CourseFeed(),
        ),
        ChildRoute(
          '/assignments/',
          child: (_, args) => const AssignmentsPage(),
          children: [
            ChildRoute(
              '/details/',
              child: (_, args) => AssignmentDetailsPage(
                assignment: args.data,
              ),
            ),
          ],
        ),
        ChildRoute(
          '/registrations/',
          child: (_, args) => const RegistrationsPage(),
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
    WildcardRoute(child: (context, args) => const NotFoundPage()),
  ];
}
