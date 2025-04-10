
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
