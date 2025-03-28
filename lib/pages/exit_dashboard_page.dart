import 'package:flutter/material.dart';
import '../services/api_service.dart';

class ExitDashboardPage extends StatefulWidget {
  @override
  _ExitDashboardPageState createState() => _ExitDashboardPageState();
}

class _ExitDashboardPageState extends State<ExitDashboardPage> {
  final ApiService apiService = ApiService();
  TextEditingController rfidController = TextEditingController();
  bool isProcessing = false;

  void scanAndExitUser() async {
    String rfid = rfidController.text.trim();

    if (rfid.isEmpty) {
      showErrorDialog("Please scan an RFID tag first.");
      return;
    }

    setState(() => isProcessing = true);

    bool success = await apiService.exitUser(rfid);
    setState(() => isProcessing = false);
 
    if (success) {
      showExitAlert();
      rfidController.clear();
    } else {
      showErrorDialog("Failed to exit user. Make sure RFID is active.");
    }
  }

  void showExitAlert() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Print Receipt?"),
          content: Text("Would you like a printed receipt?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Yes"),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("No"),
            ),
          ],
        );
      },
    );

    Future.delayed(Duration(seconds: 10), () {
      Navigator.pop(context); // Auto-dismiss alert
    });
  }

  void showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Error"),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("OK"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Exit Dashboard")),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Scan RFID to Exit", style: TextStyle(fontSize: 18)),
            SizedBox(height: 20),
            TextField(
              controller: rfidController,
              textAlign: TextAlign.center,
              decoration: InputDecoration(
                hintText: "Scan RFID Here",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: isProcessing ? null : scanAndExitUser,
              child: isProcessing
                  ? CircularProgressIndicator()
                  : Text("Exit User"),
            ),
          ],
        ),
      ),
    );
  }
}
