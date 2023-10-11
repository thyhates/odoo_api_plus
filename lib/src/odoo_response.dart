class OdooResponse {
  final Map<dynamic, dynamic> result;
  final int statusCode;
  final String sessionId;

  OdooResponse({
    this.result = const {},
    required this.statusCode,
    required this.sessionId,
  });

  bool get hasError {
    return result['error'] != null;
  }

  Map get error {
    return result['error'];
  }

  String? getErrorMessage() {
    if (hasError) {
      return result['error']['message'];
    }
    return null;
  }

  dynamic getResult() {
    return result['result'];
  }
}
