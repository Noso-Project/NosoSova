import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:noso_dart/utils/noso_utility.dart';
import 'package:noso_rest_api/models/transaction.dart';
import 'package:nososova/ui/common/route/dialog_router.dart';
import 'package:nososova/ui/theme/decoration/textfield_decoration.dart';
import 'package:nososova/ui/theme/style/colors.dart';
import 'package:nososova/ui/tiles/tile_wallet_address.dart';
import 'package:nososova/utils/enum.dart';
import 'package:swipeable_button_view/swipeable_button_view.dart';

import '../../../../blocs/events/wallet_events.dart';
import '../../../../blocs/wallet_bloc.dart';
import '../../../../dependency_injection.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../models/address_wallet.dart';
import '../../../../models/responses/response_page_listener.dart';
import '../../../common/responses_util/response_widget_id.dart';
import '../../../common/responses_util/snackbar_message.dart';
import '../../../config/responsive.dart';
import '../../../notifer/address_tile_style_notifer.dart';
import '../../../theme/style/text_style.dart';
import '../../../tiles/tile_select_address.dart';
import '../../transaction/screen/widget_transaction.dart';

class PaymentScreen extends StatefulWidget {
  final Address address;
  final String receiver;

  const PaymentScreen({Key? key, required this.address, this.receiver = ""})
      : super(key: key);

  @override
  State createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  late Address targetAddress = widget.address;
  late StreamSubscription listenResponse;
  bool isFinished = false;
  bool isActiveButtonSend = false;
  TextEditingController amountController = TextEditingController();
  TextEditingController receiverController = TextEditingController();
  TextEditingController messageController = TextEditingController();
  double selButton = -1;
  double commission = 0;
  Key containerKey = UniqueKey();
  bool isResultWidget = false;
  late Transaction transactionHistory;
  late ConsensusStatus statusConsensus = ConsensusStatus.error;
  final AddressStyleNotifier _settingsStyleAddressTile =
      locator<AddressStyleNotifier>();

  @override
  void initState() {
    receiverController.text = widget.receiver.isEmpty ? "" : widget.receiver;
    super.initState();
    var bloc = BlocProvider.of<WalletBloc>(context);
    statusConsensus = bloc.state.wallet.consensusStatus;

    bloc.stream.listen((state) {
      Address desireAddress = state.wallet.address.firstWhere(
        (element) => element.hash == targetAddress.hash,
        orElse: () => Address(hash: "", publicKey: "", privateKey: ""),
      );

      statusConsensus = state.wallet.consensusStatus;

      if (desireAddress.hash.isNotEmpty) {
        targetAddress = desireAddress;
      } else {
        if (mounted && targetAddress.hash.isNotEmpty) {
          Navigator.pop(context);
          SnackBarWidgetResponse(
                  context: GlobalKey<ScaffoldMessengerState>().currentContext ??
                      context,
                  response: ResponseListenerPage(
                      codeMessage: 9, snackBarType: SnackBarType.error))
              .get();
        }
      }
    });

    _responseListener(bloc);
  }

  void _responseListener(WalletBloc bloc) {
    listenResponse = bloc.getResponseStatusStream.listen((response) async {
      if (mounted && ResponseWidgetsIds.pageSendOrder == response.idWidget) {
        if (response.codeMessage == 4 &&
            response.snackBarType == SnackBarType.ignore) {
          await Future.delayed(const Duration(milliseconds: 500));
          transactionHistory = response.actionValue;
          setState(() {
            isResultWidget = true;
          });
        }

        if (response.snackBarType != SnackBarType.ignore) {
          await Future.delayed(const Duration(milliseconds: 200));
          SnackBarWidgetResponse(
                  context: GlobalKey<ScaffoldMessengerState>().currentContext ??
                      context,
                  response: response)
              .get();
          setState(() {
            containerKey = UniqueKey();
          });
        }
      }
    });
  }

  @override
  void dispose() {
    listenResponse.cancel();
    super.dispose();
  }

  void refreshAddress(Address address) {
    setState(() {
      targetAddress = address;
      amountController.text = "0";
      selButton = -1;
      commission = 0;
      isActiveButtonSend = false;
    });
  }

  void refreshReceiver(String hash) {
    setState(() {
      receiverController.text = hash;
    });
    checkButtonActive(null);
  }

  Future<void> pasteReceiver() async {
    ClipboardData? data = await Clipboard.getData(Clipboard.kTextPlain);
    if (data != null && data.text != null) {
      setState(() {
        receiverController.text = data.text!;
      });
    }
  }

  _buildSender() {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(AppLocalizations.of(context)!.sender,
          textAlign: TextAlign.start,
          style:
              AppTextStyles.itemMedium.copyWith(fontWeight: FontWeight.w600)),
      Container(
          decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(5.0)),
          width: double.infinity,
          child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 15),
              child: targetAddress.hash.isEmpty
                  ? SelectAddressListTile(
                      onTap: () => DialogRouter.showDialogSellAddress(
                          context,
                          targetAddress,
                          (selAddress) => refreshAddress(selAddress)))
                  : AddressListTile(
                      address: targetAddress,
                      onLong: null,
                      style: _settingsStyleAddressTile.getStyleAddressTile ??
                          AddressTileStyle.sDefault,
                      onTap: () => DialogRouter.showDialogSellAddress(
                          context,
                          targetAddress,
                          (selAddress) => refreshAddress(selAddress)))))
    ]);
  }

  _buildButtonPay() {
    return Center(
        key: containerKey,
        child: SwipeableButtonView(
            isActive: statusConsensus == ConsensusStatus.error
                ? false
                : isActiveButtonSend,
            buttonText: AppLocalizations.of(context)!.send,
            buttonWidget:
                const Icon(Icons.arrow_forward_ios_rounded, color: Colors.grey),
            activeColor: Theme.of(context).colorScheme.primary,
            onWaitingProcess: () => sendOrder(),
            onFinish: () {}));
  }

  _buildMobile() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: SingleChildScrollView(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const SizedBox(height: 10),
          _buildSender(),
          _buildForms(),
          const SizedBox(height: 20),
          if (targetAddress.nodeStatusOn || targetAddress.outgoing > 0.0)
            _buildLockedCoins(),
          _buildCommission(),
          _buildButtonPay(),
          const SizedBox(height: 30),
        ]),
      ),
    );
  }

  _buildDesktop() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: _buildForms(),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSender(),
                const SizedBox(height: 20),
                if (targetAddress.nodeStatusOn || targetAddress.outgoing > 0.0)
                  _buildLockedCoins(),
                _buildCommission(),
                _buildButtonPay()
              ],
            ),
          )
        ],
      ),
    );
  }

  _buildForms() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text(AppLocalizations.of(context)!.receiver,
              textAlign: TextAlign.start,
              style: AppTextStyles.itemMedium
                  .copyWith(fontWeight: FontWeight.w600)),
          Row(children: [
            IconButton(
                padding: EdgeInsets.zero,
                tooltip: AppLocalizations.of(context)!.tooltipSelMyWallet,
                onPressed: () => DialogRouter.showDialogSellAddress(
                    context,
                    Address(hash: "", publicKey: "", privateKey: ""),
                    isReceiver: true,
                    (selAddress) => refreshReceiver(selAddress.hash)),
                icon: const Icon(Icons.credit_card)),
            IconButton(
                padding: EdgeInsets.zero,
                tooltip: AppLocalizations.of(context)!.tooltipSelContact,
                onPressed: () => DialogRouter.showDialogSellContact(
                    context, (p0) => refreshReceiver(p0.hash)),
                icon: const Icon(Icons.contacts)),
            IconButton(
                padding: EdgeInsets.zero,
                tooltip: AppLocalizations.of(context)!.tooltipPasteFromBuffer,
                onPressed: () => pasteReceiver(),
                icon: const Icon(Icons.paste))
          ])
        ]),
        const SizedBox(height: 10),
        TextField(
            maxLength: 33,
            onChanged: (text) => checkButtonActive(null),
            controller: receiverController,
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9@*+\-_:]')),
            ],
            style: AppTextStyles.textField,
            decoration: AppTextFiledDecoration.defaultDecoration(
                AppLocalizations.of(context)!.receiver)),
        Text(
          AppLocalizations.of(context)!.amount,
          textAlign: TextAlign.start,
          style: AppTextStyles.itemMedium.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 10),
        TextField(
            onChanged: (text) => checkButtonActive(null),
            controller: amountController,
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d*')),
              TextInputFormatter.withFunction((oldValue, newValue) {
                var value =
                    double.parse(newValue.text.isEmpty ? "0" : newValue.text);
                if (value <= targetAddress.availableBalance) {
                  return newValue;
                }

                return oldValue;
              })
            ],
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            style: AppTextStyles.textField,
            decoration: AppTextFiledDecoration.defaultDecoration("0.0000000")),
        const SizedBox(height: 20),
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          buttonPercent(25),
          buttonPercent(50),
          buttonPercent(75),
          buttonPercent(100)
        ]),
        const SizedBox(height: 30),
        TextField(
            maxLength: 120,
            controller: messageController,
            style: AppTextStyles.textField,
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9]'))
            ],
            decoration: AppTextFiledDecoration.defaultDecoration(
                AppLocalizations.of(context)!.message)),
      ],
    );
  }

  _buildCommission() {
    return Column(children: [
      Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              AppLocalizations.of(context)!.commission,
              style: AppTextStyles.infoItemTitle,
            ),
            const SizedBox(height: 5),
            Text("${(commission).toStringAsFixed(8)} NOSO",
                style: AppTextStyles.infoItemValue)
          ]),
      const SizedBox(height: 20)
    ]);
  }

  _buildLockedCoins() {
    return Column(children: [
      Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(AppLocalizations.of(context)!.lockedCoins,
                style: AppTextStyles.infoItemTitle
                    .copyWith(color: CustomColors.negativeBalance)),
            const SizedBox(height: 5),
            Text(
                "${targetAddress.nodeStatusOn ? (NosoUtility.getCountMonetToRunNode()).toStringAsFixed(5) : targetAddress.outgoing} NOSO",
                style: AppTextStyles.infoItemValue
                    .copyWith(color: CustomColors.negativeBalance))
          ]),
      const SizedBox(height: 10)
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
        duration: const Duration(milliseconds: 500),
        child: !isResultWidget
            ? Responsive.isMobile(Navigator.of(context).context)
                ? _buildMobile()
                : _buildDesktop()
            : TransactionWidgetInfo(
                transaction: transactionHistory,
                isReceiver: false,
                isProcess: true));
  }

  int doubleToIndianInt(double value) {
    return (value * 100000000).round();
  }

  sendOrder() {
    BlocProvider.of<WalletBloc>(context).add(SendOrder(
        receiverController.text,
        messageController.text,
        double.parse(amountController.text),
        targetAddress,
        ResponseWidgetsIds.pageSendOrder));
  }

  double getFee(double amount) {
    double result = (amount / 0.00010000) / 100000000;
    if (result < 0.01000000) {
      return 0.01000000;
    }
    return result;
  }

  checkButtonActive(double? amountVal) {
    double amount = amountVal ??
        double.parse(
            amountController.text.isEmpty ? "0" : amountController.text);
    var receiver =
        receiverController.text.isEmpty ? "" : receiverController.text;

    commission = getFee(amount);
    var priceCheck = amountController.text.isEmpty
        ? false
        : targetAddress.availableBalance >= amount + commission;
    var receiverCheck = targetAddress.hash == receiverController.text
        ? false
        : NosoUtility.isValidHashNoso(receiver);

    setState(() {
      if (selButton !=
          double.parse(
              amountController.text.isEmpty ? "0" : amountController.text)) {
        selButton = -1;
      }
      isActiveButtonSend = priceCheck && receiverCheck;
    });
  }

  buttonPercent(int percent) {
    var balanceAddress = targetAddress.nodeStatusOn
        ? (targetAddress.availableBalance -
            NosoUtility.getCountMonetToRunNode())
        : targetAddress.availableBalance;
    double value =
        double.parse(((percent / 100) * balanceAddress).toStringAsFixed(8));
    var valueAmount = percent == 100 ? (value - getFee(value)) : value;

    return OutlinedButton(
        onPressed: () {
          if (targetAddress.hash.isNotEmpty &&
              targetAddress.balance != 0 &&
              valueAmount >= getFee(value)) {
            setState(() {
              amountController.text = valueAmount.toStringAsFixed(8);
              selButton = double.parse(valueAmount.toStringAsFixed(8));

              checkButtonActive(valueAmount);
            });
          }
        },
        style: OutlinedButton.styleFrom(
          backgroundColor:
              selButton == double.parse(valueAmount.toStringAsFixed(8))
                  ? Theme.of(context).colorScheme.primary
                  : Colors.transparent,
          side: BorderSide(
              color: selButton == double.parse(valueAmount.toStringAsFixed(8))
                  ? Theme.of(context).colorScheme.background.withOpacity(0.5)
                  : Colors.grey),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
        ),
        child: Padding(
            padding: const EdgeInsets.all(0),
            child: Text("$percent%",
                style: TextStyle(
                    fontSize: 12,
                    fontWeight: selButton ==
                            double.parse(valueAmount.toStringAsFixed(8))
                        ? FontWeight.bold
                        : FontWeight.normal,
                    color: selButton ==
                            double.parse(valueAmount.toStringAsFixed(8))
                        ? Theme.of(context).colorScheme.onPrimary
                        : Theme.of(context).colorScheme.onSurface))));
  }
}
