import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_empty_state.dart';
import '../../../../core/widgets/app_loader.dart';
import '../providers/groups_providers.dart';
import '../widgets/group_tile.dart';
import 'create_group_page.dart';
import 'group_chat_page.dart';

class GroupsPage extends ConsumerWidget {
  const GroupsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final groupsState = ref.watch(groupPreviewsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Groups')),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primaryTeal,
        onPressed: () => Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const CreateGroupPage()),
        ),
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: RefreshIndicator(
        onRefresh: () => ref.read(groupPreviewsProvider.notifier).load(),
        child: groupsState.when(
          loading: () => const AppLoader(),
          error: (e, _) => ListView(children: [
            const SizedBox(height: 60),
            AppEmptyState(
              icon: Icons.wifi_off_rounded,
              title: 'Could not load groups',
              message: e.toString(),
              actionLabel: 'Retry',
              onAction: () => ref.read(groupPreviewsProvider.notifier).load(),
            ),
          ]),
          data: (groups) {
            if (groups.isEmpty) {
              return ListView(children: const [
                SizedBox(height: 60),
                AppEmptyState(
                  icon: Icons.groups_outlined,
                  title: 'No groups yet',
                  message: 'Tap + to create your first group.',
                ),
              ]);
            }
            return ListView.builder(
              itemCount: groups.length,
              itemBuilder: (context, i) {
                final group = groups[i];
                return GroupTile(
                  group: group,
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (_) => GroupChatPage(groupId: group.id)),
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
