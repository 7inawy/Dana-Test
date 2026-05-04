import 'dart:async';

import 'package:socket_io_client/socket_io_client.dart' as io;

import '../../../../core/auth/auth_session.dart';
import '../../../../core/config/app_config.dart';
import '../../../auth/login/data/model/user_model.dart';

typedef JsonMap = Map<String, dynamic>;

class ChatSocketClient {
  ChatSocketClient({
    required AuthSession session,
  }) : _session = session;

  final AuthSession _session;
  io.Socket? _socket;

  StreamSubscription? _connectSub;

  String? _userId;
  String? _roomId;

  String? _parentId;
  String? _doctorId;

  bool get isConnected => _socket?.connected == true;

  Future<void> connectAndJoin({
    required String roomId,
    required String parentId,
    required String doctorId,
    required void Function(JsonMap message) onMessage,
    void Function(Object error)? onError,
  }) async {
    _roomId = roomId.trim();
    _parentId = parentId.trim();
    _doctorId = doctorId.trim();

    final jwt = (await _session.token())?.trim();
    if (jwt == null || jwt.isEmpty) {
      onError?.call(StateError('Missing auth token'));
      return;
    }

    final user = UserModel.fromToken(token: jwt);
    if (user.id.trim().isEmpty) {
      onError?.call(StateError('Invalid JWT (missing sub)'));
      return;
    }
    _userId = user.id.trim();

    final socket = io.io(
      AppConfig.socketBaseUrl(),
      io.OptionBuilder()
          .setTransports(['websocket'])
          .enableAutoConnect()
          .setAuth({'token': jwt})
          .build(),
    );

    _socket = socket;

    socket.onConnect((_) {
      final u = _userId;
      final r = _roomId;
      if (u == null || r == null || u.isEmpty || r.isEmpty) return;
      socket.emit('joinRoom', {'userId': u, 'roomId': r});
    });

    socket.on('getMessage', (data) {
      try {
        final map = (data is Map) ? Map<String, dynamic>.from(data) : null;
        if (map == null) return;

        // Backend payload may be either:
        // - direct message map (manual HTML example), or
        // - wrapped response map: { response: { data: {...} } }
        final response = map['response'];
        final msg = (response is Map) ? response['data'] : null;
        if (msg is Map) {
          onMessage(Map<String, dynamic>.from(msg));
          return;
        }
        onMessage(map);
      } catch (e) {
        onError?.call(e);
      }
    });

    socket.onConnectError((e) => onError?.call(e ?? 'connect_error'));
    socket.onError((e) => onError?.call(e ?? 'socket_error'));

    // Keep a tiny hook so we can await connect in UI if needed later.
    _connectSub?.cancel();
    _connectSub = StreamController<void>().stream.listen((_) {});
  }

  void sendText({
    required String text,
    String? clientMessageId,
  }) {
    final socket = _socket;
    final r = _roomId;
    final u = _userId;
    final p = _parentId;
    final d = _doctorId;
    if (socket == null || r == null || u == null || p == null || d == null) return;

    socket.emit('sendMessage', <String, dynamic>{
      'roomId': r,
      'senderId': u,
      'receiverId': d,
      'senderModel': 'Parent',
      'type': 'TEXT',
      'message': text,
      'parentId': p,
      'doctorId': d,
      if (clientMessageId != null) 'clientMessageId': clientMessageId,
    });
  }

  Future<void> dispose() async {
    _connectSub?.cancel();
    _connectSub = null;
    final s = _socket;
    _socket = null;
    if (s != null) {
      s.dispose();
    }
  }
}

