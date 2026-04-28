import '../../presentation/controller/data/model/message_model.dart';

class AIChatSession {
  final String id;
  final String? conversationId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<Message> messages;

  const AIChatSession({
    required this.id,
    required this.conversationId,
    required this.createdAt,
    required this.updatedAt,
    required this.messages,
  });

  String get title {
    final firstUser = messages.cast<Message?>().firstWhere(
      (m) =>
          m?.sender == MessageSender.user &&
          (m?.text.trim().isNotEmpty ?? false),
      orElse: () => null,
    );
    final t = firstUser?.text.trim() ?? '';
    return t.isEmpty ? 'New chat' : t;
  }

  String get lastPreview {
    if (messages.isEmpty) return '';
    return messages.last.text.trim();
  }

  AIChatSession copyWith({
    String? conversationId,
    DateTime? createdAt,
    DateTime? updatedAt,
    List<Message>? messages,
  }) {
    return AIChatSession(
      id: id,
      conversationId: conversationId ?? this.conversationId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      messages: messages ?? this.messages,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'conversationId': conversationId,
        'createdAt': createdAt.toIso8601String(),
        'updatedAt': updatedAt.toIso8601String(),
        'messages': messages.map((m) => m.toJson()).toList(),
      };

  static AIChatSession fromJson(Map<String, dynamic> json) {
    final createdRaw = (json['createdAt'] ?? '').toString();
    final updatedRaw = (json['updatedAt'] ?? '').toString();
    final createdAt = DateTime.tryParse(createdRaw) ?? DateTime.now();
    final updatedAt = DateTime.tryParse(updatedRaw) ?? createdAt;

    final rawMessages = json['messages'];
    final messages = <Message>[];
    if (rawMessages is List) {
      for (final item in rawMessages) {
        if (item is Map) {
          messages.add(Message.fromJson(item.cast<String, dynamic>()));
        }
      }
    }

    return AIChatSession(
      id: (json['id'] ?? '').toString(),
      conversationId: (json['conversationId'] ?? '').toString().trim().isEmpty
          ? null
          : (json['conversationId']).toString(),
      createdAt: createdAt,
      updatedAt: updatedAt,
      messages: messages,
    );
  }
}

