import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/router/app_router.dart';
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
  late final TextEditingController _searchController;
  bool _showSuggestions = true;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final searchState = ref.watch(userSearchProvider);
    final suggestionsState = ref.watch(suggestedFriendsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Find Friends'),
        elevation: 0,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search by name or username...',
                prefixIcon: const Icon(Icons.search_rounded),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onChanged: (value) {
                setState(() {
                  _showSuggestions = value.trim().isEmpty;
                });
                ref.read(userSearchProvider.notifier).search(value);
              },
            ),
          ),
          Expanded(
            child: _showSuggestions
                ? _buildSuggestionsView(suggestionsState)
                : _buildSearchResultsView(searchState),
          ),
        ],
      ),
    );
  }

  Widget _buildSuggestionsView(AsyncValue<List<dynamic>> suggestionsState) {
    return suggestionsState.when(
      loading: () => const AppLoader(),
      error: (e, _) => ListView(
        children: [
          const SizedBox(height: 60),
          AppEmptyState(
            icon: Icons.wifi_off_rounded,
            title: 'Could not load suggestions',
            message: e.toString(),
          ),
        ],
      ),
      data: (suggestions) {
        if (suggestions.isEmpty) {
          return ListView(
            children: const [
              SizedBox(height: 60),
              AppEmptyState(
                icon: Icons.people_outline_rounded,
                title: 'No suggestions available',
                message: 'Start typing to search for people.',
              ),
            ],
          );
        }
        return ListView.builder(
          itemCount: suggestions.length,
          itemBuilder: (context, index) {
            final user = suggestions[index];
            return UserListTile(
              user: user,
              onTap: () {
                context.push(
                  '${AppRoutes.friendDetails}/${user.id}',
                );
              },
            );
          },
        );
      },
    );
  }

  Widget _buildSearchResultsView(AsyncValue<List<dynamic>> searchState) {
    return searchState.when(
      loading: () => const AppLoader(),
      error: (e, _) => ListView(
        children: [
          const SizedBox(height: 60),
          AppEmptyState(
            icon: Icons.wifi_off_rounded,
            title: 'Search failed',
            message: e.toString(),
          ),
        ],
      ),
      data: (results) {
        if (results.isEmpty) {
          return ListView(
            children: const [
              SizedBox(height: 60),
              AppEmptyState(
                icon: Icons.person_off_outlined,
                title: 'No results found',
                message: 'Try a different search term.',
              ),
            ],
          );
        }
        return ListView.builder(
          itemCount: results.length,
          itemBuilder: (context, index) {
            final user = results[index];
            return UserListTile(
              user: user,
              onTap: () {
                context.push(
                  '${AppRoutes.friendDetails}/${user.id}',
                );
              },
            );
          },
        );
      },
    );
  }
}
