
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../services/api_service.dart';

class ReservationPage extends StatefulWidget {
  const ReservationPage({Key? key}) : super(key: key);

  @override
  State<ReservationPage> createState() => _ReservationPageState();
}

class _ReservationPageState extends State<ReservationPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _plateController = TextEditingController();
  DateTime? _selectedDateTime;
  String scannedRFID = "Waiting for scan...";
  String? lastRFID;

  @override
  void initState() {
    super.initState();

    // Listen for RFID UID from Entrance WebSocket
    ApiService.listenToEntranceWebSocket((rfid) {
      setState(() {
        scannedRFID = "Scanned UID: $rfid";
        lastRFID = rfid;
      });
    });
  }

  @override
  void dispose() {
    ApiService.disposeWebSockets();
    super.dispose();
  }

  Future<void> _pickDateTime() async {
    final DateTime? date = await showDatePicker(
      context: context,
      initialDate: _selectedDateTime ?? DateTime.now(),
      firstDate: DateTime.now().subtract(Duration(days: 1)),
      lastDate: DateTime.now().add(Duration(days: 30)),
    );

    if (date != null) {
      final TimeOfDay? time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(_selectedDateTime ?? DateTime.now()),
      );

      if (time != null) {
        setState(() {
          _selectedDateTime = DateTime(
            date.year,
            date.month,
            date.day,
            time.hour,
            time.minute,
          );
        });
      }
    }
  }

  void _submitReservation() async {
    if (_nameController.text.isEmpty ||
        _plateController.text.isEmpty ||
        lastRFID == null ||
        _selectedDateTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("⚠️ Please fill all fields and scan an RFID.")),
      );
      return;
    }

    final success = await ApiService.addReservation(
      name: _nameController.text.trim(),
      plate: _plateController.text.trim(),
      rfid: lastRFID!,
      expectedTime: _selectedDateTime!.toIso8601String(),
    );

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("✅ Reservation added successfully!")),
      );
      _nameController.clear();
      _plateController.clear();
      setState(() {
        scannedRFID = "Waiting for scan...";
        lastRFID = null;
        _selectedDateTime = null;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("❌ Failed to add reservation")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final formattedDateTime = _selectedDateTime != null
        ? DateFormat.yMMMd().add_jm().format(_selectedDateTime!)
        : "Pick expected date and time";

    return Scaffold(
      appBar: AppBar(title: Text("Add Reservation")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: "Name"),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _plateController,
              decoration: InputDecoration(labelText: "Plate Number"),
            ),
            SizedBox(height: 20),
            ListTile(
              title: Text("Expected Time: $formattedDateTime"),
              trailing: Icon(Icons.calendar_today),
              onTap: _pickDateTime,
            ),
            SizedBox(height: 20),
            Column(
              children: [
                Text("Scanned RFID UID:"),
                SizedBox(height: 8),
                Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.blue[50],
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.blueAccent),
                  ),
                  child: Text(
                    scannedRFID,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: _submitReservation,
              child: Text("Reserve"),
            ),
          ],
        ),
      ),
    );
  }
}
