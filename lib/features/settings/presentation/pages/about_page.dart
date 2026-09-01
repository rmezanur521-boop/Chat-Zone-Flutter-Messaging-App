import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/theme/app_colors.dart';

class AboutPage extends StatefulWidget {
  const AboutPage({super.key});

  @override
  State<AboutPage> createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  String _version = '';

  @override
  void initState() {
    super.initState();
    _loadVersion();
  }

  Future<void> _loadVersion() async {
    final info = await PackageInfo.fromPlatform();
    if (!mounted) return;
    setState(() => _version = '${info.version}+${info.buildNumber}');
  }

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not open $url')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('About')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Center(
            child: Column(
              children: [
                const CircleAvatar(
                  radius: 40,
                  backgroundColor: AppColors.primaryTeal,
                  child: Icon(Icons.chat_bubble_rounded,
                      size: 40, color: Colors.white),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Chat Zone',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  _version.isEmpty ? 'Loading version...' : 'Version $_version',
                  style: const TextStyle(color: AppColors.slate),
                ),
              ],
            ),
          ),
          const SizedBox(height: 28),
          const _AboutSectionTitle(title: 'Developer Info'),
          ListTile(
            leading: const Icon(Icons.person_outline_rounded,
                color: AppColors.primaryTeal),
            title: const Text('Mezanur Rahman'),
          ),
          ListTile(
            leading:
                const Icon(Icons.email_outlined, color: AppColors.primaryTeal),
            title: const Text('rmezanur521@gamil.com'),
            onTap: () => _launchUrl('mailto:rmezanur521@gamil.com'),
          ),
          ListTile(
            leading:
                const Icon(Icons.link_rounded, color: AppColors.primaryTeal),
            title: const Text('LinkedIn'),
            onTap: () => _launchUrl(
                'https://www.linkedin.com/in/mezanur-rahaman-6066752b5'),
          ),
          ListTile(
            leading:
                const Icon(Icons.code_rounded, color: AppColors.primaryTeal),
            title: const Text('GitHub'),
            onTap: () => _launchUrl('https://github.com/rmezanur521-boop'),
          ),
          const SizedBox(height: 12),
          const _AboutSectionTitle(title: 'Built With'),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'Flutter, Riverpod, ASP.NET Core, SignalR, Entity Framework Core, SQL Server',
            ),
          ),
          const SizedBox(height: 20),
          const _AboutSectionTitle(title: 'Special Thanks'),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'Thanks to everyone who tested Chat Zone and shared feedback during development.',
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

class _AboutSectionTitle extends StatelessWidget {
  final String title;
  const _AboutSectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
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
