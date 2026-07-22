import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/widgets/app_empty_state.dart';
import '../../../../core/widgets/app_loader.dart';
import '../providers/profile_providers.dart';
import '../widgets/profile_header.dart';

class OtherProfilePage extends ConsumerWidget {
  final String userId;
  const OtherProfilePage({super.key, required this.userId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(otherProfileProvider(userId));

    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: profileAsync.when(
        loading: () => const AppLoader(),
        error: (e, _) => AppEmptyState(
          icon: Icons.error_outline_rounded,
          title: 'Could not load profile',
          message: e.toString(),
        ),
        data: (profile) => ListView(
          padding: const EdgeInsets.symmetric(vertical: 24),
          children: [
            ProfileHeader(
              name: profile.userName,
              email: profile.email,
              bio: profile.bio,
              avatarUrl: profile.avatarUrl,
            ),
          ],
        ),
      ),
    );
  }
}
