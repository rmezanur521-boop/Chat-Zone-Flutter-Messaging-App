import 'package:signalr_netcore/signalr_client.dart';

/// Generic wrapper around signalr_netcore's HubConnection.
/// Feature-specific socket datasources (e.g. MessagesSocketDataSource)
/// build on top of this instead of talking to signalr_netcore directly.
class SignalRClient {
  HubConnection? _connection;

  bool get isConnected => _connection?.state == HubConnectionState.Connected;

  Future<void> connect({required String url, required String token}) async {
    if (isConnected) return;
    _connection = HubConnectionBuilder()
        .withUrl(
          url,
          options: HttpConnectionOptions(accessTokenFactory: () async => token),
        )
        .withAutomaticReconnect()
        .build();
    await _connection!.start();
  }

  void on(String eventName, void Function(List<Object?>? args) handler) {
    _connection?.on(eventName, handler);
  }

  void off(String eventName) {
    _connection?.off(eventName);
  }

  Future<void> disconnect() async {
    await _connection?.stop();
    _connection = null;
  }
}
