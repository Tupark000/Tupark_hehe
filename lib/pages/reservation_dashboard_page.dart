
import 'package:flutter/material.dart';
import '../services/api_service.dart';
import 'reservation_page.dart';

class ReservationDashboardPage extends StatefulWidget {
  const ReservationDashboardPage({Key? key}) : super(key: key);

  @override
  State<ReservationDashboardPage> createState() => _ReservationDashboardPageState();
}

class _ReservationDashboardPageState extends State<ReservationDashboardPage> {
  List reservations = [];

  @override
  void initState() {
    super.initState();
    fetchReservations();
  }

  Future<void> fetchReservations() async {
    try {
      final response = await ApiService.fetchReservations(); // You’ll define this
      setState(() {
        reservations = response;
      });
    } catch (e) {
      print("❌ Error fetching reservations: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Reservation Dashboard")),
      body: RefreshIndicator(
        onRefresh: fetchReservations,
        child: reservations.isEmpty
            ? Center(child: Text("No reservations yet."))
            : ListView.builder(
                itemCount: reservations.length,
                itemBuilder: (context, index) {
                  final res = reservations[index];
                  return ListTile(
                    title: Text(res['name']),
                    subtitle: Text("Plate: ${res['plate_number']}"),
                    trailing: Text(res['expected_time_in']),
                  );
                },
              ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        icon: Icon(Icons.add),
        label: Text("Add Reservation"),
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => ReservationPage()),
          );
          if (result == true) {
            fetchReservations(); // Refresh after new reservation
          }
        },
      ),
    );
  }
}
