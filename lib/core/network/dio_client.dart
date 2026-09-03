import 'dart:convert';
import 'package:http/http.dart' as http;
import '../error/exceptions.dart';
import '../storage/secure_storage_service.dart';

/// Central HTTP client. Every datasource in the app should call
/// through this class instead of using http.* directly, so that
/// auth headers, token refresh, and error handling stay consistent.
class ApiClient {
  final http.Client _client;
  final SecureStorageService _secureStorage;
  final Future<void> Function()? onUnauthorized;
  final Future<bool> Function()? onTokenExpired;

  ApiClient({
    http.Client? client,
    required SecureStorageService secureStorage,
    this.onUnauthorized,
    this.onTokenExpired,
  })  : _client = client ?? http.Client(),
        _secureStorage = secureStorage;

  Future<Map<String, String>> _headers({bool withAuth = true}) async {
    final headers = <String, String>{'Content-Type': 'application/json'};
    if (withAuth) {
      final token = await _secureStorage.getToken();
      if (token != null) {
        headers['Authorization'] = 'Bearer $token';
      }
    }
    return headers;
  }

  Map<String, dynamic> _decode(http.Response response) {
    if (response.body.isEmpty) return {};
    return jsonDecode(response.body) as Map<String, dynamic>;
  }

  /// Maps HTTP status codes to typed exceptions per the API docs
  /// (401 -> Unauthorized, 403 -> Forbidden, 404 -> NotFound, else Server).
  Never _throwForStatus(int statusCode, Map<String, dynamic> body) {
    final message = body['message'] as String? ?? 'Something went wrong.';
    switch (statusCode) {
      case 401:
        throw UnauthorizedException(message);
      case 403:
        throw ForbiddenException(message);
      case 404:
        throw NotFoundException(message);
      default:
        throw ServerException(message, statusCode: statusCode);
    }
  }

  Future<Map<String, dynamic>> _handle(http.Response response) async {
    final decoded = _decode(response);
    final success = decoded['success'] == true;
    if (response.statusCode >= 200 && response.statusCode < 300 && success) {
      return decoded;
    }
    _throwForStatus(response.statusCode, decoded);
  }

  /// Runs [request] once. On a 401 (and only for authenticated calls),
  /// tries a single silent token refresh and retries the request once.
  /// If refresh isn't possible or fails, the session is cleared.
  Future<Map<String, dynamic>> _withAuthRetry(
    Future<http.Response> Function() request, {
    required bool withAuth,
  }) async {
    try {
      final response = await request();
      return await _handle(response);
    } on UnauthorizedException {
      if (!withAuth || onTokenExpired == null) {
        await onUnauthorized?.call();
        rethrow;
      }
      final refreshed = await onTokenExpired!();
      if (!refreshed) {
        await onUnauthorized?.call();
        rethrow;
      }
      final retryResponse = await request();
      return await _handle(retryResponse);
    } on http.ClientException {
      throw NoInternetException();
    }
  }

  Future<Map<String, dynamic>> get(String url, {bool withAuth = true}) {
    return _withAuthRetry(
      () async => _client
          .get(Uri.parse(url), headers: await _headers(withAuth: withAuth))
          .timeout(const Duration(seconds: 30)),
      withAuth: withAuth,
    );
  }

  Future<Map<String, dynamic>> post(
    String url, {
    Map<String, dynamic>? body,
    bool withAuth = true,
  }) {
    return _withAuthRetry(
      () async => _client.post(
        Uri.parse(url),
        headers: await _headers(withAuth: withAuth),
        body: body != null ? jsonEncode(body) : null,
      ),
      withAuth: withAuth,
    );
  }

  Future<Map<String, dynamic>> put(
    String url, {
    Map<String, dynamic>? body,
    bool withAuth = true,
  }) {
    return _withAuthRetry(
      () async => _client.put(
        Uri.parse(url),
        headers: await _headers(withAuth: withAuth),
        body: body != null ? jsonEncode(body) : null,
      ),
      withAuth: withAuth,
    );
  }

  Future<Map<String, dynamic>> delete(String url, {bool withAuth = true}) {
    return _withAuthRetry(
      () async => _client.delete(Uri.parse(url),
          headers: await _headers(withAuth: withAuth)),
      withAuth: withAuth,
    );
  }

  /// Multipart upload — used for profile picture upload.
  Future<Map<String, dynamic>> uploadFile(
    String url, {
    required String fieldName,
    required List<int> bytes,
    required String fileName,
  }) async {
    final token = await _secureStorage.getToken();
    final request = http.MultipartRequest('POST', Uri.parse(url));
    if (token != null) {
      request.headers['Authorization'] = 'Bearer $token';
    }
    request.files.add(
        http.MultipartFile.fromBytes(fieldName, bytes, filename: fileName));

    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);
    return _handle(response);
  }
}
