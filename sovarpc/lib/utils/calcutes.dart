import 'dart:isolate';
import 'dart:typed_data';

class CalcutesUtils {
  static Future<void> calculateSummary(SendPort mainSendPort) async {
    ReceivePort childReceivePort = ReceivePort();
    mainSendPort.send(childReceivePort.sendPort);
    int supply = 0;
    int totalBalanceWallet = 0;
    int index = 0;

    await for (var message in childReceivePort) {
      var psk = message[0];
      var addressesHashes = message[1];
      var replyPort = message[2];
      try {
        while (index + 106 <= psk.length) {
          var hash = String.fromCharCodes(
              psk.sublist(index + 1, index + psk[index] + 1));
          var targetBalance = ByteData.view(
                  Uint8List.fromList(psk.sublist(index + 82, index + 90))
                      .buffer)
              .getInt64(0, Endian.little);

          if (targetBalance != 0) {
            supply += targetBalance;
            if (addressesHashes.isNotEmpty && addressesHashes.contains(hash)) {
              totalBalanceWallet += targetBalance;
            }
          }

          index += 106;
        }
        return replyPort.send(supply, totalBalanceWallet);
      } catch (e) {
        replyPort.send([0, 0]);
      }
    }
  }
}
