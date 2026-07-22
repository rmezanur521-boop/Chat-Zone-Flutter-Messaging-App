import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/widgets/app_empty_state.dart';
import '../../../../core/widgets/app_loader.dart';
import '../providers/friends_providers.dart';
import '../widgets/user_list_tile.dart';

class UserSearchPage extends ConsumerStatefulWidget {
  const UserSearchPage({super.key});

  @override
  ConsumerState<UserSearchPage> createState() => _UserSearchPageState();
}

class _UserSearchPageState extends ConsumerState<UserSearchPage> {
  final _controller = TextEditingController();
  final Set<String> _requestedIds = {};

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final searchState = ref.watch(userSearchProvider);

    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _controller,
          autofocus: true,
          decoration: const InputDecoration(
            hintText: 'Search by username',
            border: InputBorder.none,
          ),
          onChanged: (value) =>
              ref.read(userSearchProvider.notifier).search(value),
        ),
      ),
      body: searchState.when(
        loading: () => const AppLoader(),
        error: (e, _) => AppEmptyState(
          icon: Icons.error_outline_rounded,
          title: 'Search failed',
          message: e.toString(),
        ),
        data: (results) {
          if (_controller.text.trim().isEmpty) {
            return const AppEmptyState(
              icon: Icons.search_rounded,
              title: 'Find people',
              message: 'Search by username to send a friend request.',
            );
          }
          if (results.isEmpty) {
            return const AppEmptyState(
              icon: Icons.person_off_outlined,
              title: 'No users found',
              message: 'Try a different username.',
            );
          }
          return ListView.builder(
            itemCount: results.length,
            itemBuilder: (context, i) {
              final user = results[i];
              final alreadyRequested = _requestedIds.contains(user.id);
              return UserListTile(
                user: user,
                trailing: alreadyRequested
                    ? const Text('Requested',
                        style: TextStyle(color: Colors.grey))
                    : IconButton(
                        icon: const Icon(Icons.person_add_alt_1_rounded),
                        onPressed: () async {
                          await ref
                              .read(userSearchProvider.notifier)
                              .sendRequest(user.id);
                          setState(() => _requestedIds.add(user.id));
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
