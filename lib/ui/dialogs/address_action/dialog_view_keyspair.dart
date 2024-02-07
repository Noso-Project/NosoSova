import 'package:flutter/material.dart';
import 'package:nososova/ui/common/widgets/item_info_widget.dart';

import '../../../models/address_wallet.dart';

class DialogViewKeysPair extends StatefulWidget {
  final Address address;

  const DialogViewKeysPair({super.key, required this.address});

  @override
  State createState() => _DialogViewKeysPairState();
}

class _DialogViewKeysPairState extends State<DialogViewKeysPair> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 20.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ItemInfoWidgetVertical(
              nameItem: "Hash:", value: widget.address.hash, copy: true),
          const SizedBox(height: 10),
          ItemInfoWidgetVertical(
              nameItem: "Public key:",
              value: widget.address.publicKey,
              copy: true),
          const SizedBox(height: 10),
          ItemInfoWidgetVertical(
              nameItem: "Private key:",
              value: widget.address.privateKey,
              copy: true)
        ],
      ),
    );
  }
}
