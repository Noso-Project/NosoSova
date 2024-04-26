import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nososova/ui/theme/style/colors.dart';
import 'package:nososova/ui/theme/style/text_style.dart';

import '../blocs/debug_rpc_bloc.dart';
import '../models/debug_rpc.dart';

class DebugWidget extends StatefulWidget {
  const DebugWidget({super.key});

  @override
  State createState() => _DebugWidgetState();
}

class _DebugWidgetState extends State<DebugWidget> {
  final ScrollController _controller = ScrollController();
  StatusReport sourceSelected = StatusReport.ALL;

  _setSourceFilter(StatusReport statusReport) {
    if (mounted) {
      setState(() {
        sourceSelected = statusReport;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
        child: Column(children: [
          Expanded( child:
          Row(children: [
            Container(
              decoration: BoxDecoration(
                color: sourceSelected == StatusReport.ALL
                    ? Theme.of(context).colorScheme.primaryContainer
                    : Theme.of(context).colorScheme.secondaryContainer,
                borderRadius: BorderRadius.circular(8),
              ),
              child: TextButton(
                onPressed: () => _setSourceFilter(StatusReport.ALL),
                child: const Text(
                  'All',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Container(
              decoration: BoxDecoration(
                color: sourceSelected == StatusReport.Node
                    ? Theme.of(context).colorScheme.primaryContainer
                    : Theme.of(context).colorScheme.secondaryContainer,
                borderRadius: BorderRadius.circular(8),
              ),
              child: TextButton(
                onPressed: () => _setSourceFilter(StatusReport.Node),
                child: const Text(
                  'NODE',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Container(
              decoration: BoxDecoration(
                color: sourceSelected == StatusReport.RPC
                    ? Theme.of(context).colorScheme.primaryContainer
                    : Theme.of(context).colorScheme.secondaryContainer,
                borderRadius: BorderRadius.circular(8),
              ),
              child: TextButton(
                onPressed: () => _setSourceFilter(StatusReport.RPC),
                child: const Text(
                  'RPC',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            )
          ])),
          const SizedBox(height: 10),
          BlocBuilder<DebugRPCBloc, DebugRPCState>(builder: (context, state) {
            var listDebug = [];
            if (sourceSelected == StatusReport.ALL) {
              listDebug = state.debugList.reversed.toList();
            } else {
              listDebug = state.debugList.reversed
                  .toList()
                  .where((item) => item.source == sourceSelected)
                  .toList();
            }
            return Expanded(flex:7,child:  ListView.builder(
              shrinkWrap: true,
              controller: _controller,
              padding:
                  const EdgeInsets.symmetric(horizontal: 10.0, vertical: 0.0),
              itemCount: listDebug.length,
              itemBuilder: (context, index) {
                final item = listDebug[index];
                return Row(
                      children: [
                        Text("${item.time}",
                            style: AppTextStyles.infoItemTitle.copyWith(
                                fontSize: 12,
                                color: item.type != DebugType.inform
                                    ? item.type != DebugType.error
                                    ? CustomColors.positiveBalance
                                    : CustomColors.negativeBalance
                                    : Theme.of(context).colorScheme.onSurface)),
                        const SizedBox(width: 5),
                        Text(item.source == StatusReport.Node ? "NODE" : "RPC",
                            style: AppTextStyles.infoItemValue.copyWith(
                                fontSize: 12,
                                color: item.source == StatusReport.Node
                                    ? CustomColors.negativeBalance
                                    : CustomColors.positiveBalance)),
                         SizedBox(width: item.source == StatusReport.Node ? 5 : 15),
                        Text("${item.message}",
                            style: AppTextStyles.infoItemTitle.copyWith(
                                fontSize: 12,
                                color: item.type != DebugType.inform
                                    ? item.type != DebugType.error
                                        ? CustomColors.positiveBalance
                                        : CustomColors.negativeBalance
                                    : Theme.of(context).colorScheme.onSurface))
                      ],
                    );
              },
            ));
          })
        ]));
  }
}
