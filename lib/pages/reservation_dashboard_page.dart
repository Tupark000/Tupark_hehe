
// import 'package:flutter/material.dart';
// import '../services/api_service.dart';
// import 'reservation_page.dart';

// class ReservationDashboardPage extends StatefulWidget {
//   const ReservationDashboardPage({Key? key}) : super(key: key);

//   @override
//   State<ReservationDashboardPage> createState() => _ReservationDashboardPageState();
// }

// class _ReservationDashboardPageState extends State<ReservationDashboardPage> {
//   List reservations = [];

//   @override
//   void initState() {
//     super.initState();
//     fetchReservations();
//   }

//   Future<void> fetchReservations() async {
//     try {
//       final response = await ApiService.fetchReservations(); // You’ll define this
//       setState(() {
//         reservations = response;
//       });
//     } catch (e) {
//       print("❌ Error fetching reservations: $e");
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("Reservation Dashboard")),
//       body: RefreshIndicator(
//         onRefresh: fetchReservations,
//         child: reservations.isEmpty
//             ? Center(child: Text("No reservations yet."))
//             : ListView.builder(
//                 itemCount: reservations.length,
//                 itemBuilder: (context, index) {
//                   final res = reservations[index];
//                   return ListTile(
//                     title: Text(res['name']),
//                     subtitle: Text("Plate: ${res['plate_number']}"),
//                     trailing: Text(res['expected_time_in']),
//                   );
//                 },
//               ),
//       ),
//       floatingActionButton: FloatingActionButton.extended(
//         icon: Icon(Icons.add),
//         label: Text("Add Reservation"),
//         onPressed: () async {
//           final result = await Navigator.push(
//             context,
//             MaterialPageRoute(builder: (_) => ReservationPage()),
//           );
//           if (result == true) {
//             fetchReservations(); // Refresh after new reservation
//           }
//         },
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import '../services/api_service.dart';
import 'reservation_page.dart';
import 'package:intl/intl.dart';

class ReservationDashboardPage extends StatefulWidget {
  const ReservationDashboardPage({Key? key}) : super(key: key);

  @override
  State<ReservationDashboardPage> createState() => _ReservationDashboardPageState();
}

class _ReservationDashboardPageState extends State<ReservationDashboardPage> {
  List reservations = [];
  List filteredReservations = [];
  String searchQuery = "";

  @override
  void initState() {
    super.initState();
    fetchReservations();
  }

  Future<void> fetchReservations() async {
    try {
      final response = await ApiService.fetchReservations();
      setState(() {
        reservations = response;
        filterReservations();
      });
    } catch (e) {
      print("❌ Error fetching reservations: $e");
    }
  }

  void filterReservations() {
    setState(() {
      filteredReservations = reservations.where((res) {
        final name = res['name'].toString().toLowerCase();
        final plate = res['plate_number'].toString().toLowerCase();
        final rfid = res['rfid_uid'].toString().toLowerCase();
        return name.contains(searchQuery) ||
            plate.contains(searchQuery) ||
            rfid.contains(searchQuery);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Reservation Dashboard"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.redAccent,
        elevation: 1,
      ),
      body: Column(
        children: [
          // Summary & Search
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Column(
              children: [
                // Summary
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Total: ${filteredReservations.length}",
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.black87)),
                    Text(
                        "Unique UIDs: ${filteredReservations.map((e) => e['rfid_uid']).toSet().length}",
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.black87)),
                  ],
                ),
                const SizedBox(height: 10),
                // Search
                TextField(
                  decoration: InputDecoration(
                    hintText: "Search by name, plate, or RFID UID...",
                    prefixIcon: const Icon(Icons.search),
                    filled: true,
                    fillColor: Colors.red[50],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.redAccent),
                    ),
                  ),
                  onChanged: (value) {
                    searchQuery = value.toLowerCase();
                    filterReservations();
                  },
                ),
              ],
            ),
          ),
          // List
          Expanded(
            child: RefreshIndicator(
              onRefresh: fetchReservations,
              child: filteredReservations.isEmpty
                  ? const Center(child: Text("No reservations yet.", style: TextStyle(color: Colors.grey)))
                  : ListView.builder(
                      itemCount: filteredReservations.length,
                      itemBuilder: (context, index) {
                        final res = filteredReservations[index];
                        final formattedTime = DateFormat('yyyy-MM-dd HH:mm').format(
                            DateTime.tryParse(res['expected_time_in']) ?? DateTime.now());

                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          child: Card(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            elevation: 2,
                            child: ListTile(
                              leading: Icon(Icons.event_note, color: Colors.redAccent),
                              title: Text(res['name'],
                                  style: const TextStyle(fontWeight: FontWeight.w600)),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("RFID: ${res['rfid_uid']}", style: const TextStyle(fontSize: 12)),
                                  Text("Plate: ${res['plate_number']}", style: const TextStyle(fontSize: 12)),
                                  Text("Expected In: $formattedTime", style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.redAccent,
        icon: const Icon(Icons.add),
        label: const Text("Add Reservation"),
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => ReservationPage()),
          );
          if (result == true) fetchReservations();
        },
      ),
    );
  }
}
