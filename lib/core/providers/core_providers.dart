import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../network/dio_client.dart';
import '../storage/secure_storage_service.dart';

final secureStorageProvider = Provider<SecureStorageService>((ref) {
  return SecureStorageService();
});

final apiClientProvider = Provider<ApiClient>((ref) {
  final secureStorage = ref.watch(secureStorageProvider);
  return ApiClient(
    secureStorage: secureStorage,
    onUnauthorized: () async {
      // Clears the stored session; the router's redirect logic
      // (Phase 7) will then bounce the user to the Login page
      // once authNotifierProvider reflects the unauthenticated state.
      await secureStorage.clearSession();
    },
  );
});
