import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import '../constants/api_constants.dart';
import '../network/dio_client.dart';
import '../storage/secure_storage_service.dart';

final secureStorageProvider = Provider<SecureStorageService>((ref) {
  return SecureStorageService();
});

// Plain HTTP call, deliberately not routed through ApiClient, so a failed
// refresh never re-triggers ApiClient's own 401-retry logic (infinite loop).
Future<bool> _refreshSession(SecureStorageService secureStorage) async {
  final refreshToken = await secureStorage.getRefreshToken();
  if (refreshToken == null || refreshToken.isEmpty) return false;

  try {
    final response = await http.post(
      Uri.parse(ApiConstants.refreshToken),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'refreshToken': refreshToken}),
    );

    if (response.statusCode < 200 || response.statusCode >= 300) return false;

    final decoded = jsonDecode(response.body) as Map<String, dynamic>;
    if (decoded['success'] != true) return false;

    final data = decoded['data'] as Map<String, dynamic>;
    final newToken = data['token']?.toString();
    final newRefreshToken = data['refreshToken']?.toString();
    if (newToken == null || newToken.isEmpty) return false;
    if (newRefreshToken == null || newRefreshToken.isEmpty) return false;

    await secureStorage.updateTokens(
      token: newToken,
      refreshToken: newRefreshToken,
    );
    return true;
  } catch (_) {
    return false;
  }
}

final apiClientProvider = Provider<ApiClient>((ref) {
  final secureStorage = ref.watch(secureStorageProvider);
  return ApiClient(
    secureStorage: secureStorage,
    onTokenExpired: () => _refreshSession(secureStorage),
    onUnauthorized: () async {
      // Refresh failed or wasn't possible — clear the stored session;
      // the router's redirect logic will bounce the user to Login once
      // authNotifierProvider reflects the unauthenticated state.
      await secureStorage.clearSession();
    },
  );
});
