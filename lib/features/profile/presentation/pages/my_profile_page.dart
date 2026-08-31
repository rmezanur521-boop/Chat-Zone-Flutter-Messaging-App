import 'package:chat_zone/core/widgets/app_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/theme_provider.dart';
import '../../../../core/widgets/app_empty_state.dart';
import '../../../../core/widgets/app_loader.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../providers/profile_providers.dart';
import '../widgets/profile_header.dart';
import 'edit_profile_page.dart';

class MyProfilePage extends ConsumerStatefulWidget {
  const MyProfilePage({super.key});

  @override
  ConsumerState<MyProfilePage> createState() => _MyProfilePageState();
}

class _MyProfilePageState extends ConsumerState<MyProfilePage> {
  bool _isUploading = false;

  Future<void> _pickAndUpload() async {
    final picker = ImagePicker();
    final picked =
        await picker.pickImage(source: ImageSource.gallery, imageQuality: 80);
    if (picked == null) return;
    setState(() => _isUploading = true);
    final bytes = await picked.readAsBytes();
    final success = await ref
        .read(myProfileProvider.notifier)
        .uploadPicture(bytes, picked.name);
    if (!mounted) return;
    setState(() => _isUploading = false);
    if (!success) {
      AppSnackBar.error(context, 'Failed to upload picture');
    }
  }

  Future<void> _logout() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Log out'),
        content: const Text('Are you sure you want to log out?'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Cancel')),
          TextButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: const Text('Log out')),
        ],
      ),
    );
    if (confirmed != true) return;
    await ref.read(authNotifierProvider.notifier).logout();
    if (!mounted) return;
    context.go(AppRoutes.login);
  }

  @override
  Widget build(BuildContext context) {
    final profileState = ref.watch(myProfileProvider);
    final themeMode = ref.watch(themeProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: profileState.when(
        loading: () => const AppLoader(),
        error: (e, _) => AppEmptyState(
          icon: Icons.error_outline_rounded,
          title: 'Could not load profile',
          message: e.toString(),
          actionLabel: 'Retry',
          onAction: () => ref.read(myProfileProvider.notifier).load(),
        ),
        data: (profile) => ListView(
          padding: const EdgeInsets.symmetric(vertical: 24),
          children: [
            ProfileHeader(
              name: profile.fullName,
              email: profile.email,
              bio: profile.bio,
              avatarUrl: profile.avatarUrl,
              isUploading: _isUploading,
              onAvatarTap: _pickAndUpload,
            ),
            const SizedBox(height: 28),
            ListTile(
              leading:
                  const Icon(Icons.edit_outlined, color: AppColors.primaryTeal),
              title: const Text('Edit profile'),
              trailing: const Icon(Icons.chevron_right_rounded),
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const EditProfilePage()),
              ),
            ),
            SwitchListTile(
              secondary: const Icon(Icons.dark_mode_outlined,
                  color: AppColors.primaryTeal),
              title: const Text('Dark mode'),
              value: themeMode == ThemeMode.dark,
              onChanged: (_) => ref.read(themeProvider.notifier).toggleTheme(),
            ),
            const Divider(height: 32),
            ListTile(
              leading:
                  const Icon(Icons.logout_rounded, color: AppColors.errorRed),
              title: const Text('Log out',
                  style: TextStyle(color: AppColors.errorRed)),
              onTap: _logout,
            ),
          ],
        ),
      ),
    );
  }
}
