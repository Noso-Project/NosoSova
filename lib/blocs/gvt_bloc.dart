import 'package:bloc/bloc.dart';
import 'package:noso_dart/models/noso/gvt.dart';
import 'package:noso_dart/node_request.dart';
import 'package:noso_dart/utils/data_parser.dart';
import 'package:nososova/blocs/events/gvt_events.dart';
import 'package:nososova/blocs/wallet_bloc.dart';
import 'package:nososova/repositories/repositories.dart';

import '../models/address_wallet.dart';
import '../models/responses/response_node.dart';
import '../utils/network_const.dart';

class GvtState {
  final List<Gvt> gvts;
  final List<Gvt> myGvts;
  final ApiStatus statusFetch;

  GvtState({
    List<Gvt>? gvts,
    List<Gvt>? myGvts,
    ApiStatus? statusFetch,
  })  : gvts = gvts ?? [],
        myGvts = myGvts ?? [],
        statusFetch = statusFetch ?? ApiStatus.loading;

  GvtState copyWith({
    List<Gvt>? gvts,
    List<Gvt>? myGvts,
    ApiStatus? statusFetch,
  }) {
    return GvtState(
        gvts: gvts ?? this.gvts,
        myGvts: myGvts ?? this.myGvts,
        statusFetch: statusFetch ?? ApiStatus.loading);
  }
}

class GvtBloc extends Bloc<GvtEvents, GvtState> {
  final WalletBloc walletBloc;
  final Repositories _repositories;

  GvtBloc({
    required Repositories repositories,
    required this.walletBloc,
  })  : _repositories = repositories,
        super(GvtState()) {
    on<LoadGvts>(_fetchGvts);
  }

  factory GvtBloc.create(Repositories repositories, WalletBloc walletBloc) {
    return GvtBloc(
      repositories: repositories,
      walletBloc: walletBloc,
    );
  }

  void _fetchGvts(event, emit) async {
    ResponseNode<List<int>> responseGvts = await _repositories.networkRepository
        .fetchNode(NodeRequest.getGvts, walletBloc.appDataBloc.state.node.seed);

    bool errorParse = false;
    if (responseGvts.errors == null) {
      var gvtsList = DataParser.getGvtList(responseGvts.value);
      errorParse = gvtsList.isEmpty;
      var myGvts = filterGvts(gvtsList, walletBloc.state.wallet.address);
      if (!errorParse) {
        emit(state.copyWith(
            gvts: gvtsList, myGvts: myGvts, statusFetch: ApiStatus.connected));
      }
    }

    if (errorParse || responseGvts.errors != null) {
      emit(state.copyWith(statusFetch: ApiStatus.error));
    }
  }

  List<Gvt> filterGvts(List<Gvt> gvts, List<Address> addressMy) {
    List<String> addressHashes =
        addressMy.map((address) => address.hash).toList();

    return gvts
        .where((gvt) => addressHashes.contains(gvt.addressHash))
        .toList();
  }
}
