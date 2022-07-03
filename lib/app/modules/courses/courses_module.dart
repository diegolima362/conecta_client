import 'package:conecta/app/core/presenter/pages/wildcard/not_found_page.dart';
import 'package:conecta/app/modules/courses/domain/usecases/usecases.dart';
import 'package:conecta/app/modules/courses/presenter/assignments/assignment_details_page.dart';
import 'package:conecta/app/modules/courses/presenter/assignments/assignments_page.dart';
import 'package:conecta/app/modules/courses/presenter/assignments/assignments_store.dart';
import 'package:conecta/app/modules/courses/presenter/assignments/submissions/submission_edit_page.dart';
import 'package:conecta/app/modules/courses/presenter/details/course_edit_page.dart';
import 'package:conecta/app/modules/courses/presenter/feed/edit_post_page.dart';
import 'package:conecta/app/modules/courses/presenter/feed/feed_page.dart';
import 'package:conecta/app/modules/courses/presenter/feed/post_details.dart';
import 'package:conecta/app/modules/courses/presenter/registrations/registrations_page.dart';
import 'package:conecta/app/modules/courses/presenter/registrations/registrations_store.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:modular_triple_bind/modular_triple_bind.dart';

import 'domain/usecases/usecases.dart';
import 'external/datasouces/datasources.dart';
import 'infra/repositories/repositories.dart';
import 'presenter/assignments/edit_assignment_page.dart';
import 'presenter/assignments/submissions/submission_details.dart';
import 'presenter/assignments/submissions/submissions_page.dart';
import 'presenter/assignments/submissions/submissions_store.dart';
import 'presenter/details/course_details_page.dart';
import 'presenter/details/course_details_store.dart';
import 'presenter/feed/feed_store.dart';
import 'presenter/registrations/join_page.dart';

class CoursesModule extends Module {
  @override
  final List<Bind> binds = [
    // repositories
    Bind.lazySingleton((i) => CoursesRepository(i(), i(), i()), export: true),
    Bind.lazySingleton((i) => FeedRepository(i()), export: true),
    Bind.lazySingleton((i) => AssignmentsRepository(i(), i(), i()),
        export: true),

    // usecases
    Bind.lazySingleton((i) => CreateCourse(i()), export: true),
    Bind.lazySingleton((i) => DeleteCourse(i()), export: true),
    Bind.lazySingleton((i) => EditCourse(i()), export: true),
    Bind.lazySingleton((i) => GetCourseById(i()), export: true),
    Bind.lazySingleton((i) => GetCourses(i()), export: true),
    Bind.lazySingleton((i) => JoinCourse(i()), export: true),
    Bind.lazySingleton((i) => GetCourseRegistrations(i()), export: true),
    Bind.lazySingleton((i) => GetCourseAssignments(i()), export: true),
    Bind.lazySingleton((i) => GetAssignment(i()), export: true),
    Bind.lazySingleton((i) => GetCourseFeed(i()), export: true),

    // datasources
    Bind.lazySingleton((i) => CoursesLocalDatasource(), export: true),
    Bind.lazySingleton((i) => CoursesRemoteDatasource(i()), export: true),
    Bind.lazySingleton((i) => FeedRemoteDatasource(i()), export: true),
    Bind.lazySingleton((i) => AssignmentsRemoteDatasource(i()), export: true),

    // stores
    TripleBind.singleton(
      (i) => CourseDetailsStore(
        getLoggedUser: i(),
        repository: i(),
      ),
    ),
    TripleBind.singleton(
      (i) => FeedStore(
        getLoggedUser: i(),
        getCourseById: i(),
        feedRepository: i(),
      ),
    ),
    TripleBind.singleton(
      (i) => AssignmentsStore(
        getCourseById: i(),
        getLoggedUser: i(),
        repository: i(),
      ),
    ),
    TripleBind.singleton(
      (i) => RegistrationsStore(
        getLoggedUser: i(),
        repository: i(),
      ),
    ),
    TripleBind.singleton(
      (i) => SubmissionsStore(
        getLoggedUser: i(),
        repository: i(),
        getCourseById: i(),
      ),
    ),
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
          children: [
            ChildRoute(
              '/details/',
              child: (_, args) => PostDetailsPage(post: args.data),
            ),
            ChildRoute(
              '/edit/',
              child: (_, args) => EditPostPage(post: args.data),
            ),
          ],
        ),
        ChildRoute(
          '/assignments/',
          child: (_, args) => const AssignmentsPage(),
          children: [
            ChildRoute(
              '/details/',
              child: (_, args) => AssignmentDetailsPage(
                assignment: args.data[0],
                isOwner: args.data[1],
              ),
            ),
            ChildRoute(
              '/submissions/',
              child: (_, args) => SubmissionsPage(
                assignment: args.data,
              ),
              children: [
                ChildRoute(
                  '/submit/',
                  child: (_, args) => SubmissionEditPage(
                    assignment: args.data[0],
                    submission: args.data[1],
                  ),
                ),
                ChildRoute(
                  '/details/',
                  child: (_, args) => SubmissionDetailsPage(
                    submission: args.data[0],
                    assignment: args.data[1],
                    isOwner: args.data[2],
                  ),
                ),
              ],
            ),
            ChildRoute(
              '/edit/',
              child: (_, args) => EditAssignmentPage(
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
