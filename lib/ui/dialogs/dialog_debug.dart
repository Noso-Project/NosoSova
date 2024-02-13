import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nososova/blocs/debug_bloc.dart';
import 'package:nososova/ui/theme/style/colors.dart';

import '../../models/app/debug.dart';
import '../theme/style/text_style.dart';

class DialogDebug extends StatefulWidget {
  const DialogDebug({Key? key}) : super(key: key);

  @override
  State createState() => _DialogDebugState();
}

class _DialogDebugState extends State<DialogDebug> {
  final ScrollController _controller = ScrollController();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DebugBloc, DebugState>(builder: (context, state) {
      var listDebug = state.debugList.reversed.toList();
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
              decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.2),
                borderRadius: BorderRadius.circular(20.0),
              ),
              width: double.infinity,
              height: MediaQuery.of(context).size.height * 0.4,
              child: ListView.builder(
                shrinkWrap: true,
                controller: _controller,
                padding:
                    const EdgeInsets.symmetric(horizontal: 10.0, vertical: 0.0),
                itemCount: listDebug.length,
                itemBuilder: (context, index) {
                  final item = listDebug[index];
                  return Padding(
                    padding: EdgeInsets.symmetric(
                        vertical: item.type != DebugType.inform ? 10 : 0),
                    child: Text("${item.time}: ${item.message}",
                        style: AppTextStyles.infoItemTitle.copyWith(
                            color: item.type != DebugType.inform
                                ? item.type != DebugType.error
                                    ? CustomColors.positiveBalance
                                    : CustomColors.negativeBalance
                                : Theme.of(context).colorScheme.onSurface)),
                  );
                },
              ),
            )
          ],
        ),
      );
    });
  }
}
