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
      debugPrint(
        '⬅️  [HTTP] ${request.method} ${request.url} -> '
        '${response.statusCode} (${stopwatch.elapsedMilliseconds}ms)',
      );
      return response;
    } catch (error) {
      stopwatch.stop();
      debugPrint(
        '❌ [HTTP] ${request.method} ${request.url} failed '
        'after ${stopwatch.elapsedMilliseconds}ms: $error',
      );
      rethrow;
    }
  }

  @override
  void close() {
    _inner.close();
  }
}
