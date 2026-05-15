import 'package:dio/dio.dart';

/// Runs [onUnauthorized] once for concurrent 401 responses, then forwards the error.
class UnauthorizedInterceptor extends Interceptor {
  UnauthorizedInterceptor({
    required this.onUnauthorized,
    this.excludedPathSuffixes = const [],
  });

  final Future<void> Function()? onUnauthorized;
  final List<String> excludedPathSuffixes;

  static bool _handlingUnauthorized = false;

  static String _requestPath(RequestOptions options) {
    final path = options.uri.path.isNotEmpty ? options.uri.path : options.path;
    return path;
  }

  bool _isExcluded(RequestOptions options) {
    final path = _requestPath(options);
    for (final suffix in excludedPathSuffixes) {
      if (suffix.isEmpty) continue;
      if (path.endsWith(suffix)) return true;
    }
    return false;
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (err.response?.statusCode == 401 && !_isExcluded(err.requestOptions)) {
      if (!_handlingUnauthorized) {
        _handlingUnauthorized = true;
        final future = onUnauthorized?.call();
        if (future != null) {
          future.whenComplete(() {
            _handlingUnauthorized = false;
          });
        } else {
          _handlingUnauthorized = false;
        }
      }
    }
    super.onError(err, handler);
  }
}
