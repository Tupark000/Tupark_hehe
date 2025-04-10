// import 'package:flutter/material.dart';
// import 'dashboard_page.dart'; // Import Dashboard
// import 'exit_dashboard_page.dart'; // Import Exit Dashboard
// import 'reservation_page.dart'; // Import Reservation Page

// class InitialPage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("Select Action")),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             ElevatedButton(
//               onPressed: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (context) => DashboardPage()),
//                 );
//               },
//               child: Text("Entrance"),
//             ),
//             ElevatedButton(
//               onPressed: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (context) => ExitDashboardPage()),
//                 );
//               },
//               child: Text("Exit"),
//             // ),
//             // ElevatedButton(
//             //   onPressed: () {
//             //     Navigator.push(
//             //       context,
//             //       MaterialPageRoute(builder: (context) => ReservationPage()),
//             //     );
//             //   },
//             //   child: Text("Reserve"),
//             // ),
//         ),],
//         ),
//       ),
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'dashboard_page.dart';
// import 'exit_dashboard_page.dart';
// import 'reservation_page.dart';

// class InitialPage extends StatelessWidget {
//   const InitialPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("RFID Ultimate Control Panel"),
//         centerTitle: true,
//         backgroundColor: Colors.blueAccent,
//       ),
//       body: Container(
//         width: double.infinity,
//         padding: const EdgeInsets.symmetric(horizontal: 24),
//         decoration: const BoxDecoration(
//           gradient: LinearGradient(
//             colors: [Color(0xFFE3F2FD), Color(0xFFBBDEFB)],
//             begin: Alignment.topCenter,
//             end: Alignment.bottomCenter,
//           ),
//         ),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             _buildNavigationCard(
//               context,
//               icon: Icons.login,
//               label: 'Entrance',
//               color: Colors.green,
//               onTap: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (_) => DashboardPage()),
//                 );
//               },
//             ),
//             const SizedBox(height: 20),
//             _buildNavigationCard(
//               context,
//               icon: Icons.exit_to_app,
//               label: 'Exit',
//               color: Colors.redAccent,
//               onTap: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (_) => ExitDashboardPage()),
//                 );
//               },
//             ),
//             const SizedBox(height: 20),
//             _buildNavigationCard(
//               context,
//               icon: Icons.event_note,
//               label: 'Reservation',
//               color: Colors.deepPurple,
//               onTap: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (_) => ReservationPage()),
//                 );
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildNavigationCard(BuildContext context,
//       {required IconData icon,
//       required String label,
//       required VoidCallback onTap,
//       Color color = Colors.blue}) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Card(
//         elevation: 6,
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//         child: Container(
//           width: double.infinity,
//           padding: const EdgeInsets.symmetric(vertical: 24),
//           decoration: BoxDecoration(
//             color: color.withOpacity(0.85),
//             borderRadius: BorderRadius.circular(12),
//           ),
//           child: Column(
//             children: [
//               Icon(icon, size: 48, color: Colors.white),
//               const SizedBox(height: 10),
//               Text(
//                 label,
//                 style: const TextStyle(
//                   fontSize: 20,
//                   color: Colors.white,
//                   fontWeight: FontWeight.w600,
//                   letterSpacing: 1.1,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'dashboard_page.dart';
import 'exit_dashboard_page.dart';
import 'reservation_dashboard_page.dart';

class InitialPage extends StatelessWidget {
  const InitialPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Select Action"),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 1,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildMinimalButton(
              context,
              label: 'Entrance',
              icon: Icons.login_rounded,
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => DashboardPage()),
              ),
            ),
            const SizedBox(height: 16),
            _buildMinimalButton(
              context,
              label: 'Exit',
              icon: Icons.logout_rounded,
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => ExitDashboardPage()),
              ),
            ),
            const SizedBox(height: 16),
            _buildMinimalButton(
              context,
              label: 'Reservation',
              icon: Icons.event_note,
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => ReservationDashboardPage()),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMinimalButton(
    BuildContext context, {
    required String label,
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(
        icon,
        size: 20,
        color: Colors.grey[700],
      ),
      label: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12.0),
        child: Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            color: Colors.black87,
          ),
        ),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.grey[200],
        foregroundColor: Colors.black87,
        elevation: 0,
        alignment: Alignment.centerLeft,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}
