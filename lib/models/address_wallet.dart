import 'package:drift/drift.dart';
import 'package:noso_dart/models/noso/address_object.dart';

import '../utils/other_utils.dart';

@DataClassName('Address')
class Address extends AddressObject {
  /// Returns the wallet address displayed to the user, either truncated or custom.
  get nameAddressPublic => custom ?? hashPublic;

  /// Does he work at this address?
  bool nodeStatusOn;

  /// How much does this node earn per day?
  double rewardDay;

  /// Returns the obfuscated hash of the address.
  get hashPublic => OtherUtils.hashObfuscation(hash);

  String seedNodeOn = "";

  Address({
    required String hash,
    String? custom,
    required String publicKey,
    required String privateKey,
    double balance = 0,
    int score = 0,
    int lastOP = 0,
    bool isLocked = false,
    double incoming = 0,
    double outgoing = 0,
    this.rewardDay = 0,
    this.nodeStatusOn = false,
  }) : super(
          hash: hash,
          custom: custom,
          publicKey: publicKey,
          privateKey: privateKey,
          balance: balance,
          score: score,
          lastOP: lastOP,
          isLocked: isLocked,
          incoming: incoming,
          outgoing: outgoing,
        );
}
