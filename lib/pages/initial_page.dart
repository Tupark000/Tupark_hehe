import 'package:flutter/material.dart';
import 'dashboard_page.dart'; // Import Dashboard
import 'exit_dashboard_page.dart'; // Import Exit Dashboard
import 'reservation_page.dart'; // Import Reservation Page

class InitialPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Select Action")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => DashboardPage()),
                );
              },
              child: Text("Entrance"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ExitDashboardPage()),
                );
              },
              child: Text("Exit"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ReservationPage()),
                );
              },
              child: Text("Reserve"),
            ),
          ],
        ),
      ),
    );
  }
}
