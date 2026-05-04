import 'package:dio/dio.dart';

import '../../../../core/api/api_endpoint.dart';

class DoctorChatService {
  final Dio dio;

  DoctorChatService(this.dio);

  Future<Response> createParentConversationByBooking({
    required String bookingId,
  }) {
    return dio.post(
      ApiEndpoint.chatCreateParentConversationByBooking(bookingId),
      options: Options(headers: {'Content-Type': 'application/json'}),
    );
  }

  Future<Response> getMessagesByRoom({required String roomId}) {
    return dio.get(ApiEndpoint.chatMessagesByRoom(roomId));
  }

  Future<Response> checkRoom({
    required String userId,
    required String roomId,
  }) {
    return dio.get(ApiEndpoint.chatCheckRoom(userId: userId, roomId: roomId));
  }
}

