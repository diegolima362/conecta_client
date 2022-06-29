import 'package:conecta/app/core/external/drivers/shared_prefs.dart';
import 'package:conecta/app/modules/courses/domain/entities/entities.dart';
import 'package:conecta/app/modules/courses/infra/models/course_model.dart';
import 'package:fpdart/fpdart.dart';

import '../../domain/errors/errors.dart';
import '../../domain/repositories/courses_repository.dart';
import '../../domain/types/types.dart';
import '../datasources/courses_datasource.dart';

class CoursesRepository implements ICoursesRepository {
  final ICoursesLocalDatasource localData;
  final ICoursesRemoteDatasource remoteData;
  final SharedPrefs prefsStorage;

  final coursesCache = <CourseEntity>[];
  final assignmentsCache = <AssignmentEntity>[];
  final registrationsCache = <RegistrationEntity>[];

  CoursesRepository(this.localData, this.remoteData, this.prefsStorage);

  Future<bool> get updated async {
    final lastUpdate = await prefsStorage.getLastCoursesUpdate();

    final expireTime = lastUpdate.add(const Duration(hours: 1));

    return DateTime.now().isBefore(expireTime);
  }

  @override
  Future<EitherCourse> getCourseById(int id) async {
    final filtered = coursesCache.filter((t) => t.id == id);

    if (filtered.isNotEmpty) {
      return Right(Option.of(filtered.first));
    } else {
      return Right(Option.none());
    }
  }

  @override
  Future<EitherUnit> createCourse(CourseEntity course) async {
    try {
      await remoteData.createCourse(CourseModel.fromEntity(course));

      return const Right(unit);
    } on CoursesFailure catch (e) {
      return Left(e);
    }
  }

  @override
  Future<EitherCourses> getCourses({String? id, bool cached = true}) async {
    final courses = <CourseEntity>[];

    if (cached) {
      if (coursesCache.isNotEmpty) {
        return Right(coursesCache);
      } else {
        try {
          final result = (await localData.getCourses(id: id));
          courses.addAll(result);
          coursesCache.clear();
          coursesCache.addAll(result);
        } on CoursesFailure catch (e) {
          return Left(e);
        }
      }
    }

    if (courses.isEmpty || !await updated) {
      try {
        if (courses.isEmpty) {
          final result = await remoteData.getCourses(id: id);
          await localData.saveCourses(result);
          courses.addAll(result);

          coursesCache.clear();
          coursesCache.addAll(result);
        } else {
          remoteData.getCourses(id: id).then(
            (r) async {
              coursesCache.clear();

              coursesCache.addAll(r);
              await localData.saveCourses(r);
            },
          );
        }

        await prefsStorage.setLastCoursesUpdate(DateTime.now());
      } on CoursesFailure catch (e) {
        return Left(e);
      }
    }

    return Right(courses);
  }

  @override
  Future<EitherUnit> clearData() async {
    coursesCache.clear();

    await localData.clearData();
    return const Right(unit);
  }

  @override
  Future<EitherUnit> deleteCourse(int courseId) async {
    try {
      await remoteData.deleteCourse(courseId);

      return const Right(unit);
    } on CoursesFailure catch (e) {
      return Left(e);
    }
  }

  @override
  Future<EitherUnit> editCourse(CourseEntity courseEntity) async {
    try {
      await remoteData.editCourse(courseEntity.id, courseEntity.name);

      return const Right(unit);
    } on CoursesFailure catch (e) {
      return Left(e);
    }
  }

  @override
  Future<EitherFeed> getCourseFeed(int courseId) async {
    try {
      final result = await remoteData.getCourseFeed(courseId);

      return Right(result);
    } on CoursesFailure catch (e) {
      return Left(e);
    }
  }

  @override
  Future<EitherRegistrations> getCourseRegistrations(int courseId) async {
    try {
      final result = await remoteData.getCourseRegistrations(courseId);

      return Right(result);
    } on CoursesFailure catch (e) {
      return Left(e);
    }
  }

  @override
  Future<EitherAssignments> getCourseAssignments(int courseId) async {
    try {
      final result = await remoteData.getCourseAssignments(courseId);

      return Right(result);
    } on CoursesFailure catch (e) {
      return Left(e);
    }
  }

  @override
  Future<EitherUnit> joinCourse(String code) async {
    try {
      await remoteData.joinCourse(code);

      return const Right(unit);
    } on CoursesFailure catch (e) {
      return Left(e);
    }
  }

  @override
  Future<EitherUnit> registerStudent(int courseId, int studentId) async {
    try {
      await remoteData.registerStudent(courseId, studentId);

      return const Right(unit);
    } on CoursesFailure catch (e) {
      return Left(e);
    }
  }

  @override
  Future<EitherUnit> removeStudent(int courseId, int registerId) async {
    try {
      await remoteData.removeStudent(courseId, registerId);

      return const Right(unit);
    } on CoursesFailure catch (e) {
      return Left(e);
    }
  }
}
