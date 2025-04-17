
// import 'package:blue_thermal_printer/blue_thermal_printer.dart';

// class PrinterService {
//   final BlueThermalPrinter _bluetooth = BlueThermalPrinter.instance;
//   BluetoothDevice? _selectedPrinter;

//   Future<List<BluetoothDevice>> scanForPrinters() async {
//     return await _bluetooth.getBondedDevices();
//   }

//   Future<void> connectToPrinter(BluetoothDevice device) async {
//     await _bluetooth.connect(device);
//     _selectedPrinter = device;
//   }

//   void disconnect() {
//     _bluetooth.disconnect();
//     _selectedPrinter = null;
//   }

//   Future<void> printReceipt({
//     required String userName,
//     required String plateNumber,
//     required String rfid,
//     required String timeOut,
//   }) async {
//     if (_selectedPrinter == null) {
//       print("⚠️ No printer selected.");
//       return;
//     }

//     _bluetooth.printNewLine();
//     _bluetooth.printCustom("=== TUPark Receipt ===", 3, 1);
//     _bluetooth.printNewLine();
//     _bluetooth.printLeftRight("Name", userName, 1);
//     _bluetooth.printLeftRight("Plate No.", plateNumber, 1);
//     _bluetooth.printLeftRight("RFID UID", rfid, 1);
//     _bluetooth.printLeftRight("Time Out", timeOut, 1);
//     _bluetooth.printNewLine();
//     _bluetooth.printCustom("=====================", 1, 1);
//     _bluetooth.printNewLine();
//     _bluetooth.paperCut();
//   }
// }


// import 'package:blue_thermal_printer/blue_thermal_printer.dart';

// class PrinterService {
//   final BlueThermalPrinter _bluetooth = BlueThermalPrinter.instance;
//   BluetoothDevice? _selectedPrinter;

//   bool isConnected = false;

//   PrinterService() {
//     _bluetooth.onStateChanged().listen((state) {
//       if (state == BlueThermalPrinter.CONNECTED) {
//         isConnected = true;
//         print("✅ Printer connected");
//       } else if (state == BlueThermalPrinter.DISCONNECTED) {
//         isConnected = false;
//         print("❌ Printer disconnected");
//       }
//     });
//   }

//   Future<List<BluetoothDevice>> scanForPrinters() async {
//     return await _bluetooth.getBondedDevices();
//   }

//   Future<void> connectToPrinter(BluetoothDevice device) async {
//     bool isAlreadyConnected = await _bluetooth.isConnected ?? false;
//     if (!isAlreadyConnected) {
//       await _bluetooth.connect(device);
//     }
//     _selectedPrinter = device;
//   }

//   void disconnect() {
//     _bluetooth.disconnect();
//     _selectedPrinter = null;
//     isConnected = false;
//   }

//   Future<void> printReceipt({
//     required String userName,
//     required String plateNumber,
//     required String rfid,
//     required String timeOut,
//   }) async {
//     bool connected = await _bluetooth.isConnected ?? false;

//     if (!connected) {
//       print("⚠️ Not connected to printer. Please connect first.");
//       return;
//     }

//     try {
//       _bluetooth.printNewLine();
//       _bluetooth.printCustom("=== TUPark Receipt ===", 3, 1);
//       _bluetooth.printNewLine();
//       _bluetooth.printLeftRight("Name", userName, 1);
//       _bluetooth.printLeftRight("Plate No.", plateNumber, 1);
//       _bluetooth.printLeftRight("RFID UID", rfid, 1);
//       _bluetooth.printLeftRight("Time Out", timeOut, 1);
//       _bluetooth.printNewLine();
//       _bluetooth.printCustom("=====================", 1, 1);
//       _bluetooth.printNewLine();
//       _bluetooth.paperCut();

//       print("🖨️ Receipt sent to printer.");
//     } catch (e) {
//       print("❌ Print failed: \$e");
//     }
//   }
// }

import 'package:blue_thermal_printer/blue_thermal_printer.dart';

class PrinterService {
  final BlueThermalPrinter _bluetooth = BlueThermalPrinter.instance;
  BluetoothDevice? _selectedPrinter;
  bool isConnected = false;

  PrinterService() {
    _bluetooth.onStateChanged().listen((state) {
      if (state == BlueThermalPrinter.CONNECTED) {
        isConnected = true;
        print("✅ Printer connected");
      } else if (state == BlueThermalPrinter.DISCONNECTED) {
        isConnected = false;
        print("❌ Printer disconnected");
      }
    });
  }

  Future<List<BluetoothDevice>> scanForPrinters() async {
    return await _bluetooth.getBondedDevices();
  }

  Future<void> connectToPrinter(BluetoothDevice device) async {
    await _bluetooth.connect(device);
    _selectedPrinter = device;
  }

  void disconnect() {
    _bluetooth.disconnect();
  }
Future<void> printReceipt({
  required String userName,
  required String plateNumber,
  required String rfid,
  required String timeOut,
}) async {
  try {
    // Re-scan and connect if not connected
    if (!isConnected) {
      print("🔍 Printer not connected. Scanning...");
      final printers = await scanForPrinters();
      if (printers.isNotEmpty) {
        await connectToPrinter(printers.first);
        print("✅ Auto-connected to printer: ${printers.first.name}");
        await Future.delayed(Duration(seconds: 2)); // small delay for stability
      } else {
        print("❌ No paired printers found.");
        return;
      }
    }

    // Now print
    _bluetooth.printNewLine();
    _bluetooth.printCustom("=== TUPark Receipt ===", 3, 1);
    _bluetooth.printNewLine();
    _bluetooth.printLeftRight("Name", userName, 1);
    _bluetooth.printLeftRight("Plate No.", plateNumber, 1);
    _bluetooth.printLeftRight("RFID UID", rfid, 1);
    _bluetooth.printLeftRight("Time Out", timeOut, 1);
    _bluetooth.printNewLine();
    _bluetooth.printCustom("=====================", 1, 1);
    _bluetooth.printNewLine();

    print("🖨️ Printed successfully.");
  } catch (e) {
    print("❌ Printing failed: $e");
  }
}


}