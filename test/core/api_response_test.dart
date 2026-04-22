import 'package:dana/core/api/api_response.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ApiResponse.unwrapMap', () {
    test('unwraps {response:{data:{...}}}', () {
      final decoded = {
        'response': {
          'data': {'id': '1'},
        },
      };
      expect(ApiResponse.unwrapMap(decoded), {'id': '1'});
    });

    test('unwraps {data:{...}}', () {
      final decoded = {
        'status': true,
        'data': {'id': '1'},
      };
      expect(ApiResponse.unwrapMap(decoded), {'id': '1'});
    });

    test('returns map as-is when no envelope', () {
      final decoded = {'id': '1'};
      expect(ApiResponse.unwrapMap(decoded), {'id': '1'});
    });
  });

  group('ApiResponse.unwrapList', () {
    test('unwraps {response:{data:[...]}}', () {
      final decoded = {
        'response': {
          'data': [
            {'id': '1'},
          ],
        },
      };
      expect(ApiResponse.unwrapList(decoded), [
        {'id': '1'},
      ]);
    });

    test('unwraps {data:[...]}', () {
      final decoded = {
        'status': true,
        'data': [1, 2, 3],
      };
      expect(ApiResponse.unwrapList(decoded), [1, 2, 3]);
    });

    test('returns list as-is when already a list', () {
      expect(ApiResponse.unwrapList([1, 2]), [1, 2]);
    });
  });
}
