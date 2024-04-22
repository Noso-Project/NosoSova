import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:noso_dart/models/noso/gvt.dart';
import 'package:nososova/blocs/gvt_bloc.dart';
import 'package:nososova/ui/common/widgets/empty_list_widget.dart';
import 'package:nososova/ui/common/widgets/loading.dart';
import 'package:nososova/ui/pages/rpc/screen/rpc_settings.dart';
import 'package:nososova/utils/enum.dart';

import '../../../l10n/app_localizations.dart';
import '../../../models/app/gvt_owner.dart';
import '../../config/responsive.dart';
import '../../theme/style/text_style.dart';
import '../../tiles/tile_gvt_my.dart';
import '../../tiles/tile_gvt_owner.dart';

class RpcPage extends StatefulWidget {
  const RpcPage({Key? key}) : super(key: key);

  @override
  State createState() => _RpcPageState();
}

class _RpcPageState extends State<RpcPage> with SingleTickerProviderStateMixin {
  final ScrollController _controller = ScrollController();
  final GlobalKey<_RpcPageState> _keyBloc = GlobalKey();
  late TabController _tabController;
  int selectIndexTab = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          centerTitle: false,
          title: const Text("RPC"),
          elevation: 0,
        ),
        body: BlocBuilder<GvtBloc, GvtState>(
            key: _keyBloc,
            builder: (context, state) {
              if (!Responsive.isMobile(context)) {
                return Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                          flex: 4, child: SafeArea(child: _tabsContent(state))),
                      Container(
                          width: 370,
                          height: double.infinity,
                          color: Theme.of(context).colorScheme.background,
                          child: const RpcSettings())
                    ]);
              }
              return Column(children: [
                const RpcSettings(),
                Expanded(child: _tabsContent(state))
              ]);
            }));
  }

  _tabsContent(GvtState state) {
    return Column(children: [
      const SizedBox(height: 10),
      if (state.statusFetch == ApiStatus.loading)
        const Expanded(child: LoadingWidget()),
      if (state.statusFetch == ApiStatus.error)
        Expanded(
            child:
                EmptyWidget(title: AppLocalizations.of(context)!.errorLoading)),
      if (state.statusFetch == ApiStatus.connected)
        TabBar(
            controller: _tabController,
            indicatorPadding: const EdgeInsets.symmetric(horizontal: 20),
            onTap: (index) {
              setState(() {
                selectIndexTab = index;
              });
            },
            tabs: [
              Tab(
                  child: Text(AppLocalizations.of(context)!.myListGvts,
                      style: selectIndexTab == 0
                          ? AppTextStyles.tabActive
                          : AppTextStyles.tabInActive)),
              Tab(
                  child: Text(AppLocalizations.of(context)!.viewGvtsList,
                      style: selectIndexTab == 1
                          ? AppTextStyles.tabActive
                          : AppTextStyles.tabInActive))
            ]),
      const SizedBox(height: 10),
      if (state.statusFetch == ApiStatus.connected)
        Expanded(
            child: TabBarView(
                controller: _tabController,
                children: [_myGvt(state.myGvts), _listViewGvts(state.gvts)]))
    ]);
  }

  _myGvt(List<Gvt> myGvts) {
    if (myGvts.isEmpty) {
      return EmptyWidget(
        title: AppLocalizations.of(context)!.empty,
        descrpt: AppLocalizations.of(context)!.emptyGvts,
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      controller: _controller,
      padding: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 0.0),
      itemCount: myGvts.length,
      itemBuilder: (context, index) {
        final item = myGvts[index];
        return GvtMyTile(gvt: item);
      },
    );
  }

  _listViewGvts(List<Gvt> gvts) {
    var gvtsOwners = createGvtOwnersList(gvts);
    return ListView.builder(
      shrinkWrap: true,
      controller: _controller,
      padding: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 0.0),
      itemCount: gvtsOwners.length,
      itemBuilder: (context, index) {
        final item = gvtsOwners[index];
        return GvtOwnerTile(gvtOwner: item);
      },
    );
  }

  List<GvtOwner> createGvtOwnersList(List<Gvt> gvts) {
    Map<String, List<Gvt>> gvtMap = {};

    for (var gvt in gvts) {
      if (gvtMap.containsKey(gvt.addressHash)) {
        gvtMap[gvt.addressHash]!.add(gvt);
      } else {
        gvtMap[gvt.addressHash] = [gvt];
      }
    }

    List<GvtOwner> gvtOwners = gvtMap.entries.map((entry) {
      return GvtOwner(
        addressHash: entry.key,
        gvts: entry.value,
      );
    }).toList();

    gvtOwners.sort((a, b) => b.gvts.length.compareTo(a.gvts.length));

    return gvtOwners;
  }
}
