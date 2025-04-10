
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
