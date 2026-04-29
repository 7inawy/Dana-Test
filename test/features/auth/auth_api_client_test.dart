import 'package:dana/core/errors/exceptions.dart';
import 'package:dana/features/auth/login/data/datasources/auth_api_client.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AuthApiClient.throwIfNotSuccess', () {
    test('does nothing on 2xx', () {
      final client = AuthApiClient(Dio());
      expect(
        () => client.throwIfNotSuccess({'ok': true}, 200, fallback: 'fallback'),
        returnsNormally,
      );
    });

    test('throws ServerException on non-2xx', () {
      final client = AuthApiClient(Dio());
      expect(
        () => client.throwIfNotSuccess({'message': 'bad'}, 400,
            fallback: 'fallback'),
        throwsA(
          isA<ServerException>().having((e) => e.message, 'message', isNotEmpty),
        ),
      );
    });
  });
}

