import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:fpdart/fpdart.dart';

import '../../domain/entities/user_info.dart';
import '../../domain/errors/errors.dart';
import '../../infra/datasources/auth_datasource.dart';
import '../../infra/models/user_model.dart';
import 'adapters/secure_storage.dart';
import 'utils/api_paths.dart' as api;

class AuthDatasource implements IAuthDatasource {
  final Dio client;
  final SecureStorage storage;

  Option<UserModel> _user = none();

  AuthDatasource(this.client, this.storage) {
    configureClient();
  }

  Future<void> configureClient() async {
    final user = (await getCurrentUser()).toNullable();

    if (user == null) {
      return;
    }

    client.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          if (!options.path.contains('http')) {
            options.path = '${api.base}${options.path}';
          }

          options.headers['Authorization'] = 'Bearer ${user.accessToken}';

          return handler.next(options);
        },
        onError: (error, handler) async {
          if (error.response?.statusCode == 403) {
            await refreshToken();
          }

          return handler.next(error);
        },
      ),
    );
  }

  @override
  Future<Option<UserModel>> getCurrentUser() async {
    return _user.match(
      (t) => _user,
      () async {
        _user = await storage.getUser();
        return _user;
      },
    );
  }

  Future<Option<String>> refreshToken() async {
    final user = (await getCurrentUser()).toNullable();

    if (user == null) {
      return none();
    }

    try {
      client.interceptors.clear();

      final response = await client.get(
        api.urlRefreshToken,
        options: Options(headers: {
          'Authorization': 'Bearer ${user.refreshToken}',
        }),
      );

      final data = response.data;

      if (response.statusCode != 200) {
        await signInWithUserAndPassword(user.username, user.password);
      }

      final token = data['access_token'] ?? '';
      final refresh = data['refresh_token'] ?? '';

      final u = user.copyWith(
        accessToken: token,
        refreshToken: refresh,
      );

      await storage.saveUser(u);

      await configureClient();

      return some(token);
    } on AuthFailure catch (e) {
      throw ErrorRefreshToken(
        message: 'Erro ao atualizar token: ${e.message}',
      );
    }
  }

  @override
  Option<String> getUserToken() => _user.map((t) => t.accessToken);

  @override
  Future<UserModel> signUp(UserInfo userInfo) async {
    try {
      final options = userInfo.toApiMap();

      final response = await client.post(api.urlSignUp, data: options);

      final data = response.data;

      if (response.statusCode != 201) {
        throw AuthConnectionError(
          message: data['message'] ?? 'Erro na comunicação com o servidor',
        );
      }

      return signInWithUserAndPassword(userInfo.username, userInfo.password);
    } on DioError catch (e) {
      debugPrint(e.response?.data.toString());

      final message = e.response?.data['message'] ?? 'Error ao se cadastrar';

      throw AuthConnectionError(message: message);
    }
  }

  @override
  Future<UserModel> signInWithUserAndPassword(
      String username, String password) async {
    try {
      final formData = FormData.fromMap({
        'username': username,
        'password': password,
      });

      final response = await client.post(api.urlSignIn, data: formData);

      final data = response.data;

      if (response.statusCode != 200) {
        throw ErrorWrongCrendentials(message: 'Usuário ou senha inválidos');
      }

      var accessToken = data['access_token'] ?? '';
      var refreshToken = data['refresh_token'] ?? '';

      final info = await client.get(
        api.urlUserInfo,
        options: Options(headers: {'Authorization': 'Bearer $accessToken'}),
      );

      final loggedUser = UserModel.fromMap(info.data).copyWith(
        accessToken: accessToken,
        refreshToken: refreshToken,
      );

      await storage.saveUser(loggedUser);

      _user = some(loggedUser);

      await configureClient();

      return loggedUser;
    } on DioError catch (e) {
      debugPrint(e.response?.data.toString());
      throw ErrorWrongCrendentials(message: 'Usuário ou senha inválidos');
    }
  }

  @override
  Future<Unit> logout() async {
    client.interceptors.clear();

    await storage.clear();

    _user = none();

    return unit;
  }
}
