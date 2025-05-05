
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import '../services/api_service.dart';
// import 'exit_page.dart';

// class ExitDashboardPage extends StatefulWidget {
//   const ExitDashboardPage({Key? key}) : super(key: key);

//   @override
//   State<ExitDashboardPage> createState() => _ExitDashboardPageState();
// }

// class _ExitDashboardPageState extends State<ExitDashboardPage> {
//   List users = [];
//   DateTime? selectedDate;
//   bool showAll = false;

//   @override
//   void initState() {
//     super.initState();
//     fetchUsers();
//     ApiService.listenToExitWebSocket((rfid) {
//       fetchUsers();
//     });
//   }

//   Future<void> fetchUsers() async {
//     try {
//       final data = await ApiService.fetchInactiveUsers();
//       final targetDate = selectedDate ?? DateTime.now();

//       setState(() {
//         users = data.where((user) {
//           if (showAll) return true;

//           final rawTimeOut = user['time_out'];
//           if (rawTimeOut == null) return false;

//           final parsed = DateTime.tryParse(rawTimeOut);
//           if (parsed == null) return false;

//           return parsed.year == targetDate.year &&
//               parsed.month == targetDate.month &&
//               parsed.day == targetDate.day;
//         }).toList()
//           ..sort((a, b) {
//             final aTime = DateTime.tryParse(a['time_out'] ?? '') ?? DateTime(2000);
//             final bTime = DateTime.tryParse(b['time_out'] ?? '') ?? DateTime(2000);
//             return bTime.compareTo(aTime); // Latest first
//           });
//       });
//     } catch (e) {
//       print("❌ Error fetching inactive users: $e");
//     }
//   }

//   void _pickDate() async {
//     final now = DateTime.now();
//     final picked = await showDatePicker(
//       context: context,
//       initialDate: selectedDate ?? now,
//       firstDate: DateTime(now.year - 1),
//       lastDate: now,
//     );
//     if (picked != null) {
//       setState(() {
//         selectedDate = picked;
//         showAll = false;
//       });
//       fetchUsers();
//     }
//   }

//   @override
//   void dispose() {
//     ApiService.disposeWebSockets();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final title = selectedDate != null
//         ? DateFormat('yyyy-MM-dd').format(selectedDate!)
//         : showAll
//             ? 'All Exits'
//             : 'Today\'s Exits';

//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Exit Dashboard - $title'),
//         actions: [
//           IconButton(
//             icon: Icon(Icons.calendar_month),
//             tooltip: "Pick Date",
//             onPressed: _pickDate,
//           ),
//           IconButton(
//             icon: Icon(showAll ? Icons.visibility_off : Icons.visibility),
//             tooltip: showAll ? "Show Today's Only" : "Show All",
//             onPressed: () {
//               setState(() {
//                 showAll = !showAll;
//                 selectedDate = null;
//               });
//               fetchUsers();
//             },
//           ),
//         ],
//       ),
//       body: RefreshIndicator(
//         onRefresh: fetchUsers,
//         child: users.isEmpty
//             ? Center(child: Text("No users found.", style: TextStyle(color: Colors.grey)))
//             : ListView.builder(
//                 itemCount: users.length,
//                 itemBuilder: (context, index) {
//                   final user = users[index];
//                   return Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
//                     child: Card(
//                       elevation: 2,
//                       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//                       child: ListTile(
//                         leading: Icon(Icons.person_outline, color: Colors.indigo),
//                         title: Text(user['name'], style: TextStyle(fontWeight: FontWeight.w600)),
//                         subtitle: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             SizedBox(height: 4),
//                             Text("RFID: ${user['rfid_uid']}", style: TextStyle(fontSize: 12)),
//                             Text("Plate: ${user['plate_number']}", style: TextStyle(fontSize: 12)),
//                             Text("Time Out: ${user['time_out'] ?? '—'}", style: TextStyle(fontSize: 12, color: Colors.grey[600])),
//                           ],
//                         ),
//                       ),
//                     ),
//                   );
//                 },
//               ),
//       ),
//       floatingActionButton: FloatingActionButton.extended(
//         icon: Icon(Icons.exit_to_app),
//         label: Text('Scan to Exit'),
//         onPressed: () async {
//           final result = await Navigator.push(
//             context,
//             MaterialPageRoute(builder: (_) => ExitPage()),
//           );
//           if (result == true) fetchUsers();
//         },
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../services/api_service.dart';
import 'exit_page.dart';

class ExitDashboardPage extends StatefulWidget {
  const ExitDashboardPage({Key? key}) : super(key: key);

  @override
  State<ExitDashboardPage> createState() => _ExitDashboardPageState();
}

class _ExitDashboardPageState extends State<ExitDashboardPage> {
  List users = [];
  List filteredUsers = [];
  DateTime? selectedDate;
  bool showAll = false;
  String searchQuery = "";

  @override
  void initState() {
    super.initState();
    fetchUsers();
    ApiService.listenToExitWebSocket((rfid) {
      fetchUsers();
    });
  }

  void filterUsers() {
    setState(() {
      filteredUsers = users.where((user) {
        final name = user['name'].toString().toLowerCase();
        final plate = user['plate_number'].toString().toLowerCase();
        final rfid = user['rfid_uid'].toString().toLowerCase();
        return name.contains(searchQuery) ||
            plate.contains(searchQuery) ||
            rfid.contains(searchQuery);
      }).toList();
    });
  }

  Future<void> fetchUsers() async {
    try {
      final data = await ApiService.fetchInactiveUsers();
      final targetDate = selectedDate ?? DateTime.now();

      final filtered = data.where((user) {
        if (showAll) return true;

        final rawTimeOut = user['time_out'];
        if (rawTimeOut == null) return false;

        final parsed = DateTime.tryParse(rawTimeOut);
        if (parsed == null) return false;

        return parsed.year == targetDate.year &&
            parsed.month == targetDate.month &&
            parsed.day == targetDate.day;
      }).toList()
        ..sort((a, b) {
          final aTime = DateTime.tryParse(a['time_out'] ?? '') ?? DateTime(2000);
          final bTime = DateTime.tryParse(b['time_out'] ?? '') ?? DateTime(2000);
          return bTime.compareTo(aTime);
        });

      setState(() {
        users = filtered;
        filterUsers();
      });
    } catch (e) {
      print("❌ Error fetching inactive users: $e");
    }
  }

  void _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? now,
      firstDate: DateTime(now.year - 1),
      lastDate: now,
    );
    if (picked != null) {
      setState(() {
        selectedDate = picked;
        showAll = false;
      });
      fetchUsers();
    }
  }

  @override
  void dispose() {
    ApiService.disposeWebSockets();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final title = selectedDate != null
        ? DateFormat('yyyy-MM-dd').format(selectedDate!)
        : showAll
            ? 'All Exits'
            : 'Today\'s Exits';

    return Scaffold(
      appBar: AppBar(
        title: Text('Exit Dashboard - $title'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.redAccent,
        elevation: 1,
        actions: [
          IconButton(
            icon: Icon(Icons.calendar_month),
            tooltip: "Pick Date",
            onPressed: _pickDate,
            color: Colors.redAccent,
          ),
          IconButton(
            icon: Icon(showAll ? Icons.visibility_off : Icons.visibility),
            tooltip: showAll ? "Show Today's Only" : "Show All",
            onPressed: () {
              setState(() {
                showAll = !showAll;
                selectedDate = null;
              });
              fetchUsers();
            },
            color: Colors.redAccent,
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Total Exits: ${filteredUsers.length}",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.red[800])),
                    Text("Unique UIDs: ${filteredUsers.map((u) => u['rfid_uid']).toSet().length}",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.red[800])),
                  ],
                ),
                const SizedBox(height: 12),
                TextField(
                  decoration: InputDecoration(
                    hintText: "Search by name, plate, or UID...",
                    prefixIcon: Icon(Icons.search, color: Colors.redAccent),
                    filled: true,
                    fillColor: Colors.grey[100],
                    contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.red.shade200),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.red.shade200),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.redAccent, width: 2),
                    ),
                  ),
                  onChanged: (value) {
                    searchQuery = value.toLowerCase();
                    filterUsers();
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: fetchUsers,
              child: filteredUsers.isEmpty
                  ? Center(
                      child: Text("No users found.",
                          style: TextStyle(color: Colors.grey[600])))
                  : ListView.builder(
                      itemCount: filteredUsers.length,
                      itemBuilder: (context, index) {
                        final user = filteredUsers[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                          child: Card(
                            elevation: 2,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            child: ListTile(
                              leading: Icon(Icons.person_outline, color: Colors.redAccent),
                              title: Text(user['name'],
                                  style: TextStyle(fontWeight: FontWeight.w600)),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 4),
                                  Text("RFID: ${user['rfid_uid']}",
                                      style: TextStyle(fontSize: 12, color: Colors.grey[700])),
                                  Text("Plate: ${user['plate_number']}",
                                      style: TextStyle(fontSize: 12, color: Colors.grey[700])),
                                  Text("Vehicle: ${user['vehicle_type'] ?? '—'}",
                                      style: TextStyle(fontSize: 12, color: Colors.grey[700])), // ✅ NEW LINE
                                  Text("Time Out: ${user['time_out'] ?? '—'}",
                                      style: TextStyle(fontSize: 12, color: Colors.grey[600])),
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
        icon: Icon(Icons.exit_to_app),
        label: Text('Scan to Exit'),
        backgroundColor: Colors.redAccent,
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => ExitPage()),
          );
          if (result == true) fetchUsers();
        },
      ),
    );
  }
}
