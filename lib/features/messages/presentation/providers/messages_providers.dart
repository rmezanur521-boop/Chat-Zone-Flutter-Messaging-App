import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/signalr_client.dart';
import '../../../../core/providers/core_providers.dart';
import '../../data/datasources/messages_remote_datasource.dart';
import '../../data/datasources/messages_socket_datasource.dart';
import '../../data/repositories/messages_repository_impl.dart';
import '../../domain/repositories/messages_repository.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import 'chat_notifier.dart';
import 'chat_state.dart';

final messagesRemoteDataSourceProvider =
    Provider<MessagesRemoteDataSource>((ref) {
  return MessagesRemoteDataSource(ref.watch(apiClientProvider));
});

final messagesRepositoryProvider = Provider<MessagesRepository>((ref) {
  return MessagesRepositoryImpl(ref.watch(messagesRemoteDataSourceProvider));
});

// Single, app-wide SignalR connection so all chat screens share one socket.
final signalRClientProvider = Provider<SignalRClient>((ref) => SignalRClient());

final messagesSocketDataSourceProvider =
    Provider<MessagesSocketDataSource>((ref) {
  final ds = MessagesSocketDataSource(ref.watch(signalRClientProvider));
  ref.onDispose(ds.dispose);
  return ds;
});
final chatNotifierProvider =
    StateNotifierProvider.family<ChatNotifier, ChatState, String>(
  (ref, otherUserId) {
    final currentUserId = ref.watch(authNotifierProvider).user?.id ?? '';
    return ChatNotifier(
      repository: ref.watch(messagesRepositoryProvider),
      socket: ref.watch(messagesSocketDataSourceProvider),
      currentUserId: currentUserId,
      otherUserId: otherUserId,
    );
  },
);
