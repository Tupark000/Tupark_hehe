import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  final String apiUrl = "http://10.0.2.2:5000"; // Change to Vercel URL after deployment 192.168.100.96

   // Login Function
    Future<bool> login(String email, String password) async {
    final response = await http.post(
      Uri.parse("$apiUrl/login"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"email": email, "password": password}),
    );

    if (response.statusCode == 200) {
      return true; // Login successful
    } else {
      return false; // Invalid credentials
    }
  }

  // Fetch users from the database
  Future<List<dynamic>> fetchUsers() async {
    final response = await http.get(Uri.parse("$apiUrl/users"));

    if (response.statusCode == 200) {
      return jsonDecode(response.body); // Returns list of users
    } else {
      throw Exception("Failed to load users");
    }
  }

  Future<bool> deactivateUser(String rfid) async {
  final response = await http.post(
    Uri.parse('$apiUrl/deactivate-rfid'),
    headers: {"Content-Type": "application/json"},
    body: jsonEncode({"rfid": rfid}),
  );

  return response.statusCode == 200;
  }

   Future<List<dynamic>> fetchReservations() async {
    final response = await http.get(Uri.parse('$apiUrl/reservations'));

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Error fetching reservations.");
    }
  }

  Future<void> addReservation(String name, String plateNo, String rfid, String expectedTime) async {
    final response = await http.post(
      Uri.parse('$apiUrl/add-reservation'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "name": name,
        "plate_no": plateNo,
        "rfid": rfid,
        "expected_time": expectedTime,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception("Error adding reservation.");
    }
  }

  

  Future<void> transferReservation() async {
  final response = await http.post(Uri.parse('$apiUrl/transfer-reservations'));
  if (response.statusCode != 200) {
    throw Exception("Error transferring reservations.");
  }
  }

  Future<bool> exitUser(String rfid) async {
  final response = await http.post(
    Uri.parse('$apiUrl/exit-user'),
    body: jsonEncode({"rfid": rfid}),
    headers: {"Content-Type": "application/json"},
  );

  return response.statusCode == 200;
 }
 









  addUser(String text, String text2, String text3) {}
}
