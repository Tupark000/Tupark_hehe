import 'package:flutter/material.dart';
import 'package:rfid_ultimate/pages/add_user_page.dart';
import '../services/api_service.dart';

class DashboardPage extends StatefulWidget {
  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final ApiService apiService = ApiService();
  late Future<List<dynamic>> users;

  @override
  void initState() {
    super.initState();
    users = apiService.fetchUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Active Users")),
      body: FutureBuilder<List<dynamic>>(
        future: users,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text("No active users"));
          }

          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final user = snapshot.data![index];
              return ListTile(
                title: Text(user["name"]),
                subtitle: Text("Plate No: ${user["plate_no"]} - RFID: ${user["rfid"]}"),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => AddUserPage()),
                );

        },
        child: Icon(Icons.add),
      ),
    );
  }
}
