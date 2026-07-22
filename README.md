# Chat Zone — Flutter Messaging App

A modern real-time messaging application built with Flutter, backed by an
ASP.NET Core 8 API with JWT authentication and SignalR real-time messaging.

## Tech Stack
- **State management:** Riverpod
- **Networking:** http package
- **Real-time:** signalr_netcore
- **Secure storage:** flutter_secure_storage
- **Routing:** go_router

## Getting Started

1. Install dependencies:
flutter pub get

2. Update the backend base URL in `lib/core/constants/api_constants.dart`:
   - Android Emulator: `https://10.0.2.2:7001`
   - iOS Simulator: `https://localhost:7001`
   - Physical device: use your machine's LAN IP, e.g. `https://192.168.x.x:7001`
3. Run the app:

flutter run


## Project Structure
Feature-first clean architecture. Each feature under `lib/features/` has:
- `domain/` — entities and repository contracts
- `data/` — models, datasources, repository implementations
- `presentation/` — providers (Riverpod), pages, widgets

Shared code lives in `lib/core/` (theme, network, storage, router, reusable widgets).

## Known assumptions to verify against the live backend
- Several response field names (message previews, group detail, friend
  requests, profile) were inferred from the API docs since exact JSON
  shapes weren't specified. Each affected `fromJson()` has a `⚠️` comment
  marking where to check against Swagger.
- SignalR event names: `ReceiveMessage` (1:1) and `ReceiveGroupMessage`
  (group) — confirm against the actual hub implementation.