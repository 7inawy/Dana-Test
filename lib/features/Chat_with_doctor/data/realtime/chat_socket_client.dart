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

  String? _parentId;
  String? _doctorId;

  bool get isConnected => _socket?.connected == true;

  Future<void> connectAndJoin({
    required String doctorId,
    required void Function(JsonMap message) onMessage,
    void Function(Object error)? onError,
  }) async {
    _doctorId = doctorId;

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
    _parentId = user.id.trim();

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
      final p = _parentId;
      final d = _doctorId;
      if (p == null || d == null) return;
      socket.emit('joinRoom', {'parentId': p, 'doctorId': d});
    });

    socket.on('receiveMessage', (data) {
      try {
        final map = (data is Map) ? Map<String, dynamic>.from(data) : null;
        final response = map?['response'];
        final msg = (response is Map) ? response['data'] : null;
        if (msg is Map) onMessage(Map<String, dynamic>.from(msg));
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
    final p = _parentId;
    final d = _doctorId;
    if (socket == null || p == null || d == null) return;

    socket.emit('sendMessage', <String, dynamic>{
      'parentId': p,
      'doctorId': d,
      'message': text,
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

