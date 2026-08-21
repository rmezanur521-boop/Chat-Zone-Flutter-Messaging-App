import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/conversation_preview_entity.dart';
import 'messages_providers.dart';

class ConversationPreviewsNotifier
    extends StateNotifier<AsyncValue<List<ConversationPreviewEntity>>> {
  final Ref _ref;
  ConversationPreviewsNotifier(this._ref) : super(const AsyncValue.loading()) {
    load();
  }

  Future<void> load() async {
    state = const AsyncValue.loading();
    try {
      final previews =
          await _ref.read(messagesRepositoryProvider).getPreviews();
      state = AsyncValue.data(previews);
    } on Failure catch (f, st) {
      state = AsyncValue.error(f.message, st);
    }
  }
}

final conversationPreviewsProvider = StateNotifierProvider<
    ConversationPreviewsNotifier,
    AsyncValue<List<ConversationPreviewEntity>>>((ref) {
  return ConversationPreviewsNotifier(ref);
});
