import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/storage/secure_storage_service.dart';
import '../../../../core/providers/core_providers.dart';
import '../../../messages/presentation/pages/inbox_page.dart';
import '../../../messages/presentation/providers/messages_providers.dart';
import '../../../friends/presentation/pages/friends_page.dart';
import '../../../groups/presentation/pages/groups_page.dart';
import '../../../profile/presentation/pages/my_profile_page.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  int _tabIndex = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _connectSocket());
  }

  Future<void> _connectSocket() async {
    final SecureStorageService storage = ref.read(secureStorageProvider);
    final token = await storage.getToken();
    if (token == null) return;
    await ref.read(messagesSocketDataSourceProvider).connect(token);
  }

  @override
  Widget build(BuildContext context) {
    final tabs = const [
      InboxPage(),
      FriendsPage(),
      GroupsPage(),
      MyProfilePage(),
    ];

    return Scaffold(
      body: IndexedStack(index: _tabIndex, children: tabs),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _tabIndex,
        onDestinationSelected: (i) => setState(() => _tabIndex = i),
        destinations: const [
          NavigationDestination(
              icon: Icon(Icons.chat_bubble_outline_rounded), label: 'Chats'),
          NavigationDestination(
              icon: Icon(Icons.people_outline_rounded), label: 'Friends'),
          NavigationDestination(
              icon: Icon(Icons.groups_outlined), label: 'Groups'),
          NavigationDestination(
              icon: Icon(Icons.person_outline_rounded), label: 'Profile'),
        ],
      ),
    );
  }
}

// Placeholder — replaced by real pages in Phase 4 (Friends), Phase 5 (Groups),
// and Phase 6 (Profile).
// class _ComingSoonTab extends StatelessWidget {
//   final String title;
//   const _ComingSoonTab({required this.title});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text(title)),
//       body: Center(child: Text('$title — coming soon')),
//     );
//   }
// }
