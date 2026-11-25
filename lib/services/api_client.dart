import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:myportofolio_mobile/config.dart';
import 'package:myportofolio_mobile/models/project.dart';

/// Dilempar ketika request API mengembalikan status selain 2xx.
class ApiException implements Exception {
  const ApiException(this.statusCode, this.message);

  final int statusCode;
  final String message;

  /// Pesan yang aman ditampilkan ke pengguna (bukan isi body mentah).
  String get userMessage {
    switch (statusCode) {
      case 400:
        return _firstFieldError() ?? 'Data yang dikirim tidak valid.';
      case 401:
        return 'Sesi login habis. Silakan login lagi.';
      case 403:
        return 'Akun ini tidak punya izin untuk melakukan aksi ini.';
      case 404:
        return 'Data tidak ditemukan.';
      default:
        return 'Terjadi kesalahan pada server ($statusCode).';
    }
  }

  /// Mengambil pesan error pertama dari body 400 DRF,
  /// misalnya {"year": ["Tahun harus antara 2000 dan 2026."]}.
  String? _firstFieldError() {
    try {
      final decoded = jsonDecode(message);
      if (decoded is Map<String, dynamic>) {
        for (final value in decoded.values) {
          if (value is List && value.isNotEmpty) return value.first.toString();
          if (value is String) return value;
        }
      }
    } on FormatException {
      return null;
    }
    return null;
  }

  @override
  String toString() => 'ApiException($statusCode): $message';
}

/// Klien HTTP untuk backend Django REST Framework MyPortfolio.
class ApiClient {
  ApiClient({http.Client? client, this.baseUrl = apiBaseUrl})
    : _client = client ?? http.Client();

  final http.Client _client;
  final String baseUrl;

  Uri _uri(String path) => Uri.parse('$baseUrl$path');

  Future<List<Project>> getProjects() async {
    final response = await _client.get(
      _uri('/api/v1/projects/'),
      headers: const {'Accept': 'application/json'},
    );
    _ensureSuccess(response);

    final decoded = jsonDecode(response.body) as List<dynamic>;
    return decoded
        .map((item) => Project.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  Future<Project> createProject(
    Project project, {
    required String token,
  }) async {
    final response = await _client.post(
      _uri('/api/v1/projects/'),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Token $token',
      },
      body: jsonEncode(project.toJson()),
    );
    _ensureSuccess(response);

    final decoded = jsonDecode(response.body) as Map<String, dynamic>;
    return Project.fromJson(decoded);
  }

  Future<String> obtainToken(String username, String password) async {
    final response = await _client.post(
      _uri('/api/v1/auth/token/'),
      headers: const {
        'Accept': 'application/json',
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({'username': username, 'password': password}),
    );
    _ensureSuccess(response);

    final decoded = jsonDecode(response.body) as Map<String, dynamic>;
    return decoded['token'] as String;
  }

  Future<void> logout({required String token}) async {
    final response = await _client.post(
      _uri('/api/v1/auth/logout/'),
      headers: {'Accept': 'application/json', 'Authorization': 'Token $token'},
    );
    _ensureSuccess(response);
  }

  void _ensureSuccess(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return;
    }
    throw ApiException(response.statusCode, response.body);
  }
}
