// import 'package:flutter/material.dart';
// import '../services/api_service.dart';

// class AddUserPage extends StatefulWidget {
//   @override
//   _AddUserPageState createState() => _AddUserPageState();
// }

// class _AddUserPageState extends State<AddUserPage> {
//   final ApiService apiService = ApiService();
//   final TextEditingController nameController = TextEditingController();
//   final TextEditingController plateController = TextEditingController();
//   final TextEditingController rfidController = TextEditingController();

//   void _submitUser() async {
//     bool success = await apiService.addUser(
//       nameController.text,
//       plateController.text,
//       rfidController.text,
//     );

//     if (success) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("User added successfully")),
//       );
//       Navigator.pop(context);
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("Failed to add user")),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("Add User")),
//       body: Padding(
//         padding: EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             TextField(
//               controller: nameController,
//               decoration: InputDecoration(labelText: "Name"),
//             ),
//             TextField(
//               controller: plateController,
//               decoration: InputDecoration(labelText: "Plate No"),
//             ),
//             TextField(
//               controller: rfidController,
//               decoration: InputDecoration(labelText: "RFID"),
//             ),
//             SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: _submitUser,
//               child: Text("Add User"),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:web_socket_channel/io.dart';
// import 'package:web_socket_channel/web_socket_channel.dart';
// import '../services/api_service.dart';

// IOWebSocketChannel channel = IOWebSocketChannel.connect('ws://10.0.2.2:3000');


// class AddUserPage extends StatefulWidget {
//   const AddUserPage({Key? key}) : super(key: key);

//   @override
//   State<AddUserPage> createState() => _AddUserPageState();
// }

// class _AddUserPageState extends State<AddUserPage> {
//   final apiService = ApiService();
//   final TextEditingController nameController = TextEditingController();
//   final TextEditingController plateNoController = TextEditingController();
//   String scannedRFID = '';

//   late WebSocketChannel channel;

//   @override
//   void initState() {
//     super.initState();
//     channel = IOWebSocketChannel.connect('ws://YOUR_LOCAL_IP:3000');
//     channel.stream.listen((message) {
//       setState(() {
//         scannedRFID = message;
//       });
//     });
//   }

//   @override
//   void dispose() {
//     channel.sink.close();
//     nameController.dispose();
//     plateNoController.dispose();
//     super.dispose();
//   }

//   void submitUser() async {
//     if (nameController.text.isEmpty || plateNoController.text.isEmpty || scannedRFID.isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Please complete all fields and scan RFID.')),
//       );
//       return;
//     }

//     bool success = await apiService.addUser(
//       nameController.text,
//       plateNoController.text,
//       scannedRFID,
//     );

//     if (success) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('User added successfully!')),
//       );
//       nameController.clear();
//       plateNoController.clear();
//       setState(() {
//         scannedRFID = '';
//       });
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Failed to add user.')),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Entrance - Add User'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(20),
//         child: Column(
//           children: [
//             const Text(
//               'Scan RFID and Add User Details',
//               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 20),
//             TextField(
//               controller: nameController,
//               decoration: const InputDecoration(
//                 labelText: 'Name',
//                 border: OutlineInputBorder(),
//               ),
//             ),
//             const SizedBox(height: 15),
//             TextField(
//               controller: plateNoController,
//               decoration: const InputDecoration(
//                 labelText: 'Plate Number',
//                 border: OutlineInputBorder(),
//               ),
//             ),
//             const SizedBox(height: 15),
//             Container(
//               padding: const EdgeInsets.all(16),
//               width: double.infinity,
//               decoration: BoxDecoration(
//                 color: Colors.blue[50],
//                 border: Border.all(color: Colors.blueAccent),
//                 borderRadius: BorderRadius.circular(10),
//               ),
//               child: Text(
//                 scannedRFID.isNotEmpty ? 'RFID: $scannedRFID' : 'Waiting for RFID scan...',
//                 style: TextStyle(
//                   fontSize: 16,
//                   color: scannedRFID.isNotEmpty ? Colors.black : Colors.grey,
//                 ),
//               ),
//             ),
//             const SizedBox(height: 25),
//             ElevatedButton.icon(
//               icon: const Icon(Icons.save),
//               label: const Text('Submit User'),
//               onPressed: submitUser,
//               style: ElevatedButton.styleFrom(
//                 padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:web_socket_channel/io.dart';
// import 'package:web_socket_channel/web_socket_channel.dart';
// import '../services/api_service.dart';

// class AddUserPage extends StatefulWidget {
//   const AddUserPage({Key? key}) : super(key: key);

//   @override
//   State<AddUserPage> createState() => _AddUserPageState();
// }

// class _AddUserPageState extends State<AddUserPage> {
//   final apiService = ApiService();
  
//   final TextEditingController _nameController = TextEditingController();
//   final TextEditingController _plateController = TextEditingController();

//   late WebSocketChannel channel;
//   String scannedRFID = '';

//   @override
//   void initState() {
//     super.initState();
//     channel = IOWebSocketChannel.connect('ws://localhost:3000');
//     channel.stream.listen((message) {
//       setState(() {
//         scannedRFID = message;
//       });
//     });
//   }

//   @override
//   void dispose() {
//     channel.sink.close();
//     super.dispose();
//   }

//   void _addUser() async {
//     final name = _nameController.text;
//     final plate = _plateController.text;

//     if (name.isEmpty || plate.isEmpty || scannedRFID.isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Please complete all fields and scan RFID')),
//       );
//       return;
//     }

//     final success = await ApiService.addUser(name, plate, scannedRFID);

//     if (success) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('User added successfully')),
//       );
//       _nameController.clear();
//       _plateController.clear();
//       setState(() {
//         scannedRFID = '';
//       });
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Failed to add user')),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Add User')),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             TextField(controller: _nameController, decoration: const InputDecoration(labelText: 'Name')),
//             TextField(controller: _plateController, decoration: const InputDecoration(labelText: 'Plate Number')),
//             const SizedBox(height: 16),
//             Text('Scanned RFID: $scannedRFID', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
//             const SizedBox(height: 24),
//             ElevatedButton(onPressed: _addUser, child: const Text('Add User')),
//           ],
//         ),
//       ),
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:web_socket_channel/io.dart';
// import 'package:web_socket_channel/web_socket_channel.dart';
// import '../services/api_service.dart';

// class AddUserPage extends StatefulWidget {
//   const AddUserPage({Key? key}) : super(key: key);

//   @override
//   State<AddUserPage> createState() => _AddUserPageState();
// }

// class _AddUserPageState extends State<AddUserPage> {
//   final TextEditingController _nameController = TextEditingController();
//   final TextEditingController _plateController = TextEditingController();
//   String scannedRFID = '';

//   // Use the local IP address if testing on an emulator (10.0.2.2) or update accordingly.
//   late WebSocketChannel channel;

//   @override
//   void initState() {
//     super.initState();
//     // Connect to your backend WebSocket server (update IP and port as needed)
//     channel = IOWebSocketChannel.connect(Uri.parse('ws://10.0.2.2:3000'));
//     channel.stream.listen((message) {
//       // We assume the message is a plain string UID from the ESP32 scanner.
//       setState(() {
//         scannedRFID = message.toString().trim();
//       });
//     });
//   }

//   @override
//   void dispose() {
//     channel.sink.close();
//     _nameController.dispose();
//     _plateController.dispose();
//     super.dispose();
//   }

//   Future<void> _submitUser() async {
//     final name = _nameController.text.trim();
//     final plate = _plateController.text.trim();

//     if (name.isEmpty || plate.isEmpty || scannedRFID.isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Please complete all fields and scan RFID.')),
//       );
//       return;
//     }

//     bool success = await ApiService.addUser(name, plate, scannedRFID);
//     if (success) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('User added successfully!')),
//       );
//       _nameController.clear();
//       _plateController.clear();
//       setState(() {
//         scannedRFID = '';
//       });
//       // Navigate back or refresh dashboard as needed.
//       Navigator.pop(context);
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Failed to add user.')),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Entrance - Add User')),
//       body: Padding(
//         padding: const EdgeInsets.all(20),
//         child: Column(
//           children: [
//             const Text(
//               'Scan RFID and Add User Details',
//               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 20),
//             TextField(
//               controller: _nameController,
//               decoration: const InputDecoration(
//                 labelText: 'Name',
//                 border: OutlineInputBorder(),
//               ),
//             ),
//             const SizedBox(height: 15),
//             TextField(
//               controller: _plateController,
//               decoration: const InputDecoration(
//                 labelText: 'Plate Number',
//                 border: OutlineInputBorder(),
//               ),
//             ),
//             const SizedBox(height: 15),
//             Container(
//               padding: const EdgeInsets.all(16),
//               width: double.infinity,
//               decoration: BoxDecoration(
//                 color: Colors.blue[50],
//                 border: Border.all(color: Colors.blueAccent),
//                 borderRadius: BorderRadius.circular(10),
//               ),
//               child: Text(
//                 scannedRFID.isNotEmpty ? 'RFID: $scannedRFID' : 'Waiting for RFID scan...',
//                 style: TextStyle(
//                   fontSize: 16,
//                   color: scannedRFID.isNotEmpty ? Colors.black : Colors.grey,
//                 ),
//               ),
//             ),
//             const SizedBox(height: 25),
//             ElevatedButton.icon(
//               icon: const Icon(Icons.save),
//               label: const Text('Submit User'),
//               onPressed: _submitUser,
//               style: ElevatedButton.styleFrom(
//                 padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }


// import 'dart:convert';

// import 'package:flutter/material.dart';
// import 'package:web_socket_channel/io.dart';
// import 'package:web_socket_channel/status.dart' as status;
// import '../services/api_service.dart';

// class AddUserPage extends StatefulWidget {
//   const AddUserPage({Key? key}) : super(key: key);

//   @override
//   State<AddUserPage> createState() => _AddUserPageState();
// }

// class _AddUserPageState extends State<AddUserPage> {
//   final TextEditingController nameController = TextEditingController();
//   final TextEditingController plateController = TextEditingController();
//   String? scannedRFID;

//   late IOWebSocketChannel channel;

//   @override
//   void initState() {
//     super.initState();

//     // Connect to WebSocket server (adjust IP to your backend)
//     channel = IOWebSocketChannel.connect('ws://192.168.100.201:3001/ws/entrance ');


//     // Listen for RFID data
//     // channel.stream.listen((message) {
//     //   setState(() {
//     //     scannedRFID = message;
//     //   });
//     // }, onError: (error) {
//     //   print('WebSocket error: $error');
//     // });
// //       channel.stream.listen((message) {
// //       print("Received WebSocket message: $message"); // Debugging
// //       setState(() {
// //         scannedRFID = message;
// //       });
// //     }, onError: (error) {
// //       print('WebSocket error: $error');
// // });    


// channel.stream.listen((data) {
//   print("Raw WebSocket data: $data");
//   try {
//     final decoded = jsonDecode(data);
//     setState(() {
//       scannedRFID = decoded['rfid_uid'];
//     });
//     print("Decoded UID: ${decoded['rfid_uid']}");
//   } catch (e) {
//     print("Error decoding WebSocket message: $e");
//   }
// });



//   }

//   void addUser() async {
//     if (scannedRFID == null ||
//         nameController.text.isEmpty ||
//         plateController.text.isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Please fill all fields and scan an RFID')),
//       );
//       return;
//     }

//     final success = await ApiService.addUser(
//       nameController.text,
//       plateController.text,
//       scannedRFID!,
//     );

//     if (success) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('User added successfully')),
//       );
//       nameController.clear();
//       plateController.clear();
//       setState(() => scannedRFID = null);
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Failed to add user')),
//       );
//     }
//   }

//   @override
//   void dispose() {
//     channel.sink.close(status.goingAway);
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Add User')),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(children: [
//           TextField(
//               controller: nameController,
//               decoration: InputDecoration(labelText: 'Name')),
//           TextField(
//               controller: plateController,
//               decoration: InputDecoration(labelText: 'Plate Number')),
//           SizedBox(height: 20),
//           Text('Scanned RFID: ${scannedRFID ?? "Waiting..."}'),
//           SizedBox(height: 20),
//           ElevatedButton(onPressed: addUser, child: Text('Submit')),
//         ]),
//       ),
//     );
//   }
// }


// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:web_socket_channel/web_socket_channel.dart';


// class AddUserPage extends StatefulWidget {
//   @override
//   _AddUserPageState createState() => _AddUserPageState();
// }

// class _AddUserPageState extends State<AddUserPage> {
//   final TextEditingController _nameController = TextEditingController();
//   final TextEditingController _plateController = TextEditingController();
//   String scannedRFID = "Waiting...";

//   late WebSocketChannel channel;

//   @override
//   void initState() {
//     super.initState();
//     // Connect to WebSocket server
//     channel = WebSocketChannel.connect(
//       Uri.parse('ws://192.168.100.201:3001/ws/entrance'),
//     );

//     // Listen for incoming RFID scans
//     channel.stream.listen((message) {
//       try {
//         final decodedMessage = jsonDecode(message);
//         if (decodedMessage['success'] == true && decodedMessage['rfid'] != null) {
//           setState(() {
//             scannedRFID = decodedMessage['rfid'];  // Update UI
//           });
//         } else {
//           print("⚠️ Error: Invalid WebSocket message format");
//         }
//       } catch (e) {
//         print("❌ WebSocket Error: $e");
//       }
//     });
//   }

//   @override
//   void dispose() {
//     channel.sink.close(); // Close WebSocket when page is disposed
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("Add User")),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             TextField(
//               controller: _nameController,
//               decoration: InputDecoration(labelText: "Name"),
//             ),
//             TextField(
//               controller: _plateController,
//               decoration: InputDecoration(labelText: "Plate Number"),
//             ),
//             SizedBox(height: 20),
//             Text("Scanned RFID: $scannedRFID",
//                 style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//             SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: () {
//                 // Handle user submission here
//                 print("User submitted with RFID: $scannedRFID");
//               },
//               child: Text("Submit"),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'dart:convert';
// import 'package:web_socket_channel/io.dart';
// import '../services/api_service.dart'; // Import ApiService

// class AddUserPage extends StatefulWidget {
//   @override
//   _AddUserPageState createState() => _AddUserPageState();
// }

// class _AddUserPageState extends State<AddUserPage> {
//   final TextEditingController _nameController = TextEditingController();
//   final TextEditingController _plateController = TextEditingController();
//   String scannedRFID = "Waiting...";
//   late IOWebSocketChannel channel;

//   @override
//   void initState() {
//     super.initState();
//     _initWebSocket();
//   }

//   void _initWebSocket() {
//     channel = IOWebSocketChannel.connect('ws://192.168.100.201:3001/ws/entrance');

//     channel.stream.listen((message) {
//       try {
//         Map<String, dynamic> data = jsonDecode(message);
//         if (data.containsKey('scanned_uid')) {
//           setState(() {
//             scannedRFID = data['scanned_uid'];
//           });
//           print("✅ RFID Updated: $scannedRFID");
//         }
//       } catch (e) {
//         print("⚠️ Error parsing WebSocket message: $e");
//       }
//     }, onError: (error) {
//       print("❌ WebSocket Error: $error");
//     });
//   }

//   @override
//   void dispose() {
//     channel.sink.close();
//     super.dispose();
//   }

//   void _submit() async {
//     if (scannedRFID == "Waiting...") {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("⚠️ Please scan an RFID before submitting!")),
//       );
//       return;
//     }

//     bool success = await ApiService.addUser(
//       _nameController.text.trim(),
//       _plateController.text.trim(),
//       scannedRFID, // Use the scanned RFID
//     );

//     if (success) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("✅ User Added Successfully!")),
//       );
//       _nameController.clear();
//       _plateController.clear();
//       setState(() => scannedRFID = "Waiting...");
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("❌ Failed to Add User")),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("Add User")),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             TextField(
//               controller: _nameController,
//               decoration: InputDecoration(labelText: "Name"),
//             ),
//             TextField(
//               controller: _plateController,
//               decoration: InputDecoration(labelText: "Plate Number"),
//             ),
//             SizedBox(height: 20),
//             Text(
//               "Scanned RFID: $scannedRFID",
//               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//             ),
//             SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: _submit,
//               child: Text("Submit"),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:web_socket_channel/io.dart';
import '../services/api_service.dart';

class AddUserPage extends StatefulWidget {
  @override
  _AddUserPageState createState() => _AddUserPageState();
}

class _AddUserPageState extends State<AddUserPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _plateController = TextEditingController();
  String scannedRFID = "Waiting...";
  late IOWebSocketChannel channel;

  @override
  void initState() {
    super.initState();
    _initWebSocket();
  }

  void _initWebSocket() {
    channel = IOWebSocketChannel.connect('ws://192.168.100.96:3001/ws/entrance');

    channel.stream.listen((message) {
      try {
        Map<String, dynamic> data = jsonDecode(message);
        if (data.containsKey('scanned_uid')) {
          setState(() {
            scannedRFID = data['scanned_uid'];
          });
          print("✅ RFID Updated: $scannedRFID");
        }
      } catch (e) {
        print("⚠️ Error parsing WebSocket message: $e");
      }
    }, onError: (error) {
      print("❌ WebSocket Error: $error");
    });
  }

  @override
  void dispose() {
    channel.sink.close();
    super.dispose();
  }

  void _submit() async {
  if (scannedRFID == "Waiting...") {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("⚠️ Please scan an RFID before submitting!")),
    );
    return;
  }

  bool success = await ApiService.addUser(
    _nameController.text.trim(),
    _plateController.text.trim(),
    scannedRFID,
  );

  if (success) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("✅ User Added Successfully!")),
    );
    _nameController.clear();
    _plateController.clear();
    setState(() => scannedRFID = "Waiting...");
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("❌ RFID is already in use by an active user")),
    );
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add User"),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 251, 252, 255),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: "Name",
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.person),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _plateController,
              decoration: InputDecoration(
                labelText: "Plate Number",
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.directions_car),
              ),
            ),
            SizedBox(height: 20),
            Center(
              child: Column(
                children: [
                  Text(
                    "Scanned RFID:",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  SizedBox(height: 5),
                  Container(
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.blue[50],
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.blueAccent, width: 1.5),
                    ),
                    child: Text(
                      scannedRFID,
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blueAccent),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _submit,
                icon: Icon(Icons.save),
                label: Text("Submit", style: TextStyle(fontSize: 16)),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 14),
                  backgroundColor: Colors.blueAccent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
