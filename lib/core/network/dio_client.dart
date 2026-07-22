import 'dart:convert';
import 'package:http/http.dart' as http;
import '../error/exceptions.dart';
import '../storage/secure_storage_service.dart';

/// Central HTTP client. Every datasource in the app should call
/// through this class instead of using http.* directly, so that
/// auth headers and error handling stay consistent everywhere.
class ApiClient {
  final http.Client _client;
  final SecureStorageService _secureStorage;
  final Future<void> Function()? onUnauthorized;

  ApiClient({
    http.Client? client,
    required SecureStorageService secureStorage,
    this.onUnauthorized,
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
        onUnauthorized?.call();
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

  Future<Map<String, dynamic>> get(String url, {bool withAuth = true}) async {
    try {
      final response = await _client.get(Uri.parse(url),
          headers: await _headers(withAuth: withAuth));
      return _handle(response);
    } on http.ClientException {
      throw NoInternetException();
    }
  }

  Future<Map<String, dynamic>> post(
    String url, {
    Map<String, dynamic>? body,
    bool withAuth = true,
  }) async {
    try {
      final response = await _client.post(
        Uri.parse(url),
        headers: await _headers(withAuth: withAuth),
        body: body != null ? jsonEncode(body) : null,
      );
      return _handle(response);
    } on http.ClientException {
      throw NoInternetException();
    }
  }

  Future<Map<String, dynamic>> put(
    String url, {
    Map<String, dynamic>? body,
    bool withAuth = true,
  }) async {
    try {
      final response = await _client.put(
        Uri.parse(url),
        headers: await _headers(withAuth: withAuth),
        body: body != null ? jsonEncode(body) : null,
      );
      return _handle(response);
    } on http.ClientException {
      throw NoInternetException();
    }
  }

  Future<Map<String, dynamic>> delete(String url,
      {bool withAuth = true}) async {
    try {
      final response = await _client.delete(Uri.parse(url),
          headers: await _headers(withAuth: withAuth));
      return _handle(response);
    } on http.ClientException {
      throw NoInternetException();
    }
  }

  /// Multipart upload — used for profile picture upload.
  Future<Map<String, dynamic>> uploadFile(
    String url, {
    required String fieldName,
    required String filePath,
  }) async {
    final token = await _secureStorage.getToken();
    final request = http.MultipartRequest('POST', Uri.parse(url));
    if (token != null) {
      request.headers['Authorization'] = 'Bearer $token';
    }
    request.files.add(await http.MultipartFile.fromPath(fieldName, filePath));

    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);
    return _handle(response);
  }
}
