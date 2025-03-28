import 'package:flutter/material.dart';
import '../services/api_service.dart';
import 'dart:async';

class ReservationPage extends StatefulWidget {
  @override
  _ReservationPageState createState() => _ReservationPageState();
}

class _ReservationPageState extends State<ReservationPage> {
  final ApiService apiService = ApiService();
  List<dynamic> reservations = [];

  @override
  void initState() {
    super.initState();
    loadReservations();
    startAutoTransfer(); // Automatically transfer reservations when time comes
  }

  Future<void> loadReservations() async {
    try {
      List<dynamic> data = await apiService.fetchReservations();
      setState(() {
        reservations = data;
      });
    } catch (e) {
      print("Error loading reservations: $e");
    }
  }

  void startAutoTransfer() {
  Timer.periodic(Duration(minutes: 1), (timer) {
    Future.microtask(() async {
      await apiService.transferReservation(); // Calls API
      loadReservations(); // Refresh reservation list
    });
  });
  }


  void showAddReservationDialog() {
    TextEditingController nameController = TextEditingController();
    TextEditingController plateController = TextEditingController();
    TextEditingController rfidController = TextEditingController();
    TextEditingController timeController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Add Reservation"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: nameController, decoration: InputDecoration(labelText: "Name")),
            TextField(controller: plateController, decoration: InputDecoration(labelText: "Plate No")),
            TextField(controller: rfidController, decoration: InputDecoration(labelText: "Scan RFID")),
            TextField(controller: timeController, decoration: InputDecoration(labelText: "Expected Time (HH:MM)")),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () async {
              await apiService.addReservation(
                nameController.text,
                plateController.text,
                rfidController.text,
                timeController.text,
              );
              loadReservations(); // Refresh list
              Navigator.pop(context);
            },
            child: Text("Add"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Reservations")),
      body: ListView.builder(
        itemCount: reservations.length,
        itemBuilder: (context, index) {
          final res = reservations[index];
          return ListTile(
            title: Text(res["name"]),
            subtitle: Text("Plate No: ${res["plate_no"]} - Expected: ${res["expected_time"]}"),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: showAddReservationDialog,
        child: Icon(Icons.add),
      ),
    );
  }
}
