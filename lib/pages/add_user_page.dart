import 'package:flutter/material.dart';
import '../services/api_service.dart';

class AddUserPage extends StatefulWidget {
  @override
  _AddUserPageState createState() => _AddUserPageState();
}

class _AddUserPageState extends State<AddUserPage> {
  final ApiService apiService = ApiService();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController plateController = TextEditingController();
  final TextEditingController rfidController = TextEditingController();

  void _submitUser() async {
    bool success = await apiService.addUser(
      nameController.text,
      plateController.text,
      rfidController.text,
    );

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("User added successfully")),
      );
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to add user")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Add User")),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(labelText: "Name"),
            ),
            TextField(
              controller: plateController,
              decoration: InputDecoration(labelText: "Plate No"),
            ),
            TextField(
              controller: rfidController,
              decoration: InputDecoration(labelText: "RFID"),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _submitUser,
              child: Text("Add User"),
            ),
          ],
        ),
      ),
    );
  }
}
