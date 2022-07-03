import 'package:conecta/main.dart';

const base = devMode
    ? 'http://localhost:8080/api/v1'
    : 'https://calm-thicket-88010.herokuapp.com/api/v1';

const urlSignIn = '$base/login';

const urlSignUp = '$base/register';

const urlRefreshToken = '$base/token/refresh';

const urlUserInfo = '$base/users/me';
