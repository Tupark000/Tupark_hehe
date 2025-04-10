// import 'package:flutter/material.dart';
// import '../services/api_service.dart';

// class ExitPage extends StatefulWidget {
//   @override
//   _ExitPageState createState() => _ExitPageState();
// }

// class _ExitPageState extends State<ExitPage> {
//   final ApiService apiService = ApiService();
//   TextEditingController rfidController = TextEditingController();
//   bool showReceiptDialog = false; // Auto-dismiss alert state

//   Future<void> deactivateUser() async {
//     String rfid = rfidController.text;
//     if (rfid.isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("Please scan an RFID tag")),
//       );
//       return;
//     }

//     bool success = await apiService.deactivateUser(rfid);
//     if (success) {
//       setState(() {
//         showReceiptDialog = true;
//       });

//       // Auto-dismiss alert after 10 seconds
//       Future.delayed(Duration(seconds: 10), () {
//         if (mounted) {
//           setState(() {
//             showReceiptDialog = false;
//           });
//         }
//       });
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("RFID not found or already inactive")),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("Exit Dashboard")),
//       body: Column(
//         children: [
//           Padding(
//             padding: EdgeInsets.all(16.0),
//             child: TextField(
//               controller: rfidController,
//               decoration: InputDecoration(
//                 labelText: "Scan RFID",
//                 border: OutlineInputBorder(),
//               ),
//               readOnly: true, // Ensure the user scans the RFID instead of typing
//             ),
//           ),
//           ElevatedButton(
//             onPressed: deactivateUser,
//             child: Text("Exit"),
//           ),
//           if (showReceiptDialog)
//             AlertDialog(
//               title: Text("Print Receipt?"),
//               content: Text("Do you want a printed receipt?"),
//               actions: [
//                 TextButton(
//                   onPressed: () {
//                     setState(() {
//                       showReceiptDialog = false;
//                     });
//                   },
//                   child: Text("No"),
//                 ),
//                 TextButton(
//                   onPressed: () {
//                     // Implement print function here
//                     setState(() {
//                       showReceiptDialog = false;
//                     });
//                   },
//                   child: Text("Yes"),
//                 ),
//               ],
//             ),
//         ],
//       ),
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:web_socket_channel/io.dart';
// import 'package:web_socket_channel/web_socket_channel.dart';
// import '../services/api_service.dart';

// class ExitPage extends StatefulWidget {
//   const ExitPage({Key? key}) : super(key: key);

//   @override
//   State<ExitPage> createState() => _ExitPageState();
// }

// class _ExitPageState extends State<ExitPage> {
//   late WebSocketChannel channel;
//   String scannedRFID = '';

//   @override
//   void initState() {
//     super.initState();
//     channel = IOWebSocketChannel.connect('ws://localhost:3000');
//     channel.stream.listen((message) async {
//       setState(() {
//         scannedRFID = message;
//       });

//       final success = await ApiService.exitUser(scannedRFID);

//       if (success) {
//         showDialog(
//           context: context,
//           builder: (_) => AlertDialog(
//             title: const Text('User Exited'),
//             content: const Text('Do you want a receipt?'),
//             actions: [
//               TextButton(
//                 onPressed: () => Navigator.of(context).pop(),
//                 child: const Text('No'),
//               ),
//               TextButton(
//                 onPressed: () {
//                   // TODO: Implement receipt generation
//                   Navigator.of(context).pop();
//                 },
//                 child: const Text('Yes'),
//               ),
//             ],
//           ),
//         );

//         Future.delayed(const Duration(seconds: 10), () {
//           setState(() {
//             scannedRFID = '';
//           });
//         });
//       } else {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text('No active user found')),
//         );
//       }
//     });
//   }

//   @override
//   void dispose() {
//     channel.sink.close();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Exit Page')),
//       body: Center(
//         child: Text(
//           scannedRFID.isEmpty ? 'Waiting for scan...' : 'Scanned UID: $scannedRFID',
//           style: const TextStyle(fontSize: 20),
//         ),
//       ),
//     );
//   }
// }


// import 'package:flutter/material.dart';
// import 'package:web_socket_channel/io.dart';
// import 'package:web_socket_channel/status.dart' as status;
// import '../services/api_service.dart';

// class ExitPage extends StatefulWidget {
//   const ExitPage({Key? key}) : super(key: key);

//   @override
//   State<ExitPage> createState() => _ExitPageState();
// }

// class _ExitPageState extends State<ExitPage> {
//   String? scannedUID;
//   bool isProcessing = false;
//   late IOWebSocketChannel channel;

//   @override
//   void initState() {
//     super.initState();

//     // Connect to the WebSocket server at /ws/exit (adjust IP accordingly)
//     channel = IOWebSocketChannel.connect('ws://192.168.0.2:3000/ws/exit');

//     // Listen for scanned RFID UID
//     channel.stream.listen((uid) {
//       if (!isProcessing) {
//         setState(() {
//           scannedUID = uid;
//         });
//         handleExit(uid);
//       }
//     }, onError: (error) {
//       print('WebSocket error: $error');
//     });
//   }

//   Future<void> handleExit(String uid) async {
//     setState(() => isProcessing = true);

//     final result = await ApiService.exitUser(uid);

//     setState(() => isProcessing = false);

//     final snackBar = SnackBar(
//       content: Text(result ? 'User exited successfully' : 'Exit failed'),
//       duration: Duration(seconds: 3),
//     );
//     ScaffoldMessenger.of(context).showSnackBar(snackBar);
//   }

//   @override
//   void dispose() {
//     channel.sink.close(status.goingAway);
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Exit User')),
//       body: Center(
//         child: isProcessing
//             ? CircularProgressIndicator()
//             : Text(
//                 scannedUID != null
//                     ? 'Scanned UID: $scannedUID'
//                     : 'Waiting for RFID scan...',
//                 style: TextStyle(fontSize: 18),
//               ),
//       ),
//     );
//   }
// }


// import 'package:flutter/material.dart';
// import 'package:web_socket_channel/io.dart';
// import 'package:web_socket_channel/status.dart' as status;
// import '../services/api_service.dart';

// class ExitPage extends StatefulWidget {
//   const ExitPage({Key? key}) : super(key: key);

//   @override
//   State<ExitPage> createState() => _ExitPageState();
// }

// class _ExitPageState extends State<ExitPage> {
//   String? scannedUID;
//   bool isProcessing = false;
//   late IOWebSocketChannel channel;

//   @override
//   void initState() {
//     super.initState();

//     // Connect to the WebSocket server at /ws/exit
//     channel = IOWebSocketChannel.connect('ws://192.168.0.2:3000/ws/exit');

//     // Listen for scanned RFID UID
//     channel.stream.listen((uid) {
//       if (!isProcessing) {
//         setState(() {
//           scannedUID = uid;
//         });
//         handleExit(uid);
//       }
//     }, onError: (error) {
//       print('WebSocket error: $error');
//     });
//   }

//   Future<void> handleExit(String uid) async {
//     setState(() => isProcessing = true);

//     final result = await ApiService.exitUser(uid);

//     setState(() => isProcessing = false);

//     if (result) {
//       // Delay for a short moment before navigating back
//       Future.delayed(Duration(seconds: 2), () {
//         Navigator.pop(context, true); // Return to Exit Dashboard
//       });
//     }

//     final snackBar = SnackBar(
//       content: Text(result ? 'User exited successfully' : 'Exit failed'),
//       duration: Duration(seconds: 3),
//     );
//     ScaffoldMessenger.of(context).showSnackBar(snackBar);
//   }

//   @override
//   void dispose() {
//     channel.sink.close(status.goingAway);
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Exit User')),
//       body: Center(
//         child: isProcessing
//             ? CircularProgressIndicator()
//             : Text(
//                 scannedUID != null
//                     ? 'Scanned UID: $scannedUID'
//                     : 'Waiting for RFID scan...',
//                 style: TextStyle(fontSize: 18),
//               ),
//       ),
//     );
//   }
// }


// import 'package:flutter/material.dart';
// import '../services/api_service.dart';

// class ExitPage extends StatefulWidget {
//   @override
//   _ExitPageState createState() => _ExitPageState();
// }

// class _ExitPageState extends State<ExitPage> {
//   String scannedRFID = "Waiting for RFID scan...";

//   @override
//   void initState() {
//     super.initState();
    
//     // Listen for RFID exit scans
//     ApiService.listenToExitWebSocket((rfid) {
//       print("🔄 Scanned Exit RFID: $rfid");
//       setState(() {
//         scannedRFID = "Scanned RFID: $rfid";
//       });
//     });
//   }

//   @override
//   void dispose() {
//     ApiService.disposeWebSockets(); // Close WebSocket when exiting the page
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Exit User')),
//       body: Center(
//         child: Text(
//           scannedRFID,
//           style: TextStyle(fontSize: 18),
//         ),
//       ),
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import '../services/api_service.dart';

// class ExitPage extends StatefulWidget {
//   @override
//   _ExitPageState createState() => _ExitPageState();
// }

// class _ExitPageState extends State<ExitPage> {
//   String scannedRFID = "Waiting for RFID scan...";
//   bool isConfirmingExit = false;

//   @override
//   void initState() {
//     super.initState();
    
//     // Listen for RFID exit scans
//     ApiService.listenToExitWebSocket((rfid) {
//       print("🔄 Scanned Exit RFID: $rfid");
//       setState(() {
//         scannedRFID = "Scanned RFID: $rfid";
//       });
//     });
//   }

//   @override
//   void dispose() {
//     ApiService.disposeWebSockets(); // Close WebSocket when exiting the page
//     super.dispose();
//   }

//   void confirmExit() async {
//     if (scannedRFID == "Waiting for RFID scan...") {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("⚠️ No RFID scanned! Please scan an RFID first.")),
//       );
//       return;
//     }

//     bool wantsReceipt = false;

//     // Show confirmation dialog
//     await showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: Text("Confirm Exit"),
//         content: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Text("Do you want to proceed with the exit?"),
//             SizedBox(height: 10),
//             CheckboxListTile(
//               title: Text("Print receipt?"),
//               value: wantsReceipt,
//               onChanged: (value) {
//                 setState(() {
//                   wantsReceipt = value ?? false;
//                 });
//               },
//             ),
//           ],
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: Text("Cancel"),
//           ),
//           ElevatedButton(
//             onPressed: () async {
//               Navigator.pop(context);
//               processExit(scannedRFID, wantsReceipt);
//             },
//             child: Text("Confirm Exit"),
//           ),
//         ],
//       ),
//     );
//   }

//   void processExit(String rfid, bool wantsReceipt) async {
//     setState(() => isConfirmingExit = true);

//     bool success = await ApiService.exitUser(rfid);
//     if (success) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("✅ Exit successful!")),
//       );

//       // Navigate back to Exit Dashboard
//       Navigator.pop(context);
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

class ExitPage extends StatefulWidget {
  @override
  _ExitPageState createState() => _ExitPageState();
}

class _ExitPageState extends State<ExitPage> {
  String scannedRFID = "Waiting for RFID scan...";
  bool isConfirmingExit = false;
  String? lastRFID;

  @override
  void initState() {
    super.initState();

    // Listen for a single RFID scan only
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
    ApiService.disposeWebSockets(); // Close socket when exiting page
    super.dispose();
  }

  void confirmExit() async {
    if (lastRFID == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("⚠️ No RFID scanned! Please scan an RFID first.")),
      );
      return;
    }

    // Confirmation dialog (no receipt option yet)
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Confirm Exit"),
        content: Text("Do you want to proceed with exiting UID: $lastRFID?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              processExit(lastRFID!);
            },
            child: Text("Confirm Exit"),
          ),
        ],
      ),
    );
  }

  void processExit(String rfid) async {
    setState(() => isConfirmingExit = true);

    bool success = await ApiService.exitUser(rfid);
    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("✅ Exit successful!")),
      );
      Navigator.pop(context, true); // Notify parent to refresh
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("❌ Exit failed. Please try again.")),
      );
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
