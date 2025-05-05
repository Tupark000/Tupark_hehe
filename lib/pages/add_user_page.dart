
// import 'package:flutter/material.dart';
// import 'dart:convert';
// import 'package:web_socket_channel/io.dart';
// import '../services/api_service.dart';

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
//   channel = IOWebSocketChannel.connect(
//     Uri.parse('wss://tuparkhehe-production.up.railway.app/ws'),
//   );

//   channel.stream.listen((message) {
//     try {
//       Map<String, dynamic> data = jsonDecode(message);
//       if (data.containsKey('scanned_uid')) {
//         setState(() {
//           scannedRFID = data['scanned_uid'];
//         });
//         print("✅ RFID Updated: $scannedRFID");
//       }
//     } catch (e) {
//       print("⚠️ Error parsing WebSocket message: $e");
//     }
//   }, onError: (error) {
//     print("❌ WebSocket Error: $error");
//   });
// }


//   @override
//   void dispose() {
//     channel.sink.close();
//     super.dispose();
//   }

//   void _submit() async {
//   if (scannedRFID == "Waiting...") {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text("⚠️ Please scan an RFID before submitting!")),
//     );
//     return;
//   }

//   bool success = await ApiService.addUser(
//     _nameController.text.trim(),
//     _plateController.text.trim(),
//     scannedRFID,
//   );

//   if (success) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text("✅ User Added Successfully!")),
//     );
//     _nameController.clear();
//     _plateController.clear();
//     setState(() => scannedRFID = "Waiting...");
//   } else {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text("❌ RFID is already in use by an active user")),
//     );
//   }
// }


//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Add User"),
//         centerTitle: true,
//         backgroundColor: const Color.fromARGB(255, 251, 252, 255),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             TextField(
//               controller: _nameController,
//               decoration: InputDecoration(
//                 labelText: "Name",
//                 border: OutlineInputBorder(),
//                 prefixIcon: Icon(Icons.person),
//               ),
//             ),
//             SizedBox(height: 16),
//             TextField(
//               controller: _plateController,
//               decoration: InputDecoration(
//                 labelText: "Plate Number",
//                 border: OutlineInputBorder(),
//                 prefixIcon: Icon(Icons.directions_car),
//               ),
//             ),
//             SizedBox(height: 20),
//             Center(
//               child: Column(
//                 children: [
//                   Text(
//                     "Scanned RFID:",
//                     style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
//                   ),
//                   SizedBox(height: 5),
//                   Container(
//                     padding: EdgeInsets.all(12),
//                     decoration: BoxDecoration(
//                       color: Colors.blue[50],
//                       borderRadius: BorderRadius.circular(10),
//                       border: Border.all(color: Colors.blueAccent, width: 1.5),
//                     ),
//                     child: Text(
//                       scannedRFID,
//                       style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blueAccent),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             SizedBox(height: 30),
//             SizedBox(
//               width: double.infinity,
//               child: ElevatedButton.icon(
//                 onPressed: _submit,
//                 icon: Icon(Icons.save),
//                 label: Text("Submit", style: TextStyle(fontSize: 16)),
//                 style: ElevatedButton.styleFrom(
//                   padding: EdgeInsets.symmetric(vertical: 14),
//                   backgroundColor: Colors.blueAccent,
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                 ),
//               ),
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
// import '../services/api_service.dart';

// class AddUserPage extends StatefulWidget {
//   @override
//   _AddUserPageState createState() => _AddUserPageState();
// }

// class _AddUserPageState extends State<AddUserPage> {
//   final TextEditingController _nameController = TextEditingController();
//   final TextEditingController _plateController = TextEditingController();
//   String scannedRFID = "Waiting for RFID scan...";
//   late IOWebSocketChannel channel;

//   @override
//   void initState() {
//     super.initState();
//     _initWebSocket();
//   }

//   void _initWebSocket() {
//     channel = IOWebSocketChannel.connect(
//       Uri.parse('wss://tuparkhehe-production.up.railway.app/ws'),
//     );

//     channel.stream.listen((message) {
//       try {
//         Map<String, dynamic> data = jsonDecode(message);
//         if (data.containsKey('scanned_uid') && data['type'] == 'ENTRANCE') {
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
//     if (scannedRFID == "Waiting for RFID scan...") {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("⚠️ Please scan an RFID before submitting!")),
//       );
//       return;
//     }

//     bool success = await ApiService.addUser(
//       _nameController.text.trim(),
//       _plateController.text.trim(),
//       scannedRFID,
//     );

//     if (success) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("✅ User Added Successfully!")),
//       );
//       _nameController.clear();
//       _plateController.clear();
//       setState(() => scannedRFID = "Waiting for RFID scan...");
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("❌ RFID is already in use by an active user")),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Add User"),
//         backgroundColor: Colors.white,
//         foregroundColor: Colors.red[800],
//         elevation: 1,
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             _buildTextField(
//               controller: _nameController,
//               label: "Name",
//               icon: Icons.person,
//             ),
//             const SizedBox(height: 20),
//             _buildTextField(
//               controller: _plateController,
//               label: "Plate Number",
//               icon: Icons.directions_car,
//             ),
//             const SizedBox(height: 28),
//             Center(
//               child: Column(
//                 children: [
//                   const Text(
//                     "Scanned RFID",
//                     style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
//                   ),
//                   const SizedBox(height: 8),
//                   Container(
//                     padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//                     decoration: BoxDecoration(
//                       color: Colors.red.shade50,
//                       borderRadius: BorderRadius.circular(12),
//                       border: Border.all(color: Colors.redAccent),
//                     ),
//                     child: Text(
//                       scannedRFID,
//                       style: const TextStyle(
//                         fontSize: 18,
//                         fontWeight: FontWeight.bold,
//                         color: Colors.redAccent,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             const SizedBox(height: 30),
//             SizedBox(
//               width: double.infinity,
//               child: ElevatedButton.icon(
//                 onPressed: _submit,
//                 icon: const Icon(Icons.save),
//                 label: const Text("Submit", style: TextStyle(fontSize: 16)),
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.redAccent,
//                   padding: const EdgeInsets.symmetric(vertical: 14),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildTextField({
//     required TextEditingController controller,
//     required String label,
//     required IconData icon,
//   }) {
//     return TextField(
//       controller: controller,
//       decoration: InputDecoration(
//         labelText: label,
//         filled: true,
//         fillColor: Colors.grey[100],
//         prefixIcon: Icon(icon, color: Colors.red),
//         border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
//         enabledBorder: OutlineInputBorder(
//           borderSide: BorderSide(color: Colors.red.shade100),
//           borderRadius: BorderRadius.circular(12),
//         ),
//         focusedBorder: OutlineInputBorder(
//           borderSide: BorderSide(color: Colors.red),
//           borderRadius: BorderRadius.circular(12),
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

// ⬆️ Keep all your existing imports

class _AddUserPageState extends State<AddUserPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _plateController = TextEditingController();
  String scannedRFID = "Waiting for RFID scan...";
  String? vehicleType; // ✅ New field
  late IOWebSocketChannel channel;

  // ... initState, _initWebSocket, dispose same as before

  void _submit() async {
    if (scannedRFID == "Waiting for RFID scan..." || vehicleType == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("⚠️ Please scan an RFID and select vehicle type.")),
      );
      return;
    }

    bool success = await ApiService.addUser(
      _nameController.text.trim(),
      _plateController.text.trim(),
      scannedRFID,
      vehicleType!, // ✅ Include vehicleType
    );

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("✅ User Added Successfully!")),
      );
      _nameController.clear();
      _plateController.clear();
      setState(() {
        scannedRFID = "Waiting for RFID scan...";
        vehicleType = null;
      });
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
        title: const Text("Add User"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.red[800],
        elevation: 1,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTextField(
              controller: _nameController,
              label: "Name",
              icon: Icons.person,
            ),
            const SizedBox(height: 20),
            _buildTextField(
              controller: _plateController,
              label: "Plate Number",
              icon: Icons.directions_car,
            ),
            const SizedBox(height: 20),
            _buildDropdown(),
            const SizedBox(height: 28),
            Center(
              child: Column(
                children: [
                  const Text("Scanned RFID", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: Colors.red.shade50,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.redAccent),
                    ),
                    child: Text(
                      scannedRFID,
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.redAccent),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _submit,
                icon: const Icon(Icons.save),
                label: const Text("Submit", style: TextStyle(fontSize: 16)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 🧱 Reusable TextField Widget
  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
  }) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: Colors.grey[100],
        prefixIcon: Icon(icon, color: Colors.red),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.red.shade100),
          borderRadius: BorderRadius.circular(12),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.red),
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  // 🔻 Dropdown for vehicle type
  Widget _buildDropdown() {
    return DropdownButtonFormField<String>(
      value: vehicleType,
      decoration: InputDecoration(
        labelText: "Vehicle Type",
        prefixIcon: Icon(Icons.two_wheeler, color: Colors.red),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        filled: true,
        fillColor: Colors.grey[100],
      ),
      items: ["Motorcycle", "Car"].map((type) {
        return DropdownMenuItem(
          value: type,
          child: Text(type),
        );
      }).toList(),
      onChanged: (value) {
        setState(() => vehicleType = value);
      },
    );
  }
}
