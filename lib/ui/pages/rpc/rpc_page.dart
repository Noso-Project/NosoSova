import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nososova/blocs/rpc_bloc.dart';
import 'package:nososova/ui/theme/style/colors.dart';

import '../../../blocs/events/rpc_events.dart';
import '../../../l10n/app_localizations.dart';
import '../../config/responsive.dart';
import '../../theme/decoration/textfield_decoration.dart';
import '../../theme/style/text_style.dart';

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

  final TextEditingController _portController =
      TextEditingController(text: "8080");
  final TextEditingController _ipController =
      TextEditingController(text: "192.168.31.126");

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    var addressSave =
        BlocProvider.of<RpcBloc>(context).state.rpcAddress.split(":");
    _ipController.text = addressSave[0];
    _portController.text = addressSave[1];
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
        body: BlocBuilder<RpcBloc, RpcState>(
            key: _keyBloc,
            builder: (context, state) {
              if (!Responsive.isMobile(context)) {
                return Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(flex: 4, child: SafeArea(child: _tabsContent())),
                      Container(
                          width: 370,
                          height: double.infinity,
                          color: Theme.of(context).colorScheme.background,
                          child: _rpcSettings(state))
                    ]);
              }
              return Column(children: [
                _rpcSettings(state),
                Expanded(child: _tabsContent())
              ]);
            }));
  }

  _tabsContent() {
    return Column(children: [
      const SizedBox(height: 10),
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
                child: Text("RPC Logs",
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
      /* if (state.statusFetch == ApiStatus.connected)
        Expanded(
            child: TabBarView(
                controller: _tabController,
                children: [_myGvt(state.myGvts), _listViewGvts(state.gvts)]))*/
    ]);
  }

  /*
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

   */

  Widget _rpcSettings(RpcState state) {
    return Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            Text(
              "Settings",
              style: AppTextStyles.dialogTitle.copyWith(
                fontSize: 28,
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.8),
              ),
            ),
            const SizedBox(height: 40),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "RPC Enable",
                  style: AppTextStyles.dialogTitle.copyWith(
                    color: Colors.white.withOpacity(0.8),
                  ),
                ),
                Switch(
                  value: state.rpcRunnable,
                  onChanged: (value) {
                    setState(() {
                      if (state.rpcRunnable == false) {
                        BlocProvider.of<RpcBloc>(context).add(StartServer(
                            "${_ipController.text}:${_portController.text}"));
                      } else {
                        BlocProvider.of<RpcBloc>(context).add(StopServer());
                      }
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),
            TextField(
                enabled: !state.rpcRunnable,
                maxLength: 15,
                controller: _ipController,
                style: AppTextStyles.textField,
                decoration: AppTextFiledDecoration.defaultDecoration("IP")),
            const SizedBox(height: 20),
            TextField(
                enabled: !state.rpcRunnable,
                maxLength: 4,
                controller: _portController,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
                style: AppTextStyles.textField,
                decoration: AppTextFiledDecoration.defaultDecoration("Port")),
            const SizedBox(height: 20),
            if (state.rpcRunnable)
              Text("RPC is launched, some wallet functions will be limited.\n",
                  style: AppTextStyles.infoItemValue.copyWith(
                    fontSize: 16,
                    color: CustomColors.negativeBalance.withOpacity(0.5),
                  )),
          ],
        ));
  }
}

class CustomTextInputFormatter extends FilteringTextInputFormatter {
  CustomTextInputFormatter() : super.allow(RegExp(r'^[0-9.]*$'));
}
