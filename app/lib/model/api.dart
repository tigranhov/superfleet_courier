import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:fresh_dio/fresh_dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'mock_storage.dart';

part 'api.g.dart';

final _tokenStorage = SharedPreferencesTokenStorage();

class SharedPreferencesTokenStorage extends TokenStorage<OAuth2Token> {
  static const _tokenKey = 'token';
  static const _refreshTokenKey = 'refreshToken';
  @override
  Future<void> delete() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
    await prefs.remove(_refreshTokenKey);
  }

  @override
  Future<OAuth2Token?> read() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(_tokenKey);
    final refreshToken = prefs.getString(_refreshTokenKey);
    if (token == null || refreshToken == null) {
      return null;
    }
    return OAuth2Token(
      accessToken: token,
      refreshToken: refreshToken,
    );
  }

  @override
  Future<void> write(OAuth2Token token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token.accessToken);
    if (token.refreshToken != null) {
      await prefs.setString(_refreshTokenKey, token.refreshToken!);
    }
  }
}

@Riverpod(keepAlive: true)
class Api extends _$Api {
  late final Fresh<OAuth2Token> _refreshInterceptor;
  var _refreshRetries = 0;

  @override
  Dio build() {
    final dio = Dio(BaseOptions(
      baseUrl: 'https://api-new.superfleet.ai',
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ));
    // DioMock(dio);
    dio.interceptors.add(DioMock());
    dio.interceptors.add(PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        responseBody: true,
        responseHeader: false,
        error: true,
        compact: false,
        maxWidth: 90));
    dio.interceptors.add(InterceptorsWrapper(
      onResponse: (response, handler) {
        print(response.data);
        return handler.next(response);
      },
    ));
    dio.interceptors.add(_refreshInterceptor = Fresh.oAuth2(
        httpClient: dio,
        tokenHeader: (token) {
          print(token.accessToken);
          return {
            'Authorization': 'Bearer ${token.accessToken}',
          };
        },
        tokenStorage: _tokenStorage,
        refreshToken: (token, dio) async {
          if (_refreshRetries > 0) {
            _refreshRetries = 0;
            throw RevokeTokenException();
          }
          _refreshRetries++;
          try {
            final response = await dio.post('/auth/refresh-token',
                data: {'refreshToken': token!.refreshToken});
            return OAuth2Token(
              accessToken: response.data['data']['accessToken'],
              refreshToken: response.data['data']['refreshToken'],
            );
          } catch (_) {
            throw RevokeTokenException();
          }
        }));
    return dio;
  }

  Future<void> updateToken(String accessToken, String refreshToken) async {
    return _refreshInterceptor.setToken(OAuth2Token(
      accessToken: accessToken,
      refreshToken: refreshToken,
    ));
  }
}
