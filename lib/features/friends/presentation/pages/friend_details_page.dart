import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_avatar.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_loader.dart';
import '../../domain/entities/app_user_entity.dart';
import '../../domain/entities/outgoing_friend_request_entity.dart';
import '../providers/friends_providers.dart';

class FriendDetailsPage extends ConsumerWidget {
  final String userId;
  final bool isFriend;

  const FriendDetailsPage({
    super.key,
    required this.userId,
    this.isFriend = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userState = ref.watch(friendDetailsProvider(userId));
    final requestStatusState = ref.watch(requestStatusProvider(userId))
        as AsyncValue<OutgoingFriendRequestEntity?>;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        elevation: 0,
      ),
      body: userState.when(
        loading: () => const AppLoader(),
        error: (error, _) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline_rounded,
                  size: 64, color: AppColors.errorRed),
              const SizedBox(height: 16),
              Text('Failed to load profile',
                  style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 8),
              Text(error.toString(),
                  style: Theme.of(context).textTheme.bodySmall,
                  textAlign: TextAlign.center),
              const SizedBox(height: 24),
              AppButton(
                onPressed: () {
                  ref.invalidate(friendDetailsProvider(userId));
                },
                label: 'Retry',
              ),
            ],
          ),
        ),
        data: (user) => _buildContent(context, ref, user, requestStatusState),
      ),
    );
  }

  Widget _buildContent(
    BuildContext context,
    WidgetRef ref,
    AppUserEntity user,
    AsyncValue<OutgoingFriendRequestEntity?> requestStatusState,
  ) {
    return SingleChildScrollView(
      child: Column(
        children: [
          _buildProfileHeader(user),
          const SizedBox(height: 32),
          _buildProfileInfo(context, user),
          const SizedBox(height: 32),
          _buildActionButtons(context, ref, user, requestStatusState),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildProfileHeader(AppUserEntity user) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 32),
      decoration: BoxDecoration(
        color: AppColors.primaryTeal.withOpacity(0.1),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
      ),
      child: Column(
        children: [
          AppAvatar(
            imageUrl: user.avatarUrl,
            name: user.fullName,
            radius: 56,
            isOnline: user.isOnline,
          ),
          const SizedBox(height: 16),
          Text(
            user.fullName,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          if (user.isOnline)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                'Online',
                style: TextStyle(
                  color: AppColors.onlineGreen,
                  fontSize: 12,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildProfileInfo(BuildContext context, AppUserEntity user) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (user.email != null) ...[
            _buildInfoRow('Email', user.email!),
            const SizedBox(height: 12),
          ],
          if (user.dateOfBirth != null) ...[
            _buildInfoRow('Birthday',
                '${user.dateOfBirth!.day}/${user.dateOfBirth!.month}/${user.dateOfBirth!.year}'),
            const SizedBox(height: 12),
          ],
          if (user.gender != null && (user.gender ?? '').isNotEmpty) ...[
            _buildInfoRow('Gender', user.gender!),
            const SizedBox(height: 12),
          ],
          if (user.bio != null && (user.bio ?? '').isNotEmpty) ...[
            Text(
              'Bio',
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.slate,
                  ),
            ),
            const SizedBox(height: 4),
            Text(
              user.bio!,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 14,
              color: AppColors.slate,
            ),
          ),
        ),
        Expanded(
          flex: 3,
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons(
    BuildContext context,
    WidgetRef ref,
    AppUserEntity user,
    AsyncValue<OutgoingFriendRequestEntity?> requestStatusState,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          if (isFriend)
            AppButton(
              onPressed: () {
                context.push(
                  '${AppRoutes.chat}/${user.id}',
                  extra: {
                    'userName': user.fullName,
                    'avatarUrl': user.avatarUrl,
                  },
                );
              },
              label: 'Send Message',
              icon: Icons.message_rounded,
            )
          else
            requestStatusState.when(
              loading: () => const SizedBox(
                height: 48,
                child: AppLoader(),
              ),
              error: (_, __) => AppButton(
                onPressed: () {
                  ref
                      .read(requestStatusProvider(user.id).notifier)
                      .sendRequest();
                },
                label: 'Add Friend',
                icon: Icons.person_add_alt_1_rounded,
              ),
              data: (status) {
                if (status != null && status.status == 'pending') {
                  return AppButton(
                    onPressed: null,
                    label: 'Request Sent',
                    icon: Icons.check_rounded,
                  );
                }
                return AppButton(
                  onPressed: () {
                    ref
                        .read(requestStatusProvider(user.id).notifier)
                        .sendRequest();
                  },
                  label: 'Add Friend',
                  icon: Icons.person_add_alt_1_rounded,
                );
              },
            ),
        ],
      ),
    );
  }
}
