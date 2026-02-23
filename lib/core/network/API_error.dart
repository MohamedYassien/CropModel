class APIError {
  final String message;
  final String? code;

  APIError({required this.message, this.code});

  @override
  String toString() {
    return 'APIError{message: $message, code: $code}';
  }
}