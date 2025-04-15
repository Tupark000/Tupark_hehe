
// import 'package:flutter/material.dart';
// import '../services/api_service.dart';

// class ExitPage extends StatefulWidget {
//   @override
//   _ExitPageState createState() => _ExitPageState();
// }

// class _ExitPageState extends State<ExitPage> {
//   String scannedRFID = "Waiting for RFID scan...";
//   bool isConfirmingExit = false;
//   String? lastRFID;

//   @override
//   void initState() {
//     super.initState();

//     // Listen for a single RFID scan only
//     ApiService.listenToExitWebSocket((rfid) {
//       print("🔄 Scanned Exit RFID: $rfid");
//       if (rfid != lastRFID) {
//         setState(() {
//           scannedRFID = "RFID: $rfid";
//           lastRFID = rfid;
//         });
//       }
//     });
//   }

//   @override
//   void dispose() {
//     ApiService.disposeWebSockets(); // Close socket when exiting page
//     super.dispose();
//   }

//   void confirmExit() async {
//     if (lastRFID == null) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("⚠️ No RFID scanned! Please scan an RFID first.")),
//       );
//       return;
//     }

//     // Confirmation dialog (no receipt option yet)
//     await showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: Text("Confirm Exit"),
//         content: Text("Do you want to proceed with exiting UID: $lastRFID?"),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: Text("Cancel"),
//           ),
//           ElevatedButton(
//             onPressed: () async {
//               Navigator.pop(context);
//               processExit(lastRFID!);
//             },
//             child: Text("Confirm Exit"),
//           ),
//         ],
//       ),
//     );
//   }

//   void processExit(String rfid) async {
//     setState(() => isConfirmingExit = true);

//     bool success = await ApiService.exitUser(rfid);
//     if (success) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("✅ Exit successful!")),
//       );
//       Navigator.pop(context, true); // Notify parent to refresh
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("❌ Exit failed. Please try again.")),
//       );
//     }

//     setState(() => isConfirmingExit = false);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Exit User')),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Text(
//               scannedRFID,
//               style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//             ),
//             SizedBox(height: 20),
//             ElevatedButton.icon(
//               icon: Icon(Icons.exit_to_app),
//               label: Text("Confirm Exit"),
//               onPressed: isConfirmingExit ? null : confirmExit,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../services/printer_service.dart'; // Make sure this is implemented properly

class ExitPage extends StatefulWidget {
  @override
  _ExitPageState createState() => _ExitPageState();
}

class _ExitPageState extends State<ExitPage> {
  String scannedRFID = "Waiting for RFID scan...";
  bool isConfirmingExit = false;
  String? lastRFID;

  final PrinterService _printerService = PrinterService(); // Instance to access non-static method

  @override
  void initState() {
    super.initState();

    ApiService.listenToExitWebSocket((rfid) {
      print("🔄 Scanned Exit RFID: $rfid");
      if (rfid != lastRFID) {
        setState(() {
          scannedRFID = "RFID: $rfid";
          lastRFID = rfid;
        });
      }
    });
  }

  @override
  void dispose() {
    ApiService.disposeWebSockets();
    _printerService.disconnect(); // Disconnect printer if still connected
    super.dispose();
  }

  void confirmExit() async {
    if (lastRFID == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("⚠️ No RFID scanned! Please scan an RFID first.")),
      );
      return;
    }

    final confirm = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Confirm Exit"),
        content: Text("Do you want to proceed with exiting UID: $lastRFID?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: Text("Cancel")),
          ElevatedButton(onPressed: () => Navigator.pop(context, true), child: Text("Confirm Exit")),
        ],
      ),
    );

    if (confirm == true) {
      await processExit(lastRFID!);
    }
  }

  Future<void> processExit(String rfid) async {
    setState(() => isConfirmingExit = true);

    final success = await ApiService.exitUser(rfid);
    if (success) {
      final wantPrint = await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("Print Receipt"),
          content: Text("Do you want to print a receipt for UID: $rfid?"),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context, false), child: Text("No")),
            ElevatedButton(onPressed: () => Navigator.pop(context, true), child: Text("Yes")),
          ],
        ),
      );

      if (wantPrint == true) {
        // Use placeholder info for now or update if user/vehicle data is fetched
        const plate = "placeholderPlate";
        final timeOut = DateTime.now().toString();

        await _printerService.printReceipt(rfid, plate, timeOut);
      }

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("✅ Exit successful!")));
      Navigator.pop(context, true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("❌ Exit failed. Try again.")));
    }

    setState(() => isConfirmingExit = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Exit User')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              scannedRFID,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            ElevatedButton.icon(
              icon: Icon(Icons.exit_to_app),
              label: Text("Confirm Exit"),
              onPressed: isConfirmingExit ? null : confirmExit,
            ),
          ],
        ),
      ),
    );
  }
}
