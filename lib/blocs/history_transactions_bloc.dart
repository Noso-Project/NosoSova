import 'package:bloc/bloc.dart';
import 'package:noso_rest_api/api_service.dart';
import 'package:noso_rest_api/models/set_history_transactions.dart';
import 'package:noso_rest_api/models/transaction.dart';
import 'package:nososova/blocs/wallet_bloc.dart';
import 'package:nososova/repositories/repositories.dart';

import '../utils/enum.dart';
import 'events/history_transactions_events.dart';

class HistoryTransactionsBState {
  final List<Transaction> transactions;
  final ApiStatus apiStatus;

  HistoryTransactionsBState({
    List<Transaction>? transactions,
    ApiStatus? apiStatus,
  })  : transactions = transactions ?? [],
        apiStatus = apiStatus ?? ApiStatus.loading;

  HistoryTransactionsBState copyWith({
    List<Transaction>? transactions,
    ApiStatus? apiStatus,
  }) {
    return HistoryTransactionsBState(
        transactions: transactions ?? this.transactions,
        apiStatus: apiStatus ?? this.apiStatus);
  }
}

class HistoryTransactionsBloc
    extends Bloc<HistoryTransactionsEvent, HistoryTransactionsBState> {
  final WalletBloc walletBloc;
  final Repositories _repositories;

  HistoryTransactionsBloc({
    required Repositories repositories,
    required this.walletBloc,
  })  : _repositories = repositories,
        super(HistoryTransactionsBState()) {
    on<FetchHistory>(_fetchHistory);
    on<CleanData>(_cleanData);
  }

  factory HistoryTransactionsBloc.create(
      Repositories repositories, WalletBloc walletBloc) {
    return HistoryTransactionsBloc(
      repositories: repositories,
      walletBloc: walletBloc,
    );
  }

  void _fetchHistory(event, emit) async {
    add(CleanData());

    var transactionsResponse = await _repositories.nosoApiService
        .fetchTransactionsHistory(
            SetTransactionsRequest(hash: event.value, limit: 100));

    if (transactionsResponse.value != null) {
      TransactionsHistory transactionHistory =
          (transactionsResponse.value ?? []) as TransactionsHistory;
      emit(state.copyWith(
          transactions: transactionHistory.getAll(),
          apiStatus: ApiStatus.connected));
    } else {
      String error = transactionsResponse.error == null
          ? ":406"
          : "${transactionsResponse.error}:406";
      var errorCode = int.parse(error.split(":")[2]);
      emit(state.copyWith(
          apiStatus: errorCode == 406 ? ApiStatus.connected : ApiStatus.error));
    }
  }

  void _cleanData(event, emit) async {
    emit(state.copyWith(transactions: [], apiStatus: ApiStatus.loading));
  }
}
