class SetTransactionsRequest {
  final String hash;
  final int _limit;
  final int _offset;

  SetTransactionsRequest({required this.hash, int? limit, int? offset})
      : _limit = limit ?? 10,
        _offset = offset ?? 0;

  get limit => _limit;

  get offset => _offset;
}
