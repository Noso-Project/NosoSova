import 'dart:async';
import 'dart:isolate';

class ComputeService {
  static Future<dynamic> compute(Function function, dynamic arg) async {
    final response = Completer<dynamic>();

    final receivePort = ReceivePort();
    // Spawn the isolate and send the initial message, which is the send port of the receive port.
    final isolate = await Isolate.spawn(_spawnIsolate, receivePort.sendPort);

    // Listen for messages on the receive port.
    receivePort.listen((message) {
      if (message is SendPort) {
        // Send the actual argument and the function to be executed to the isolate.
        message.send([function, arg]);
      } else {
        // Once you get the result back, complete the future.
        response.complete(message);
        // Don't forget to close the receive port to avoid a resource leak.
        receivePort.close();
      }
    });

    return response.future;
  }

  static void _spawnIsolate(SendPort sendPort) {
    final receivePort = ReceivePort();
    // Send back the send port to establish communication.
    sendPort.send(receivePort.sendPort);

    receivePort.listen((message) {
      if (message is List) {
        // Extract the function and the argument sent from the main isolate.
        Function function = message[0];
        dynamic arg = message[1];
        // Execute the function and send the result back.
        final result = function(arg);
        sendPort.send(result);
        // Close the receive port to clean up after the operation is done.
        receivePort.close();
      }
    });
  }
}
