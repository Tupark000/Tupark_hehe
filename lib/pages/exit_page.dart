import 'package:flutter/material.dart';
import '../services/api_service.dart';

class ExitPage extends StatefulWidget {
  @override
  _ExitPageState createState() => _ExitPageState();
}

class _ExitPageState extends State<ExitPage> {
  final ApiService apiService = ApiService();
  TextEditingController rfidController = TextEditingController();
  bool showReceiptDialog = false; // Auto-dismiss alert state

  Future<void> deactivateUser() async {
    String rfid = rfidController.text;
    if (rfid.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please scan an RFID tag")),
      );
      return;
    }

    bool success = await apiService.deactivateUser(rfid);
    if (success) {
      setState(() {
        showReceiptDialog = true;
      });

      // Auto-dismiss alert after 10 seconds
      Future.delayed(Duration(seconds: 10), () {
        if (mounted) {
          setState(() {
            showReceiptDialog = false;
          });
        }
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("RFID not found or already inactive")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Exit Dashboard")),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(16.0),
            child: TextField(
              controller: rfidController,
              decoration: InputDecoration(
                labelText: "Scan RFID",
                border: OutlineInputBorder(),
              ),
              readOnly: true, // Ensure the user scans the RFID instead of typing
            ),
          ),
          ElevatedButton(
            onPressed: deactivateUser,
            child: Text("Exit"),
          ),
          if (showReceiptDialog)
            AlertDialog(
              title: Text("Print Receipt?"),
              content: Text("Do you want a printed receipt?"),
              actions: [
                TextButton(
                  onPressed: () {
                    setState(() {
                      showReceiptDialog = false;
                    });
                  },
                  child: Text("No"),
                ),
                TextButton(
                  onPressed: () {
                    // Implement print function here
                    setState(() {
                      showReceiptDialog = false;
                    });
                  },
                  child: Text("Yes"),
                ),
              ],
            ),
        ],
      ),
    );
  }
}
