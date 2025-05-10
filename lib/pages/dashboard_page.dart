
// import 'package:flutter/material.dart';
// import 'package:rfid_ultimate/pages/add_user_page.dart';
// import '../services/api_service.dart';

// class DashboardPage extends StatefulWidget {
//   const DashboardPage({Key? key}) : super(key: key);

//   @override
//   State<DashboardPage> createState() => _DashboardPageState();
// }

// class _DashboardPageState extends State<DashboardPage> {
//   List users = [];

//   @override
//   void initState() {
//     super.initState();
//     fetchUsers();

//     ApiService.listenToEntranceWebSocket((rfid) {
//       fetchUsers();
//     });

//     ApiService.listenToExitWebSocket((rfid) {
//       fetchUsers();
//     });
//   }

//   Future<void> fetchUsers() async {
//     final data = await ApiService.fetchUsers();
//     setState(() => users = data.where((u) => u['status'] == 'ACTIVE').toList());
//   }

//   @override
//   void dispose() {
//     ApiService.disposeWebSockets();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Active Users')),
//       body: RefreshIndicator(
//         onRefresh: fetchUsers,
//         child: users.isEmpty
//             ? Center(child: Text('No active users', style: TextStyle(fontSize: 16)))
//             : ListView.builder(
//                 padding: EdgeInsets.all(12),
//                 itemCount: users.length,
//                 itemBuilder: (context, index) {
//                   final user = users[index];
//                   return Card(
//                     elevation: 1,
//                     margin: EdgeInsets.symmetric(vertical: 6),
//                     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//                     child: ListTile(
//                       leading: Icon(Icons.person_outline, color: Colors.grey[700]),
//                       title: Text(user['name'], style: TextStyle(fontWeight: FontWeight.w600)),
//                       subtitle: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text('RFID: ${user['rfid_uid']}', style: TextStyle(fontSize: 12, color: Colors.grey[600])),
//                           Text('Plate: ${user['plate_number']}', style: TextStyle(fontSize: 12, color: Colors.grey[600])),
//                           Text('Time In: ${user['time_in'] ?? ''}', style: TextStyle(fontSize: 12, color: Colors.grey[500])),
//                         ],
//                       ),
//                     ),
//                   );
//                 },
//               ),
//       ),
//       floatingActionButton: FloatingActionButton.extended(
//         icon: Icon(Icons.add),
//         label: Text('Add User'),
//         onPressed: () async {
//           await Navigator.push(
//             context,
//             MaterialPageRoute(builder: (_) => AddUserPage()),
//           );
//           fetchUsers();
//         },
//       ),
//     );
//   }
// }


//import 'package:intl/intl.dart';



// import 'package:flutter/material.dart';
// import 'package:rfid_ultimate/pages/add_user_page.dart';
// import '../services/api_service.dart';

// class DashboardPage extends StatefulWidget {
//   const DashboardPage({Key? key}) : super(key: key);

//   @override
//   State<DashboardPage> createState() => _DashboardPageState();
// }

// class _DashboardPageState extends State<DashboardPage> {
//   List users = [];

//   @override
//   void initState() {
//     super.initState();
//     fetchUsers();

//     ApiService.listenToEntranceWebSocket((rfid) {
//       fetchUsers();
//     });

//     ApiService.listenToExitWebSocket((rfid) {
//       fetchUsers();
//     });
//   }

//   Future<void> fetchUsers() async {
//     final data = await ApiService.fetchUsers();
//     setState(() {
//       users = data.where((u) => u['status'] == 'ACTIVE').toList();
//     });
//   }

//   @override
//   void dispose() {
//     ApiService.disposeWebSockets();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final entranceCountToday = users.where((user) {
//       final raw = user['time_in'];
//       if (raw == null) return false;
//       final parsed = DateTime.tryParse(raw);
//       if (parsed == null) return false;
//       final now = DateTime.now();
//       return parsed.year == now.year &&
//           parsed.month == now.month &&
//           parsed.day == now.day;
//     }).length;

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Active Users'),
//         backgroundColor: Colors.white,
//         foregroundColor: Colors.red[800],
//         elevation: 1,
//       ),
//       body: RefreshIndicator(
//         onRefresh: fetchUsers,
//         child: Column(
//           children: [
//             Container(
//               width: double.infinity,
//               color: Colors.red[50],
//               padding: const EdgeInsets.all(16),
//               child: Text(
//                 "Entrances Today: $entranceCountToday",
//                 style: const TextStyle(
//                   fontSize: 16,
//                   fontWeight: FontWeight.w600,
//                   color: Colors.red,
//                 ),
//               ),
//             ),
//             Expanded(
//               child: users.isEmpty
//                   ? const Center(
//                       child: Text(
//                         'No active users',
//                         style: TextStyle(fontSize: 16, color: Colors.grey),
//                       ),
//                     )
//                   : ListView.builder(
//                       padding: const EdgeInsets.all(12),
//                       itemCount: users.length,
//                       itemBuilder: (context, index) {
//                         final user = users[index];
//                         return Card(
//                           elevation: 1,
//                           margin: const EdgeInsets.symmetric(vertical: 6),
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(10),
//                           ),
//                           child: ListTile(
//                             leading: const Icon(Icons.person_outline, color: Colors.red),
//                             title: Text(
//                               user['name'],
//                               style: const TextStyle(fontWeight: FontWeight.w600),
//                             ),
//                                   subtitle: Column(
//                                     crossAxisAlignment: CrossAxisAlignment.start,
//                                     children: [
//                                       Text(
//                                         'RFID: ${user['rfid_uid']}',
//                                         style: const TextStyle(fontSize: 12, color: Colors.grey),
//                                       ),
//                                       Text(
//                                         'Plate: ${user['plate_number']}',
//                                         style: const TextStyle(fontSize: 12, color: Colors.grey),
//                                       ),
//                                       Text(
//                                         'Vehicle: ${user['vehicle_type'] ?? "—"}', // ✅ Vehicle type added
//                                         style: const TextStyle(fontSize: 12, color: Colors.grey),
//                                       ),
//                                       Text(
//                                         'Time In: ${user['time_in'] ?? ''}',
//                                         style: const TextStyle(fontSize: 12, color: Colors.grey),
//                                       ),
//                                     ],
//                                   ),
//                           ),
//                         );
//                       },
//                     ),
//             ),
//           ],
//         ),
//       ),
//       floatingActionButton: FloatingActionButton.extended(
//         onPressed: () async {
//           await Navigator.push(
//             context,
//             MaterialPageRoute(builder: (_) => AddUserPage()),
//           );
//           fetchUsers();
//         },
//         icon: const Icon(Icons.add),
//         label: const Text("Add User"),
//         backgroundColor: Colors.redAccent,
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:rfid_ultimate/pages/add_user_page.dart';
import '../services/api_service.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  List users = [];

  @override
  void initState() {
    super.initState();
    fetchUsers();

    // Listen to entrance WebSocket
    ApiService.listenToEntranceWebSocket((rfid) {
      fetchUsers();
    });

    // Listen to exit WebSocket
    ApiService.listenToExitWebSocket((rfid) {
      fetchUsers();
    });

    // ✅ Listen to reservation activation WebSocket
    ApiService.listenToEntranceWebSocket((rfid) {
      print("📢 Activated or scanned RFID: $rfid");
      fetchUsers();
    });
  }

  Future<void> fetchUsers() async {
    final data = await ApiService.fetchUsers();
    setState(() {
      users = data.where((u) => u['status'] == 'ACTIVE').toList();
    });
  }

  @override
  void dispose() {
    ApiService.disposeWebSockets();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final entranceCountToday = users.where((user) {
      final raw = user['time_in'];
      if (raw == null) return false;
      final parsed = DateTime.tryParse(raw);
      if (parsed == null) return false;
      final now = DateTime.now();
      return parsed.year == now.year &&
          parsed.month == now.month &&
          parsed.day == now.day;
    }).length;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Active Users'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.red[800],
        elevation: 1,
      ),
      body: RefreshIndicator(
        onRefresh: fetchUsers,
        child: Column(
          children: [
            Container(
              width: double.infinity,
              color: Colors.red[50],
              padding: const EdgeInsets.all(16),
              child: Text(
                "Entrances Today: $entranceCountToday",
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.red,
                ),
              ),
            ),
            Expanded(
              child: users.isEmpty
                  ? const Center(
                      child: Text(
                        'No active users',
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(12),
                      itemCount: users.length,
                      itemBuilder: (context, index) {
                        final user = users[index];
                        return Card(
                          elevation: 1,
                          margin: const EdgeInsets.symmetric(vertical: 6),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: ListTile(
                            leading: const Icon(Icons.person_outline, color: Colors.red),
                            title: Text(
                              user['name'],
                              style: const TextStyle(fontWeight: FontWeight.w600),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'RFID: ${user['rfid_uid']}',
                                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                                ),
                                Text(
                                  'Plate: ${user['plate_number']}',
                                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                                ),
                                Text(
                                  'Vehicle: ${user['vehicle_type'] ?? "—"}',
                                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                                ),
                                Text(
                                  'Time In: ${user['time_in'] ?? ''}',
                                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => AddUserPage()),
          );
          fetchUsers();
        },
        icon: const Icon(Icons.add),
        label: const Text("Add User"),
        backgroundColor: Colors.redAccent,
      ),
    );
  }
}

