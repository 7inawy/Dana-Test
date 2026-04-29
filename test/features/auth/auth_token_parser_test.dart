import 'package:dana/features/auth/login/data/utils/auth_token_parser.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AuthTokenParser.extractAccessToken', () {
    test('extracts from accessToken.access_token', () {
      final decoded = {
        'accessToken': {'access_token': 'abc'},
      };
      expect(AuthTokenParser.extractAccessToken(decoded), 'abc');
    });

    test('extracts from accessToken string', () {
      final decoded = {'accessToken': '  abc  '};
      expect(AuthTokenParser.extractAccessToken(decoded), 'abc');
    });

    test('extracts from token.accessToken.access_token', () {
      final decoded = {
        'token': {
          'accessToken': {'access_token': 'abc'},
        },
      };
      expect(AuthTokenParser.extractAccessToken(decoded), 'abc');
    });

    test('returns null when missing', () {
      expect(AuthTokenParser.extractAccessToken({'x': 1}), isNull);
      expect(AuthTokenParser.extractAccessToken(null), isNull);
    });
  });

  group('AuthTokenParser.extractTempKey', () {
    test('extracts direct tempKey', () {
      expect(AuthTokenParser.extractTempKey({'tempKey': 'k'}), 'k');
    });

    test('extracts direct temp_key', () {
      expect(AuthTokenParser.extractTempKey({'temp_key': 'k'}), 'k');
    });

    test('extracts from token.tempKey', () {
      expect(
        AuthTokenParser.extractTempKey({'token': {'tempKey': 'k'}}),
        'k',
      );
    });

    test('returns null when missing', () {
      expect(AuthTokenParser.extractTempKey({'x': 1}), isNull);
      expect(AuthTokenParser.extractTempKey(null), isNull);
    });
  });
}

