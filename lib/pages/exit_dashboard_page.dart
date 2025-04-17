
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
//   try {
//     final data = await ApiService.fetchInactiveUsers();
//     final targetDate = selectedDate ?? DateTime.now();

//     setState(() {
//       users = data.where((user) {
//         if (showAll) return true;

//         final rawTimeOut = user['time_out'];
//         if (rawTimeOut == null) return false;

//         final parsedTimeOut = DateTime.tryParse(rawTimeOut);
//         if (parsedTimeOut == null) return false;

//         return parsedTimeOut.year == targetDate.year &&
//                parsedTimeOut.month == targetDate.month &&
//                parsedTimeOut.day == targetDate.day;
//       }).toList()
//         ..sort((a, b) {
//           final aTime = DateTime.tryParse(a['time_out'] ?? '') ?? DateTime(2000);
//           final bTime = DateTime.tryParse(b['time_out'] ?? '') ?? DateTime(2000);
//           return bTime.compareTo(aTime);
//         });
//     });
//   } catch (e) {
//     print("❌ Error fetching INACTIVE users: $e");
//   }
// }

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
//             icon: Icon(Icons.calendar_today),
//             tooltip: 'Pick Date',
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
//             ? Center(child: Text("No users found."))
//             : ListView.builder(
//                 itemCount: users.length,
//                 itemBuilder: (context, index) {
//                   final user = users[index];
//                   return Card(
//                     margin: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//                     elevation: 1,
//                     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//                     child: ListTile(
//                       leading: Icon(Icons.history, color: Colors.grey[700]),
//                       title: Text(user['name'], style: TextStyle(fontWeight: FontWeight.bold)),
//                       subtitle: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text('RFID: ${user['rfid_uid']}', style: TextStyle(fontSize: 12, color: Colors.grey[600])),
//                           Text('Plate: ${user['plate_number']}', style: TextStyle(fontSize: 12, color: Colors.grey[600])),
//                           Text('Time Out: ${user['time_out'] ?? '—'}', style: TextStyle(fontSize: 12, color: Colors.grey[500])),
//                         ],
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
  DateTime? selectedDate;
  bool showAll = false;

  @override
  void initState() {
    super.initState();
    fetchUsers();
    ApiService.listenToExitWebSocket((rfid) {
      fetchUsers();
    });
  }

  Future<void> fetchUsers() async {
    try {
      final data = await ApiService.fetchInactiveUsers();
      final targetDate = selectedDate ?? DateTime.now();

      setState(() {
        users = data.where((user) {
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
            return bTime.compareTo(aTime); // Latest first
          });
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
        actions: [
          IconButton(
            icon: Icon(Icons.calendar_month),
            tooltip: "Pick Date",
            onPressed: _pickDate,
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
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: fetchUsers,
        child: users.isEmpty
            ? Center(child: Text("No users found.", style: TextStyle(color: Colors.grey)))
            : ListView.builder(
                itemCount: users.length,
                itemBuilder: (context, index) {
                  final user = users[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    child: Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      child: ListTile(
                        leading: Icon(Icons.person_outline, color: Colors.indigo),
                        title: Text(user['name'], style: TextStyle(fontWeight: FontWeight.w600)),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 4),
                            Text("RFID: ${user['rfid_uid']}", style: TextStyle(fontSize: 12)),
                            Text("Plate: ${user['plate_number']}", style: TextStyle(fontSize: 12)),
                            Text("Time Out: ${user['time_out'] ?? '—'}", style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        icon: Icon(Icons.exit_to_app),
        label: Text('Scan to Exit'),
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
