class ResponseNosoApi<T> {
  T? value;
  String? error;

  ResponseNosoApi({
    this.value,
    this.error,
  });

  ResponseNosoApi copyWith({
    T? value,
    String? error,
    int? errorCode,
  }) {
    return ResponseNosoApi(
      value: value ?? this.value,
      error: error ?? this.error,
    );
  }
}
