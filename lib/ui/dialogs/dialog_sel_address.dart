import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nososova/blocs/wallet_bloc.dart';

import '../../l10n/app_localizations.dart';
import '../../models/address_wallet.dart';
import '../common/widgets/empty_list_widget.dart';
import '../tiles/tile_wallet_address.dart';

class DialogSellAddress extends StatefulWidget {
  final Address targetAddress;
  final Function(Address) selected;

  const DialogSellAddress(
      {super.key, required this.targetAddress, required this.selected});

  @override
  State createState() => DialogSellAddressState();
}

class DialogSellAddressState extends State<DialogSellAddress> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WalletBloc, WalletState>(builder: (context, state) {
      var listAddress = state.wallet.address;
      return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (listAddress.isEmpty)
            Padding(
                padding: const EdgeInsets.symmetric(vertical: 70),
                child: EmptyWidget(
                    title: AppLocalizations.of(context)!.empty,
                    descrpt: AppLocalizations.of(context)!.emptyListAddress)),
          if (listAddress.isNotEmpty)
            Container(
              padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
              width: double.infinity,
              height: MediaQuery.of(context).size.height * 0.4,
              child: ListView.builder(
                shrinkWrap: true,
                padding:
                    const EdgeInsets.symmetric(horizontal: 0.0, vertical: 0.0),
                itemCount: listAddress.length,
                itemBuilder: (context, index) {
                  final item = listAddress[index];
                  return Container(
                      color: widget.targetAddress.hash == item.hash
                          ? Colors.grey.withOpacity(0.2)
                          : Colors.transparent,
                      child: AddressListTile(
                        address: item,
                        onLong: () {},
                        onTap: () {
                          Navigator.pop(context);
                          widget.selected(item);
                        },
                      ));
                },
              ),
            )
        ],
      );
    });
  }
}
