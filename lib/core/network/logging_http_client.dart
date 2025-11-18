import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class LoggingHttpClient extends http.BaseClient {
  LoggingHttpClient(this._inner, {this.enabled = true});

  final http.Client _inner;
  final bool enabled;

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    if (!enabled) {
      return _inner.send(request);
    }

    final stopwatch = Stopwatch()..start();
    debugPrint('➡️  [HTTP] ${request.method} ${request.url}');
    if (request.headers.isNotEmpty) {
      debugPrint('   Headers: ${request.headers}');
    }
    if (request is http.Request && request.body.isNotEmpty) {
      debugPrint('   Body: ${request.body}');
    }

    try {
      final response = await _inner.send(request);
      stopwatch.stop();

      final bytes = await response.stream.toBytes();
      final contentType = response.headers['content-type'] ?? '';
      final isJson = contentType.contains('application/json');
      final bodyPreview = _formatBodyPreview(bytes, isJson);

      debugPrint(
        '⬅️  [HTTP] ${request.method} ${request.url} -> '
        '${response.statusCode} (${stopwatch.elapsedMilliseconds}ms)',
      );
      if (bodyPreview != null) {
        debugPrint('   Response: $bodyPreview');
      }

      final stream = Stream<List<int>>.fromIterable([bytes]);
      return http.StreamedResponse(
        stream,
        response.statusCode,
        contentLength: response.contentLength,
        request: response.request,
        headers: response.headers,
        reasonPhrase: response.reasonPhrase,
        isRedirect: response.isRedirect,
        persistentConnection: response.persistentConnection,
      );
    } catch (error) {
      stopwatch.stop();
      debugPrint(
        '❌ [HTTP] ${request.method} ${request.url} failed '
        'after ${stopwatch.elapsedMilliseconds}ms: $error',
      );
      rethrow;
    }
  }

  String? _formatBodyPreview(List<int> bytes, bool isJson) {
    if (bytes.isEmpty) {
      return null;
    }
    if (isJson) {
      try {
        final decoded = jsonDecode(utf8.decode(bytes));
        return decoded is Map || decoded is List
            ? jsonEncode(decoded)
            : decoded.toString();
      } catch (_) {
        return utf8.decode(bytes, allowMalformed: true);
      }
    }
    final preview = utf8.decode(bytes, allowMalformed: true);
    return preview.length > 500 ? '${preview.substring(0, 500)}…' : preview;
  }

  @override
  void close() {
    _inner.close();
  }
}
