import 'package:chat_zone/core/widgets/app_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/utils/validators.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_loader.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../friends/presentation/providers/friends_providers.dart';
import '../../../friends/presentation/widgets/user_list_tile.dart';
import '../providers/groups_providers.dart';
import 'group_chat_page.dart';

class CreateGroupPage extends ConsumerStatefulWidget {
  const CreateGroupPage({super.key});

  @override
  ConsumerState<CreateGroupPage> createState() => _CreateGroupPageState();
}

class _CreateGroupPageState extends ConsumerState<CreateGroupPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final Set<String> _selectedIds = {};
  bool _isCreating = false;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _create() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedIds.isEmpty) {
      AppSnackBar.error(context, 'Select at least one member');
      return;
    }
    setState(() => _isCreating = true);
    try {
      final groupId = await ref.read(groupsRepositoryProvider).createGroup(
            name: _nameController.text.trim(),
            memberIds: _selectedIds.toList(),
          );
      ref.read(groupPreviewsProvider.notifier).load();
      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => GroupChatPage(groupId: groupId)),
      );
    } catch (e) {
      if (!mounted) return;
      AppSnackBar.error(context, toString());
    } finally {
      if (mounted) setState(() => _isCreating = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final friendsState = ref.watch(friendsListProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('New Group')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppTextField(
                controller: _nameController,
                label: 'Group name',
                validator: (v) => Validators.required(v, field: 'Group name'),
              ),
              const SizedBox(height: 16),
              const Text('Select members',
                  style: TextStyle(fontWeight: FontWeight.w700)),
              const SizedBox(height: 8),
              Expanded(
                child: friendsState.when(
                  loading: () => const AppLoader(),
                  error: (e, _) => Center(child: Text(e.toString())),
                  data: (friends) {
                    if (friends.isEmpty) {
                      return const Center(
                          child: Text('Add some friends first.'));
                    }
                    return ListView.builder(
                      itemCount: friends.length,
                      itemBuilder: (context, i) {
                        final user = friends[i];
                        final selected = _selectedIds.contains(user.id);
                        return UserListTile(
                          user: user,
                          trailing: Checkbox(
                            value: selected,
                            onChanged: (_) {
                              setState(() {
                                selected
                                    ? _selectedIds.remove(user.id)
                                    : _selectedIds.add(user.id);
                              });
                            },
                          ),
                          onTap: () {
                            setState(() {
                              selected
                                  ? _selectedIds.remove(user.id)
                                  : _selectedIds.add(user.id);
                            });
                          },
                        );
                      },
                    );
                  },
                ),
              ),
              const SizedBox(height: 12),
              AppButton(
                  label: 'Create Group',
                  isLoading: _isCreating,
                  onPressed: _create),
            ],
          ),
        ),
      ),
    );
  }
}
