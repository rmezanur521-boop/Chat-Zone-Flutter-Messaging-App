import 'dart:async';
import '../../../../core/constants/api_constants.dart';
import '../../../../core/network/signalr_client.dart';
import '../models/message_model.dart';

class MessagesSocketDataSource {
  final SignalRClient _client;
  final _controller = StreamController<MessageModel>.broadcast();

  MessagesSocketDataSource(this._client);

  Stream<MessageModel> get incomingMessages => _controller.stream;
  bool get isConnected => _client.isConnected;

  Future<void> connect(String token) async {
    if (_client.isConnected) return;
    await _client.connect(url: ApiConstants.hubUrl, token: token);
    // ⚠️ Verify the event name and payload shape against the backend hub.
    _client.on('ReceiveMessage', (args) {
      if (args == null || args.isEmpty) return;
      final data = args[0] as Map<String, dynamic>;
      _controller.add(MessageModel.fromJson(data));
    });
  }

  Future<void> disconnect() => _client.disconnect();

  void dispose() => _controller.close();
}
