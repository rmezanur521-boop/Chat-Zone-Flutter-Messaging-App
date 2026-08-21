import 'package:signalr_netcore/signalr_client.dart';

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

  Future<Object?> invoke(String methodName, {List<Object>? args}) async {
    if (!isConnected) return null;
    return _connection!.invoke(methodName, args: args ?? []);
  }

  Future<void> send(String methodName, {List<Object>? args}) async {
    if (!isConnected) return;
    await _connection!.send(methodName, args: args ?? []);
  }

  Future<void> disconnect() async {
    await _connection?.stop();
    _connection = null;
  }
}
