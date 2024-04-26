import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:noso_dart/models/noso/seed.dart';
import 'package:nososova/ui/common/widgets/custom/shimmer.dart';
import 'package:nososova/ui/common/widgets/item_info_widget.dart';
import 'package:nososova/ui/config/responsive.dart';
import 'package:nososova/ui/theme/decoration/textfield_decoration.dart';
import 'package:nososova/ui/theme/style/colors.dart';
import 'package:nososova/ui/theme/style/text_style.dart';
import 'package:nososova/utils/date_utils.dart';
import 'package:nososova/utils/enum.dart';
import 'package:sovarpc/blocs/noso_network_bloc.dart';

import '../blocs/debug_rpc_bloc.dart';
import '../blocs/network_events.dart';
import '../blocs/rpc_bloc.dart';
import '../blocs/rpc_events.dart';
import '../models/debug_rpc.dart';
import 'debug_widget.dart';

class RpcPage extends StatefulWidget {
  const RpcPage({Key? key}) : super(key: key);

  @override
  State createState() => _RpcPageState();
}

class _RpcPageState extends State<RpcPage> with SingleTickerProviderStateMixin {
  int selectIndexTab = 0;

  final TextEditingController _portController =
      TextEditingController(text: "8080");
  final TextEditingController _ipController =
      TextEditingController(text: "192.168.31.126");
  final TextEditingController _ignoreMethods = TextEditingController();

  @override
  void initState() {
    super.initState();
    _initDataForms();
  }

  _initDataForms() async {
    var blockState = BlocProvider.of<RpcBloc>(context).state;
    var addressSave = blockState.rpcAddress.split(":");
    var ignoreMethods = blockState.ignoreMethods;
    _ipController.text = addressSave[0];
    _portController.text = addressSave[1];
    _ignoreMethods.text = ignoreMethods;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          centerTitle: false,
          title: Text(
            "Logs",
            style: AppTextStyles.dialogTitle.copyWith(
              fontSize: 24,
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.8),
            ),
          ),
          elevation: 0,
        ),
        body: BlocBuilder<RpcBloc, RpcState>(builder: (context, state) {
          _initDataForms();
          return Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: SafeArea(child: _tabsContent())),
                Container(
                    width: 370,
                    height: double.infinity,
                    color: Theme.of(context).colorScheme.background,
                    child: _rpcSettings(state))
              ]);
        }));
  }

  _tabsContent() {
    return Column(
      children: [
        const Expanded(
          flex: 6,
          child: DebugWidget(),
        ),
        _networkWidget()
      ],
    );
  }

  _networkWidget() {
    return BlocBuilder<NosoNetworkBloc, NosoNetworksState>(
        builder: (context, state) {
      var onShimmer = state.statusConnected == StatusConnectNodes.searchNode ||
          state.statusConnected == StatusConnectNodes.sync ||
          state.statusConnected == StatusConnectNodes.consensus;
      return Expanded(
        flex: 4,
        child: Container(
            color: Theme.of(context).colorScheme.surfaceVariant,
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(
                "Noso Network",
                style: AppTextStyles.dialogTitle.copyWith(
                  fontSize: 20,
                  color:
                      Theme.of(context).colorScheme.onSurface.withOpacity(0.8),
                ),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (state.statusConnected ==
                              StatusConnectNodes.searchNode)
                            Container(
                              margin: EdgeInsets.zero,
                              child: ShimmerPro.sized(
                                depth: 16,
                                scaffoldBackgroundColor:
                                    Colors.grey.shade100.withOpacity(0.5),
                                width: 110,
                                borderRadius: 3,
                                height: 16,
                              ),
                            )
                          else
                            Text(
                              state.node.seed.toTokenizer,
                              style: AppTextStyles.walletHash,
                            ),
                        ],
                      )),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      if (state.statusConnected != StatusConnectNodes.error)
                        IconButton(
                            tooltip: "Refresh Network",
                            icon: const Icon(Icons.restart_alt_outlined),
                            onPressed: () {
                              return context
                                  .read<NosoNetworkBloc>()
                                  .add(ReconnectSeed(true));
                            }),
                      IconButton(
                          tooltip: "Change node",
                          icon: const Icon(Icons.navigate_next),
                          onPressed: () {
                            return context
                                .read<NosoNetworkBloc>()
                                .add(ReconnectSeed(false));
                          }),
                      const SizedBox(width: 10)
                    ],
                  ),
                ],
              ),
              if (state.statusConnected != StatusConnectNodes.error) ...[
                ItemInfoWidget(
                    nameItem: "Network Status",
                    value: getNodeDescriptionString(
                        context, state.statusConnected, state.node.seed)),
              ],
              ItemInfoWidget(
                  nameItem: "Current Block",
                  value: state.node.lastblock.toString(),
                  onShimmer: onShimmer),
              ItemInfoWidget(
                  nameItem: "Time",
                  value: DateUtil.getUtcTime(state.node.utcTime),
                  onShimmer: onShimmer),
            ])),
      );
    });
  }

  _otherInfo() {
    return BlocBuilder<NosoNetworkBloc, NosoNetworksState>(
        builder: (context, state) {
      return Expanded(
        flex: 1,
        child: Container(
            color: Theme.of(context).colorScheme.secondaryContainer,
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      Text(
                        "Count Address",
                        style: AppTextStyles.dialogTitle.copyWith(
                          fontSize: 14,
                          color: Theme.of(context)
                              .colorScheme
                              .onSurface
                              .withOpacity(0.8),
                        ),
                      ),
                      Text(
                        "2222",
                        style: AppTextStyles.dialogTitle.copyWith(
                          fontSize: 12,
                          color: Theme.of(context)
                              .colorScheme
                              .onSecondaryContainer
                              .withOpacity(0.8),
                        ),
                      ),
                    ],
                  )
                ])),
      );
    });
  }

  static String getNodeDescriptionString(
    BuildContext context,
    StatusConnectNodes statusConnected,
    Seed seed,
  ) {
    switch (statusConnected) {
      case StatusConnectNodes.error:
        return "Error connection";
      case StatusConnectNodes.searchNode:
        return "Search Node";
      case StatusConnectNodes.sync:
        return "Synchronization";
      case StatusConnectNodes.consensus:
        return "Network verification";
      case StatusConnectNodes.connected:
        return 'Connected (${seed.ping.toString()} ms)';

      default:
        break;
    }

    return "";
  }

  Widget _rpcSettings(RpcState state) {
    return Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 40),
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
                            "${_ipController.text}:${_portController.text}",
                            _ignoreMethods.text));
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
            Text(
              "Ignore methods",
              style: AppTextStyles.infoItemValue.copyWith(
                color: Colors.white.withOpacity(0.8),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
                enabled: !state.rpcRunnable,
                maxLength: 40,
                controller: _ignoreMethods,
                style: AppTextStyles.textField,
                decoration: AppTextFiledDecoration.defaultDecoration(
                    "reset,testmethod,twomethod")),
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
