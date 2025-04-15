import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'dart:typed_data';


class PrinterService {
  BluetoothConnection? _connection;

  // Connect to the printer via Bluetooth
  Future<bool> connectToPrinter(String address) async {
    try {
      _connection = await BluetoothConnection.toAddress(address);
      print('✅ Connected to the printer at $address');
      return true;
    } catch (e) {
      print('❌ Failed to connect to printer: $e');
      return false;
    }
  }

  // Send a simple receipt to the printer
  Future<void> printReceipt(String rfid, String plateNumber, String timeOut) async {
    if (_connection != null && _connection!.isConnected) {
      String receipt = """
======== TUPark Receipt ========
RFID UID: $rfid
Plate No: $plateNumber
Time Out: $timeOut
==============================
""";
      _connection!.output.add(Uint8List.fromList(receipt.codeUnits));
      await _connection!.output.allSent;
    } else {
      print("❌ Printer not connected.");
    }
  }

  // Disconnect from the printer
  void disconnect() {
    _connection?.dispose();
    _connection = null;
    print('🔌 Disconnected from printer.');
  }
}
