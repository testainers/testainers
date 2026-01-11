class TestainersException implements Exception {
  final String message;
  final dynamic reason;

  TestainersException(this.message, {this.reason});

  @override
  String toString() => <String>[
        message,
        if (reason != null) reason.toString(),
      ].join('\n');
}
