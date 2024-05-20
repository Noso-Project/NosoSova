import 'package:flutter/material.dart';
import 'package:sovarpc/screens/network_widget.dart';
import 'package:sovarpc/screens/settings_widget.dart';

import 'debug_widget.dart';

class RpcPage extends StatefulWidget {
  const RpcPage({super.key});

  @override
  State createState() => _RpcPageState();
}

class _RpcPageState extends State<RpcPage> with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        extendBodyBehindAppBar: true,
        appBar: null,
        body: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Expanded(
                  child: Column(
                children: [
                  Expanded(
                    flex: 6,
                    child: DebugWidget(),
                  ),
                  NetworkWidget()
                ],
              )),
              Container(
                  width: 370,
                  height: double.infinity,
                  color: Theme.of(context).colorScheme.background,
                  child: const SettingsWidget())
            ]));
  }
}
