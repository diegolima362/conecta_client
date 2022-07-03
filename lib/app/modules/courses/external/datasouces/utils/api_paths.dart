import 'package:conecta/main.dart';

const base = devMode
    ? 'http://localhost:8080/api/v1'
    : 'https://calm-thicket-88010.herokuapp.com/api/v1';

const urlMyCourses = '$base/users/me/courses';

const urlCourses = '$base/courses';

const urlRegisterCourse = '$urlCourses/register';

const urlDeleteCourse = urlCourses;

const urlFeed = '$urlCourses/feed';
const urlAssignments = '$base/assignments';
const urlMyAssignments = '$base/users/me/assignments';
const urlSubmissions = '$urlAssignments/submissions';
