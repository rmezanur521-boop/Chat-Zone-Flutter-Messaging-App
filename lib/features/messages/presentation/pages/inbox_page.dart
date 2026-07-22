import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/widgets/app_empty_state.dart';
import '../../../../core/widgets/app_loader.dart';
import '../providers/conversation_previews_provider.dart';
import '../widgets/conversation_tile.dart';

class InboxPage extends ConsumerWidget {
  const InboxPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final previewsState = ref.watch(conversationPreviewsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Chats')),
      body: RefreshIndicator(
        onRefresh: () => ref.read(conversationPreviewsProvider.notifier).load(),
        child: previewsState.when(
          loading: () => const AppLoader(),
          error: (error, _) => ListView(
            children: [
              const SizedBox(height: 80),
              AppEmptyState(
                icon: Icons.wifi_off_rounded,
                title: 'Could not load chats',
                message: error.toString(),
                actionLabel: 'Retry',
                onAction: () =>
                    ref.read(conversationPreviewsProvider.notifier).load(),
              ),
            ],
          ),
          data: (previews) {
            if (previews.isEmpty) {
              return ListView(
                children: const [
                  SizedBox(height: 80),
                  AppEmptyState(
                    icon: Icons.chat_bubble_outline_rounded,
                    title: 'No conversations yet',
                    message: 'Start a chat from your friends list.',
                  ),
                ],
              );
            }
            return ListView.separated(
              itemCount: previews.length,
              separatorBuilder: (_, __) => const SizedBox.shrink(),
              itemBuilder: (context, index) {
                final preview = previews[index];
                return ConversationTile(
                  preview: preview,
                  onTap: () => context.push(
                    '${AppRoutes.chat}/${preview.userId}',
                    extra: {
                      'userName': preview.userName,
                      'avatarUrl': preview.avatarUrl
                    },
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
