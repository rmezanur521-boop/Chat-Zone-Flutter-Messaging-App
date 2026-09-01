import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_avatar.dart';
import '../../../../core/widgets/app_empty_state.dart';
import '../../../../core/widgets/app_loader.dart';
import '../../../friends/domain/entities/app_user_entity.dart';
import '../../../friends/presentation/pages/friends_page.dart';
import '../../../friends/presentation/providers/friends_providers.dart';
import '../../../groups/domain/entities/group_preview_entity.dart';
import '../../../groups/presentation/pages/create_group_page.dart';
import '../../../groups/presentation/pages/group_chat_page.dart';
import '../../../groups/presentation/providers/groups_providers.dart';
import '../../../settings/presentation/pages/about_page.dart';
import '../../../settings/presentation/pages/settings_page.dart';
import '../providers/conversation_previews_provider.dart';
import '../widgets/conversation_tile.dart';

class InboxPage extends ConsumerStatefulWidget {
  const InboxPage({super.key});

  @override
  ConsumerState<InboxPage> createState() => _InboxPageState();
}

class _InboxPageState extends ConsumerState<InboxPage> {
  bool _isSearching = false;
  String _query = '';
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _toggleSearch() {
    setState(() {
      _isSearching = !_isSearching;
      _query = '';
      _searchController.clear();
    });
  }

  void _handleMenuSelection(String value) {
    switch (value) {
      case 'new_group':
        Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const CreateGroupPage()),
        );
        break;
      case 'contacts':
        Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const FriendsPage()),
        );
        break;
      case 'settings':
        Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const SettingsPage()),
        );
        break;
      case 'about':
        Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const AboutPage()),
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _isSearching
            ? TextField(
                controller: _searchController,
                autofocus: true,
                decoration: const InputDecoration(
                  hintText: 'Search conversations...',
                  border: InputBorder.none,
                ),
                onChanged: (value) => setState(() => _query = value),
              )
            : const Text('Chat Zone'),
        actions: [
          IconButton(
            icon:
                Icon(_isSearching ? Icons.close_rounded : Icons.search_rounded),
            onPressed: _toggleSearch,
          ),
          if (!_isSearching)
            PopupMenuButton<String>(
              onSelected: _handleMenuSelection,
              itemBuilder: (context) => const [
                PopupMenuItem(value: 'new_group', child: Text('New Group')),
                PopupMenuItem(value: 'contacts', child: Text('Contacts')),
                PopupMenuItem(value: 'settings', child: Text('Settings')),
                PopupMenuItem(value: 'about', child: Text('About')),
              ],
            ),
        ],
      ),
      body: _isSearching && _query.trim().isNotEmpty
          ? _SearchResultsView(query: _query.trim())
          : _ConversationsView(),
    );
  }
}

class _ConversationsView extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final previewsState = ref.watch(conversationPreviewsProvider);

    return RefreshIndicator(
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
    );
  }
}

class _SearchResultsView extends ConsumerWidget {
  final String query;
  const _SearchResultsView({required this.query});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final friendsState = ref.watch(friendsListProvider);
    final groupsState = ref.watch(groupPreviewsProvider);

    final lowerQuery = query.toLowerCase();

    final List<AppUserEntity> matchedFriends =
        friendsState.asData?.value.where((friend) {
              return friend.fullName.toLowerCase().contains(lowerQuery) ||
                  friend.userName.toLowerCase().contains(lowerQuery);
            }).toList() ??
            [];

    final List<GroupPreviewEntity> matchedGroups =
        groupsState.asData?.value.where((group) {
              return group.name.toLowerCase().contains(lowerQuery);
            }).toList() ??
            [];

    final isLoading = friendsState.isLoading || groupsState.isLoading;

    if (isLoading && matchedFriends.isEmpty && matchedGroups.isEmpty) {
      return const AppLoader();
    }

    if (matchedFriends.isEmpty && matchedGroups.isEmpty) {
      return const AppEmptyState(
        icon: Icons.search_off_rounded,
        title: 'No results found',
        message: 'Try a different name.',
      );
    }

    return ListView(
      children: [
        if (matchedFriends.isNotEmpty) ...[
          const _SearchSectionLabel(title: 'Friends'),
          ...matchedFriends.map(
            (friend) => ListTile(
              leading:
                  AppAvatar(imageUrl: friend.avatarUrl, name: friend.fullName),
              title: Text(friend.fullName),
              subtitle: Text('@${friend.userName}'),
              onTap: () => context.push(
                '${AppRoutes.chat}/${friend.id}',
                extra: {
                  'userName': friend.fullName,
                  'avatarUrl': friend.avatarUrl,
                },
              ),
            ),
          ),
        ],
        if (matchedGroups.isNotEmpty) ...[
          const _SearchSectionLabel(title: 'Groups'),
          ...matchedGroups.map(
            (group) => ListTile(
              leading: AppAvatar(imageUrl: group.avatarUrl, name: group.name),
              title: Text(group.name),
              subtitle: Text('${group.memberCount} members'),
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(
                    builder: (_) => GroupChatPage(groupId: group.id)),
              ),
            ),
          ),
        ],
      ],
    );
  }
}

class _SearchSectionLabel extends StatelessWidget {
  final String title;
  const _SearchSectionLabel({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: AppColors.slate,
        ),
      ),
    );
  }
}
