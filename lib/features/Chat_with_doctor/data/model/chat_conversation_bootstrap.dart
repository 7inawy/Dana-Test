class ChatConversationBootstrap {
  final String parentId;
  final String doctorId;
  final String roomId;

  const ChatConversationBootstrap({
    required this.parentId,
    required this.doctorId,
    required this.roomId,
  });

  static ChatConversationBootstrap? tryParse(dynamic raw) {
    if (raw is Map) {
      final map = Map<String, dynamic>.from(raw);
      final response = map['response'];
      final data = response is Map ? response['data'] : null;
      if (data is Map) {
        final d = Map<String, dynamic>.from(data);
        final parentId = (d['parentId'] ?? '').toString().trim();
        final doctorId = (d['doctorId'] ?? '').toString().trim();
        final roomId = (d['roomId'] ?? '').toString().trim();
        if (parentId.isEmpty || doctorId.isEmpty || roomId.isEmpty) return null;
        return ChatConversationBootstrap(
          parentId: parentId,
          doctorId: doctorId,
          roomId: roomId,
        );
      }
    }
    return null;
  }
}

