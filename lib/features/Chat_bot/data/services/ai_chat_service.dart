import 'package:dio/dio.dart';

import '../../../../core/api/api_endpoint.dart';

class AIChatSendResult {
  final String conversationId;
  final String reply;
  final String language;
  final String source;

  const AIChatSendResult({
    required this.conversationId,
    required this.reply,
    required this.language,
    required this.source,
  });
}

class AIChatService {
  final Dio _dio;

  AIChatService(this._dio);

  Future<AIChatSendResult> send({
    required String message,
    String? conversationId,
  }) async {
    final body = <String, dynamic>{
      'message': message,
      if (conversationId != null && conversationId.trim().isNotEmpty)
        'conversationId': conversationId,
    };

    final res = await _dio.post(ApiEndpoint.chatSend, data: body);
    final data = res.data;

    // Expected:
    // { response: { status, message, data: { conversationId, aiResponse: { reply, ... }}}}
    if (data is! Map) {
      throw DioException(
        requestOptions: res.requestOptions,
        response: res,
        error: 'Unexpected response shape',
        type: DioExceptionType.badResponse,
      );
    }

    final responseObj = data['response'];
    if (responseObj is! Map) {
      throw DioException(
        requestOptions: res.requestOptions,
        response: res,
        error: 'Missing response envelope',
        type: DioExceptionType.badResponse,
      );
    }

    final innerData = responseObj['data'];
    if (innerData is! Map) {
      throw DioException(
        requestOptions: res.requestOptions,
        response: res,
        error: 'Missing data in response',
        type: DioExceptionType.badResponse,
      );
    }

    final cid = (innerData['conversationId'] ?? '').toString();
    final aiResponse = innerData['aiResponse'];
    final reply = aiResponse is Map ? (aiResponse['reply'] ?? '').toString() : '';
    final language =
        aiResponse is Map ? (aiResponse['language'] ?? '').toString() : '';
    final source = aiResponse is Map ? (aiResponse['source'] ?? '').toString() : '';

    if (cid.trim().isEmpty || reply.trim().isEmpty) {
      throw DioException(
        requestOptions: res.requestOptions,
        response: res,
        error: 'Invalid AI response payload',
        type: DioExceptionType.badResponse,
      );
    }

    return AIChatSendResult(
      conversationId: cid,
      reply: reply,
      language: language,
      source: source,
    );
  }
}

