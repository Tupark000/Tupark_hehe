
// import 'package:flutter/material.dart';
// import '../services/api_service.dart';
// import '../services/printer_service.dart';

// class ExitPage extends StatefulWidget {
//   @override
//   _ExitPageState createState() => _ExitPageState();
// }

// class _ExitPageState extends State<ExitPage> {
//   String scannedRFID = "Waiting for RFID scan...";
//   bool isConfirmingExit = false;
//   String? lastRFID;
//   String? userName;
//   String? plateNumber;

//   final PrinterService _printerService = PrinterService(); // Singleton is preserved

//   @override
//   void initState() {
//     super.initState();

//     ApiService.listenToExitWebSocket((rfid) async {
//       print("🔄 Scanned Exit RFID: $rfid");
//       if (rfid != lastRFID) {

//         final user = await ApiService.fetchUserDetails(rfid);
//         if (user != null) {
//           setState(() {
//             scannedRFID = "RFID: $rfid";
//             lastRFID = rfid;
//             userName = user['name'];
//             plateNumber = user['plate_number'];
//           });
//         } else {
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(content: Text("⚠️ No ACTIVE user found for RFID: $rfid")),
//           );
//         }


//       }
//     });
//   }

//   @override
//   void dispose() {
//     ApiService.disposeWebSockets();
//     // Do NOT disconnect the printer to keep persistent connection
//     super.dispose();
//   }

//   void confirmExit() async {
//     if (lastRFID == null || userName == null || plateNumber == null) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("⚠️ Please scan a valid ACTIVE user first.")),
//       );
//       return;
//     }

//     final confirm = await showDialog<bool>(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: Text("Confirm Exit"),
//         content: Text("Exit for UID: $lastRFID\nName: $userName\nPlate: $plateNumber"),
//         actions: [
//           TextButton(onPressed: () => Navigator.pop(context, false), child: Text("Cancel")),
//           ElevatedButton(onPressed: () => Navigator.pop(context, true), child: Text("Confirm Exit")),
//         ],
//       ),
//     );

//     if (confirm == true) {
//       await processExit(lastRFID!);
//     }
//   }

//   Future<void> processExit(String rfid) async {
//     setState(() => isConfirmingExit = true);

//     final success = await ApiService.exitUser(rfid);
//     if (success) {
//       final wantPrint = await showDialog<bool>(
//         context: context,
//         builder: (context) => AlertDialog(
//           title: Text("Print Receipt"),
//           content: Text("Do you want to print a receipt for:\n$userName / $plateNumber?"),
//           actions: [
//             TextButton(onPressed: () => Navigator.pop(context, false), child: Text("No")),
//             ElevatedButton(onPressed: () => Navigator.pop(context, true), child: Text("Yes")),
//           ],
//         ),
//       );

//       if (wantPrint == true) {
//         final timeOut = DateTime.now().toString();
//         await _printerService.printReceipt(
//           userName: userName ?? "Unknown",
//           plateNumber: plateNumber ?? "Unknown",
//           rfid: rfid,
//           timeOut: timeOut,
//         );
//       }

//       ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("✅ Exit successful!")));
//       Navigator.pop(context, true);
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("❌ Exit failed. Try again.")));
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
//             SizedBox(height: 8),
//             if (userName != null && plateNumber != null)
//               Column(
//                 children: [
//                   Text("Name: $userName", style: TextStyle(fontSize: 16)),
//                   Text("Plate: $plateNumber", style: TextStyle(fontSize: 16)),
//                 ],
//               ),
//             SizedBox(height: 20),
//             ElevatedButton.icon(
//               icon: Icon(Icons.exit_to_app),
//               label: Text("Confirm Exit"),
//               onPressed: isConfirmingExit ? null : confirmExit,
//               style: ElevatedButton.styleFrom(
//                 padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
//                 backgroundColor: Colors.blueAccent,
//               ),
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
            scannedRFID = rfid;
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
        content: Text("Exit for:\nUID: $lastRFID\nName: $userName\nPlate: $plateNumber"),
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
      appBar: AppBar(
        title: Text('Exit User'),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.redAccent,
        elevation: 1,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // UID Text Box
              Text(
                "Scanned RFID UID:",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 10),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.red[50],
                  border: Border.all(color: Colors.redAccent, width: 1.5),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  scannedRFID,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.redAccent,
                  ),
                ),
              ),
              const SizedBox(height: 24),

              if (userName != null && plateNumber != null)
                Column(
                  children: [
                    Text("Name: $userName", style: TextStyle(fontSize: 16)),
                    Text("Plate: $plateNumber", style: TextStyle(fontSize: 16)),
                    const SizedBox(height: 24),
                  ],
                ),

              ElevatedButton.icon(
                icon: Icon(Icons.exit_to_app),
                label: Text("Confirm Exit"),
                onPressed: isConfirmingExit ? null : confirmExit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
