import 'package:fpdart/fpdart.dart';

import '../entities/entities.dart';
import '../errors/errors.dart';

typedef EitherCourses = Either<CoursesFailure, List<CourseEntity>>;
typedef EitherCourse = Either<CoursesFailure, Option<CourseEntity>>;

typedef EitherAssignments = Either<CoursesFailure, List<AssignmentEntity>>;
typedef EitherAssignment = Either<CoursesFailure, Option<AssignmentEntity>>;

typedef EitherString = Either<CoursesFailure, String>;

typedef EitherUnit = Either<CoursesFailure, Unit>;

typedef EitherRegistrations = Either<CoursesFailure, List<RegistrationEntity>>;
typedef EitherFeed = Either<CoursesFailure, List<PostEntity>>;

typedef EitherSubmission = Either<CoursesFailure, AssignmentSubmissionEntity>;
typedef EitherSubmissions
    = Either<CoursesFailure, List<AssignmentSubmissionEntity>>;
