import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/widgets/app_empty_state.dart';
import '../../../../core/widgets/app_loader.dart';
import '../providers/friends_providers.dart';
import '../widgets/friend_request_tile.dart';
import '../widgets/user_list_tile.dart';
import 'user_search_page.dart';

class FriendsPage extends ConsumerStatefulWidget {
  const FriendsPage({super.key});

  @override
  ConsumerState<FriendsPage> createState() => _FriendsPageState();
}

class _FriendsPageState extends ConsumerState<FriendsPage>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final friendsState = ref.watch(friendsListProvider);
    final requestsState = ref.watch(friendRequestsProvider);
    final pendingCount = requestsState.asData?.value.length ?? 0;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Friends'),
        actions: [
          IconButton(
            icon: const Icon(Icons.person_add_alt_1_rounded),
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const UserSearchPage()),
            ),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            const Tab(text: 'All Friends'),
            Tab(
                text:
                    pendingCount > 0 ? 'Requests ($pendingCount)' : 'Requests'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          RefreshIndicator(
            onRefresh: () => ref.read(friendsListProvider.notifier).load(),
            child: friendsState.when(
              loading: () => const AppLoader(),
              error: (e, _) => ListView(children: [
                const SizedBox(height: 60),
                AppEmptyState(
                  icon: Icons.wifi_off_rounded,
                  title: 'Could not load friends',
                  message: e.toString(),
                  actionLabel: 'Retry',
                  onAction: () => ref.read(friendsListProvider.notifier).load(),
                ),
              ]),
              data: (friends) {
                if (friends.isEmpty) {
                  return ListView(children: const [
                    SizedBox(height: 60),
                    AppEmptyState(
                      icon: Icons.people_outline_rounded,
                      title: 'No friends yet',
                      message: 'Tap the add icon above to find people.',
                    ),
                  ]);
                }
                return ListView.builder(
                  itemCount: friends.length,
                  itemBuilder: (context, i) => UserListTile(
                    user: friends[i],
                    trailing: IconButton(
                      icon: const Icon(Icons.person_remove_outlined),
                      onPressed: () =>
                          _confirmRemove(friends[i].id, friends[i].userName),
                    ),
                  ),
                );
              },
            ),
          ),
          RefreshIndicator(
            onRefresh: () => ref.read(friendRequestsProvider.notifier).load(),
            child: requestsState.when(
              loading: () => const AppLoader(),
              error: (e, _) => ListView(children: [
                const SizedBox(height: 60),
                AppEmptyState(
                  icon: Icons.wifi_off_rounded,
                  title: 'Could not load requests',
                  message: e.toString(),
                ),
              ]),
              data: (requests) {
                if (requests.isEmpty) {
                  return ListView(children: const [
                    SizedBox(height: 60),
                    AppEmptyState(
                      icon: Icons.mark_email_read_outlined,
                      title: 'No pending requests',
                      message: 'Friend requests you receive will show up here.',
                    ),
                  ]);
                }
                return ListView.builder(
                  itemCount: requests.length,
                  itemBuilder: (context, i) => FriendRequestTile(
                    request: requests[i],
                    onAccept: () => ref
                        .read(friendRequestsProvider.notifier)
                        .accept(requests[i].requestId),
                    onReject: () => ref
                        .read(friendRequestsProvider.notifier)
                        .reject(requests[i].requestId),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _confirmRemove(String friendId, String name) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Remove friend'),
        content: Text('Remove $name from your friends?'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              ref.read(friendsListProvider.notifier).removeFriend(friendId);
            },
            child: const Text('Remove'),
          ),
        ],
      ),
    );
  }
}
