import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/theme_provider.dart';
import '../../../profile/presentation/pages/my_profile_page.dart';
import 'about_page.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  Future<void> _launchMail(BuildContext context, String subject) async {
    final uri = Uri(
      scheme: 'mailto',
      path: 'rmezanur521@gamil.com',
      query: 'subject=${Uri.encodeComponent(subject)}',
    );
    final launched = await launchUrl(uri);
    if (!launched && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not open email app')),
      );
    }
  }

  void _showInfoDialog(BuildContext context, String title, String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(title),
        content: SingleChildScrollView(child: Text(message)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        children: [
          const _SectionHeader(title: 'Account'),
          ListTile(
            leading: const Icon(Icons.person_outline_rounded,
                color: AppColors.primaryTeal),
            title: const Text('My Profile'),
            trailing: const Icon(Icons.chevron_right_rounded),
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const MyProfilePage()),
            ),
          ),
          const Divider(height: 24),
          const _SectionHeader(title: 'Theme'),
          RadioListTile<ThemeMode>(
            secondary: const Icon(Icons.light_mode_outlined,
                color: AppColors.primaryTeal),
            title: const Text('Light'),
            value: ThemeMode.light,
            groupValue: themeMode,
            onChanged: (mode) =>
                ref.read(themeProvider.notifier).setThemeMode(mode!),
          ),
          RadioListTile<ThemeMode>(
            secondary: const Icon(Icons.dark_mode_outlined,
                color: AppColors.primaryTeal),
            title: const Text('Dark'),
            value: ThemeMode.dark,
            groupValue: themeMode,
            onChanged: (mode) =>
                ref.read(themeProvider.notifier).setThemeMode(mode!),
          ),
          RadioListTile<ThemeMode>(
            secondary: const Icon(Icons.brightness_auto_outlined,
                color: AppColors.primaryTeal),
            title: const Text('Auto'),
            subtitle: const Text('Follow device setting'),
            value: ThemeMode.system,
            groupValue: themeMode,
            onChanged: (mode) =>
                ref.read(themeProvider.notifier).setThemeMode(mode!),
          ),
          const Divider(height: 24),
          const _SectionHeader(title: 'Privacy'),
          ListTile(
            leading: const Icon(Icons.privacy_tip_outlined,
                color: AppColors.primaryTeal),
            title: const Text('Privacy Policy'),
            trailing: const Icon(Icons.chevron_right_rounded),
            onTap: () => _showInfoDialog(
              context,
              'Privacy Policy',
              'Chat Zone stores your messages, profile info, and friend '
                  'connections only to provide the messaging service. Your '
                  'data is never sold or shared with third parties.',
            ),
          ),
          const Divider(height: 24),
          const _SectionHeader(title: 'Help & Support'),
          ListTile(
            leading: const Icon(Icons.help_outline_rounded,
                color: AppColors.primaryTeal),
            title: const Text('FAQ'),
            trailing: const Icon(Icons.chevron_right_rounded),
            onTap: () => _showInfoDialog(
              context,
              'FAQ',
              'Q: How do I add a friend?\n'
                  'A: Go to Contacts and use the search icon to find and add people.\n\n'
                  'Q: How do I create a group?\n'
                  'A: Open the three-dot menu on the Chats screen and tap New Group.\n\n'
                  'Q: How do I change the theme?\n'
                  'A: Go to Settings > Theme and pick Light, Dark, or Auto.',
            ),
          ),
          ListTile(
            leading: const Icon(Icons.feedback_outlined,
                color: AppColors.primaryTeal),
            title: const Text('Send Feedback'),
            trailing: const Icon(Icons.chevron_right_rounded),
            onTap: () => _launchMail(context, 'Chat Zone Feedback'),
          ),
          ListTile(
            leading: const Icon(Icons.bug_report_outlined,
                color: AppColors.errorRed),
            title: const Text('Report a bug'),
            trailing: const Icon(Icons.chevron_right_rounded),
            onTap: () => _launchMail(context, 'Chat Zone Bug Report'),
          ),
          const Divider(height: 24),
          const _SectionHeader(title: 'About'),
          ListTile(
            leading: const Icon(Icons.info_outline_rounded,
                color: AppColors.primaryTeal),
            title: const Text('About Chat Zone'),
            trailing: const Icon(Icons.chevron_right_rounded),
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const AboutPage()),
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: AppColors.slate,
        ),
      ),
    );
  }
}
