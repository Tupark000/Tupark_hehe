
// import 'package:flutter/material.dart';
// import 'dashboard_page.dart';
// import 'exit_dashboard_page.dart';
// import 'reservation_dashboard_page.dart';
// import 'printer_setting_page.dart';
// import 'login_page.dart'; // Make sure this exists

// class InitialPage extends StatelessWidget {
//   const InitialPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Select Action"),
//         centerTitle: true,
//         backgroundColor: Colors.white,
//         foregroundColor: Colors.black87,
//         elevation: 1,
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.logout),
//             onPressed: () async {
//               final shouldLogout = await showDialog<bool>(
//                 context: context,
//                 builder: (context) => AlertDialog(
//                   title: const Text("Confirm Logout"),
//                   content: const Text("Are you sure you want to log out?"),
//                   actions: [
//                     TextButton(
//                       onPressed: () => Navigator.pop(context, false),
//                       child: const Text("Cancel"),
//                     ),
//                     ElevatedButton(
//                       onPressed: () => Navigator.pop(context, true),
//                       child: const Text("Logout"),
//                     ),
//                   ],
//                 ),
//               );

//               if (shouldLogout == true) {
//                 Navigator.pushAndRemoveUntil(
//                   context,
//                   MaterialPageRoute(builder: (_) => LoginPage()),
//                   (route) => false,
//                 );
//               }
//             },
//           )
//         ],
//       ),
//       body: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: [
//             _buildMinimalButton(
//               context,
//               label: 'Entrance',
//               icon: Icons.login_rounded,
//               onPressed: () => Navigator.push(
//                 context,
//                 MaterialPageRoute(builder: (_) => DashboardPage()),
//               ),
//             ),
//             const SizedBox(height: 16),
//             _buildMinimalButton(
//               context,
//               label: 'Exit',
//               icon: Icons.logout_rounded,
//               onPressed: () => Navigator.push(
//                 context,
//                 MaterialPageRoute(builder: (_) => ExitDashboardPage()),
//               ),
//             ),
//             const SizedBox(height: 16),
//             _buildMinimalButton(
//               context,
//               label: 'Reservation',
//               icon: Icons.event_note,
//               onPressed: () => Navigator.push(
//                 context,
//                 MaterialPageRoute(builder: (_) => ReservationDashboardPage()),
//               ),
//             ),
//             const SizedBox(height: 16),
//             _buildMinimalButton(
//               context,
//               label: 'Printer Settings',
//               icon: Icons.print_rounded,
//               onPressed: () => Navigator.push(
//                 context,
//                 MaterialPageRoute(builder: (_) => PrinterSettingPage()),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildMinimalButton(
//     BuildContext context, {
//     required String label,
//     required IconData icon,
//     required VoidCallback onPressed,
//   }) {
//     return ElevatedButton.icon(
//       onPressed: onPressed,
//       icon: Icon(
//         icon,
//         size: 20,
//         color: Colors.grey[700],
//       ),
//       label: Padding(
//         padding: const EdgeInsets.symmetric(vertical: 12.0),
//         child: Text(
//           label,
//           style: const TextStyle(
//             fontSize: 16,
//             color: Colors.black87,
//           ),
//         ),
//       ),
//       style: ElevatedButton.styleFrom(
//         backgroundColor: Colors.grey[200],
//         foregroundColor: Colors.black87,
//         elevation: 0,
//         alignment: Alignment.centerLeft,
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(10),
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'dashboard_page.dart';
import 'exit_dashboard_page.dart';
import 'reservation_dashboard_page.dart';
import 'printer_setting_page.dart';
import 'login_page.dart';

class InitialPage extends StatelessWidget {
  const InitialPage({super.key});

  @override
  Widget build(BuildContext context) {
    final redColor = const Color(0xFFD32F2F);

    return Scaffold(
      appBar: AppBar(
        title: const Text("TUPark Initial Page:>"),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: redColor,  
        elevation: 1,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              final shouldLogout = await showDialog<bool>(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text("Confirm Logout"),
                  content: const Text("Are you sure you want to log out?"),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: const Text("Cancel"),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: redColor,
                      ),
                      onPressed: () => Navigator.pop(context, true),
                      child: const Text("Logout"),
                    ),
                  ],
                ),
              );

              if (shouldLogout == true) {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => LoginPage()),
                  (route) => false,
                );
              }
            },
          )
        ],
      ),
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildActionButton(
                context,
                label: 'Entrance',
                icon: Icons.login_rounded,
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => DashboardPage()),
                ),
                redColor: redColor,
              ),
              const SizedBox(height: 20),
              _buildActionButton(
                context,
                label: 'Exit',
                icon: Icons.logout_rounded,
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => ExitDashboardPage()),
                ),
                redColor: redColor,
              ),
              const SizedBox(height: 20),
              _buildActionButton(
                context,
                label: 'Reservation',
                icon: Icons.event_note,
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => ReservationDashboardPage()),
                ),
                redColor: redColor,
              ),
              const SizedBox(height: 20),
              _buildActionButton(
                context,
                label: 'Printer Settings',
                icon: Icons.print_rounded,
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => PrinterSettingPage()),
                ),
                redColor: redColor,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton(
    BuildContext context, {
    required String label,
    required IconData icon,
    required VoidCallback onPressed,
    required Color redColor,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 65,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, size: 24, color: redColor),
        label: Text(
          label,
          style: const TextStyle(
            fontSize: 18,
            color: Colors.black87,
            fontWeight: FontWeight.w500,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.red[50],
          foregroundColor: redColor,
          elevation: 0,
          alignment: Alignment.centerLeft,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16),
        ),
      ),
    );
  }
}
