// import 'package:flutter/material.dart';
// import 'package:rfid_ultimate/pages/add_user_page.dart';
// import '../services/api_service.dart';

// class DashboardPage extends StatefulWidget {
//   @override
//   _DashboardPageState createState() => _DashboardPageState();
// }

// class _DashboardPageState extends State<DashboardPage> {
//   final ApiService apiService = ApiService();
//   late Future<List<dynamic>> users;

//   @override
//   void initState() {
//     super.initState();
//     users = apiService.fetchUsers();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("Active Users")),
//       body: FutureBuilder<List<dynamic>>(
//         future: users,
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Center(child: CircularProgressIndicator());
//           } else if (snapshot.hasError) {
//             return Center(child: Text("Error: ${snapshot.error}"));
//           } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
//             return Center(child: Text("No active users"));
//           }

//           return ListView.builder(
//             itemCount: snapshot.data!.length,
//             itemBuilder: (context, index) {
//               final user = snapshot.data![index];
//               return ListTile(
//                 title: Text(user["name"]),
//                 subtitle: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text("Plate No: ${user["plate_number"]}"),
//                     Text("RFID: ${user["rfid_uid"]}"),
//                     Text("Time In: ${user["time_in"] ?? "Not set"}"),
//                   ],
//                 ),
//               );
//             },
//           );
//         },
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           Navigator.pushReplacement(
//             context,
//             MaterialPageRoute(builder: (context) => AddUserPage()),
//           );
//         },
//         child: Icon(Icons.add),
//       ),
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:rfid_ultimate/pages/add_user_page.dart';
// import 'package:rfid_ultimate/services/api_service.dart';


// class DashboardPage extends StatefulWidget {
  
//   const DashboardPage({super.key});

//   @override
//   State<DashboardPage> createState() => _DashboardPageState();
// }

// class _DashboardPageState extends State<DashboardPage> {
//   final ApiService apiService = ApiService();
//   late Future<List<dynamic>> users;
//   List<dynamic> activeUsers = [];

//   @override
//   void initState() {
//     super.initState();
//     users = apiService.fetchUsers();
//     loadActiveUsers();
//     ApiService.listenToWebSocket((data) {
//     onRFIDScanned(data as String);
//     });
//   }

//   void loadActiveUsers() async {
//     final users = await ApiService.getActiveUsers();
//     setState(() {
//       activeUsers = users;
//     });
//   }

//   void onRFIDScanned(String uid) {
//     loadActiveUsers(); // Reload users on new scan
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("Entrance Dashboard")),
//       body: Column(
//         children: [
//           const SizedBox(height: 16),
//           const Text("Active Users", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
//           const SizedBox(height: 8),
//           Expanded(
//             child: ListView.builder(
//               itemCount: activeUsers.length,
//               itemBuilder: (context, index) {
//                 final user = activeUsers[index];
//                 return ListTile(
//                   leading: const Icon(Icons.person),
//                   title: Text(user['name']),
//                   subtitle: Text("Plate: ${user['plate_number']} | Time In: ${user['time_in']}"),
//                   trailing: Text(user['rfid_uid']),
//                 );
//               },
//             ),
//           ),
//           const SizedBox(height: 10),
//           ElevatedButton(
//             onPressed: () {
//                 Navigator.pushReplacement(
//              context,
//              MaterialPageRoute(builder: (context) => AddUserPage()),
//             );           
//             },
//             child: const Text("Add User"),
//           ),
//           const SizedBox(height: 10),
//         ],
//       ),
//     );
//   }
// }



// import 'package:flutter/material.dart';
// import 'package:rfid_ultimate/pages/add_user_page.dart';
// import '../services/api_service.dart';

// class DashboardPage extends StatefulWidget {
//   const DashboardPage({Key? key}) : super(key: key);

//   @override
//   State<DashboardPage> createState() => _DashboardPageState();
// }

// class _DashboardPageState extends State<DashboardPage> {
//   final ApiService apiService = ApiService();
//   late Future<List<dynamic>> users;

//   @override
//   void initState() {
//     super.initState();
//     users = ApiService.fetchUsers();
//   }

//   Future<void> _refreshUsers() async {
//     setState(() {
//       users = ApiService.fetchUsers();
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("Users Dashboard")),
//       body: FutureBuilder<List<dynamic>>(
//         future: users,
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(child: CircularProgressIndicator());
//           } else if (snapshot.hasError) {
//             return Center(child: Text("Error: ${snapshot.error}"));
//           } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
//             return const Center(child: Text("No users found"));
//           }

//           return RefreshIndicator(
//             onRefresh: _refreshUsers,
//             child: ListView.builder(
//               itemCount: snapshot.data!.length,
//               itemBuilder: (context, index) {
//                 final user = snapshot.data![index];
//                 return Card(
//                   margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//                   child: ListTile(
//                     leading: const Icon(Icons.person),
//                     title: Text(user["name"] ?? "No name"),
//                     subtitle: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text("Plate No: ${user["plate_number"] ?? "N/A"}"),
//                         Text("RFID: ${user["rfid_uid"] ?? "N/A"}"),
//                         Text("Time In: ${user["time_in"] ?? "N/A"}"),
//                         // Optionally, display status if needed:
//                         // Text("Status: ${user["status"] ?? "N/A"}"),
//                       ],
//                     ),
//                   ),
//                 );
//               },
//             ),
//           );
//         },
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           Navigator.pushReplacement(
//             context,
//             MaterialPageRoute(builder: (context) => const AddUserPage()),
//           );
//         },
//         child: const Icon(Icons.add),
//       ),
//     );
//   }
// }


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
//   }

//   Future<void> fetchUsers() async {
//     final data = await ApiService.fetchUsers();
//     setState(() => users = data);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Dashboard')),
//       body: RefreshIndicator(
//         onRefresh: fetchUsers,
//         child: users.isEmpty
//             ? Center(child: Text('No active users', style: TextStyle(fontSize: 18)))
//             : ListView(
//                 padding: EdgeInsets.all(12),
//                 children: [
//                   Text(
//                     'Active Users',
//                     style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//                   ),
//                   SizedBox(height: 10),
//                   ...users.map((user) => Card(
//                         elevation: 2,
//                         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
//                         child: ListTile(
//                           leading: Icon(Icons.person, color: Colors.blueAccent),
//                           title: Text(user['name'], style: TextStyle(fontWeight: FontWeight.bold)),
//                           subtitle: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Text('Plate: ${user['plate_number']}'),
//                               Text('Status: ${user['status']}'),
//                             ],
//                           ),
//                           trailing: Text(user['time_in'] ?? '', style: TextStyle(fontSize: 12)),
//                         ),
//                       )),
//                 ],
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
//           fetchUsers(); // Refresh after returning
//         },
//       ),
//     );
//   }
// }


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

//     // Start listening for real-time RFID entrance scans
//     ApiService.listenToEntranceWebSocket((rfid) {
//       print("🔄 New entrance scan detected: $rfid");
//       fetchUsers(); // Refresh UI when new user enters
//     });

//     ApiService.listenToExitWebSocket((rfid) {
//       print("🔄 Exit scan detected, removing from active users: $rfid");
//       fetchUsers(); // Refresh UI when user exits
//     });
//   }

//   Future<void> fetchUsers() async {
//     final data = await ApiService.fetchUsers();
//     setState(() => users = data.where((u) => u['status'] == 'ACTIVE').toList());
//   }

//   @override
//   void dispose() {
//     ApiService.disposeWebSockets(); // Close WebSockets when page is closed
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Dashboard')),
//       body: RefreshIndicator(
//         onRefresh: fetchUsers,
//         child: users.isEmpty
//             ? Center(child: Text('No active users', style: TextStyle(fontSize: 18)))
//             : ListView(
//                 padding: EdgeInsets.all(12),
//                 children: [
//                   Text(
//                     'Active Users',
//                     style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//                   ),
//                   SizedBox(height: 10),
//                   ...users.map((user) => Card(
//                         elevation: 2,
//                         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
//                         child: ListTile(
//                           leading: Icon(Icons.person, color: Colors.blueAccent),
//                           title: Text(user['name'], style: TextStyle(fontWeight: FontWeight.bold)),
//                           subtitle: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Text('Plate: ${user['plate_number']}'),
//                               Text('Status: ${user['status']}'),
//                             ],
//                           ),
//                           trailing: Text(user['time_in'] ?? '', style: TextStyle(fontSize: 12)),
//                         ),
//                       )),
//                 ],
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
//           fetchUsers(); // Refresh after returning
//         },
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

    ApiService.listenToEntranceWebSocket((rfid) {
      fetchUsers();
    });

    ApiService.listenToExitWebSocket((rfid) {
      fetchUsers();
    });
  }

  Future<void> fetchUsers() async {
    final data = await ApiService.fetchUsers();
    setState(() => users = data.where((u) => u['status'] == 'ACTIVE').toList());
  }

  @override
  void dispose() {
    ApiService.disposeWebSockets();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Active Users')),
      body: RefreshIndicator(
        onRefresh: fetchUsers,
        child: users.isEmpty
            ? Center(child: Text('No active users', style: TextStyle(fontSize: 16)))
            : ListView.builder(
                padding: EdgeInsets.all(12),
                itemCount: users.length,
                itemBuilder: (context, index) {
                  final user = users[index];
                  return Card(
                    elevation: 1,
                    margin: EdgeInsets.symmetric(vertical: 6),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    child: ListTile(
                      leading: Icon(Icons.person_outline, color: Colors.grey[700]),
                      title: Text(user['name'], style: TextStyle(fontWeight: FontWeight.w600)),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('RFID: ${user['rfid_uid']}', style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                          Text('Plate: ${user['plate_number']}', style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                          Text('Time In: ${user['time_in'] ?? ''}', style: TextStyle(fontSize: 12, color: Colors.grey[500])),
                        ],
                      ),
                    ),
                  );
                },
              ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        icon: Icon(Icons.add),
        label: Text('Add User'),
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => AddUserPage()),
          );
          fetchUsers();
        },
      ),
    );
  }
}
