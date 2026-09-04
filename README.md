# Chat Zone — Flutter Messaging App

A real-time messaging application built with Flutter, backed by an ASP.NET Core 8 API with JWT authentication and SignalR real-time messaging.

## Tech Stack
- **State management:** Riverpod
- **Networking:** `http` package (see `lib/core/network/dio_client.dart` — despite the filename, it wraps `http`, not the `dio` package)
- **Real-time:** `signalr_netcore`
- **Secure storage:** `flutter_secure_storage`
- **Routing:** `go_router`
- **UI/Utilities:** `google_fonts`, `cached_network_image`, `image_picker`, `intl`, `equatable`, `timeago`, `shared_preferences`, `package_info_plus`, `url_launcher`

## Getting Started

1. Install dependencies:
   ```
   flutter pub get
   ```

2. Backend base URL — set in `lib/core/constants/api_constants.dart`. The app currently points at the deployed backend by default:
   ```dart
   static const String baseUrl = 'https://messaging-application-gbvs.onrender.com';
   ```
   No per-platform switching is needed for this URL — it works the same from web, Android, iOS, or a physical device since it's a public HTTPS endpoint.

   To point at a local backend instead for development, swap in the platform-aware version (kept as a comment above the current line in the file):
   ```dart
   static const String baseUrl =
       kIsWeb ? 'http://localhost:5243' : 'http://10.0.2.2:5243';
   ```
   - Web (`kIsWeb`): `http://localhost:5243`
   - Android emulator: `http://10.0.2.2:5243` (`10.0.2.2` is the emulator's alias for the host machine's `localhost`)
   - iOS simulator: use `http://localhost:5243` instead of the Android line above
   - Physical device: use your machine's LAN IP, e.g. `http://192.168.x.x:5243`

3. Run the app:
   ```
   flutter run
   ```

## Project Structure
Feature-first clean architecture. Each feature under `lib/features/` has:
- `domain/` — entities and repository contracts
- `data/` — models, datasources, repository implementations
- `presentation/` — providers (Riverpod), pages, widgets

Shared code lives in `lib/core/` (theme, network, storage, router, reusable widgets).

**Current features:**
- `auth` — login, register, splash/session check, logout
- `home` — landing/home page
- `messages` — inbox (conversation previews), 1:1 chat with SignalR live updates
- `friends` — friend list, requests (incoming/outgoing), user search, friend details
- `groups` — group list, create group, group chat with SignalR live updates, member management
- `profile` — view own/other user profile, edit profile (incl. profile picture)
- `settings` — theme (light/dark/system), about page

## Notes
- API request timeout (`lib/core/network/dio_client.dart`) is set to 30 seconds — increased from an earlier 10 seconds, likely to accommodate cold starts / latency on the deployed Render backend.

## Known assumptions to verify against the live backend
- 1:1 chat SignalR event `ReceiveMessage` in `lib/features/messages/data/datasources/messages_socket_datasource.dart` is still marked `⚠️` for confirming the exact payload shape against the backend hub.
- Group chat uses the `ReceiveGroupMessage` SignalR event (`group_chat_notifier.dart`) — already wired up, but confirm payload shape too if the backend hub changes.
- Other previously-flagged response shapes (friend requests, group detail, profile) have been resolved in the current codebase; only the 1:1 message socket payload still carries the verification warning.