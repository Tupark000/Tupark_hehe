
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
import '../services/printer_service.dart';

class ExitPage extends StatefulWidget {
  @override
  _ExitPageState createState() => _ExitPageState();
}

class _ExitPageState extends State<ExitPage> {
  String scannedRFID = "Waiting for RFID scan...";
  bool isConfirmingExit = false;
  String? lastRFID;
  String? userName;
  String? plateNumber;

  final PrinterService _printerService = PrinterService();

  @override
  void initState() {
    super.initState();

    ApiService.listenToExitWebSocket((rfid) async {
      print("🔄 Scanned Exit RFID: $rfid");
      if (rfid != lastRFID) {

        final user = await ApiService.fetchUserDetails(rfid);
        if (user != null) {
          setState(() {
            scannedRFID = "RFID: $rfid";
            lastRFID = rfid;
            userName = user['name'];
            plateNumber = user['plate_number'];
          });
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("⚠️ No ACTIVE user found for RFID: $rfid")),
          );
        }


      }
    });
  }

  @override
  void dispose() {
    ApiService.disposeWebSockets();
    // Do NOT disconnect the printer to keep persistent connection
    super.dispose();
  }

  void confirmExit() async {
    if (lastRFID == null || userName == null || plateNumber == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("⚠️ Please scan a valid ACTIVE user first.")),
      );
      return;
    }

    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Confirm Exit"),
        content: Text("Exit for UID: $lastRFID\nName: $userName\nPlate: $plateNumber"),
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
      final wantPrint = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("Print Receipt"),
          content: Text("Do you want to print a receipt for:\n$userName / $plateNumber?"),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context, false), child: Text("No")),
            ElevatedButton(onPressed: () => Navigator.pop(context, true), child: Text("Yes")),
          ],
        ),
      );

      if (wantPrint == true) {
        final timeOut = DateTime.now().toString();
        await _printerService.printReceipt(
          userName: userName ?? "Unknown",
          plateNumber: plateNumber ?? "Unknown",
          rfid: rfid,
          timeOut: timeOut,
        );
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
            SizedBox(height: 8),
            if (userName != null && plateNumber != null)
              Column(
                children: [
                  Text("Name: $userName", style: TextStyle(fontSize: 16)),
                  Text("Plate: $plateNumber", style: TextStyle(fontSize: 16)),
                ],
              ),
            SizedBox(height: 20),
            ElevatedButton.icon(
              icon: Icon(Icons.exit_to_app),
              label: Text("Confirm Exit"),
              onPressed: isConfirmingExit ? null : confirmExit,
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                backgroundColor: Colors.blueAccent,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
