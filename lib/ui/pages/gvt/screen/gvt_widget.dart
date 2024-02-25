import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:noso_dart/const.dart';

import '../../../config/responsive.dart';
import '../../../theme/decoration/gvt/gvt_gradient_decoration.dart';
import '../../../theme/decoration/gvt/gvt_gradient_decoration_round.dart';
import '../../../theme/decoration/standart_gradient_decoration.dart';
import '../../../theme/decoration/standart_gradient_decoration_round.dart';
import '../../../theme/style/text_style.dart';

class GvtWidget extends StatelessWidget {
  const GvtWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return !Responsive.isMobile(context)
        ? Container(
            height: 350,
            width: double.infinity,
            decoration: const GvtGradientDecoration(),
            child: const SafeArea(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                  Padding(
                      padding: EdgeInsets.symmetric(horizontal: 30.0),
                      child: GvtBody())
                ])))
        : Container(
      height: 300,
            width: double.infinity,
            decoration: const GvtGradientDecorationRound(),
            child: const SafeArea(
                child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 30.0),
                    child: GvtBody())));
  }
}

class GvtBody extends StatefulWidget {
  const GvtBody({Key? key}) : super(key: key);

  @override
  State createState() => _GvtBodyState();
}

class _GvtBodyState extends State<GvtBody> {
  bool isVisibleAction = false;

  @override
  Widget build(BuildContext context) {
      return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            Text("My GvT",
                style: AppTextStyles.infoItemValue
                    .copyWith(color: Colors.white.withOpacity(0.5))),
            Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text("0",
                      style: AppTextStyles.gvtBalance),

                ]),
            const SizedBox(height: 10),

            Text(
              "All Count",
              style: AppTextStyles.infoItemValue
                  .copyWith(color: Colors.white.withOpacity(0.5), fontSize: 14),
            ),
            Text("100",
                style: AppTextStyles.infoItemValue.copyWith(
                    color: Colors.white.withOpacity(0.8), fontSize: 20)),
          ]);

  }
}
