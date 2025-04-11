

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class ApiService {
  // Base URL for REST API and WebSockets
static final String apiUrl = "https://tuparkhehe-production.up.railway.app";
static const String wsUrl = "wss://tuparkhehe-production.up.railway.app/ws";

  // Fetch all users
  static Future<List<dynamic>> fetchUsers() async {
    final response = await http.get(Uri.parse("$apiUrl/api/users"));
    if (response.statusCode == 200) {
      return jsonDecode(response.body) as List<dynamic>;
    } else {
      throw Exception("Failed to load users");
    }
  }

  

  // Login function
  Future<bool> login(String email, String password) async {
    final response = await http.post(
      Uri.parse("$apiUrl/login"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"email": email, "password": password}),
    );
    return response.statusCode == 200;
  }

  // Add a new user
static Future<bool> addUser(String name, String plate, String rfid) async {
  if (rfid == "Waiting..." || rfid.isEmpty) {
    print("⚠️ No valid RFID scanned.");
    return false;
  }

  final response = await http.post(
    Uri.parse('$apiUrl/api/users'),
    headers: {'Content-Type': 'application/json'},
    body: json.encode({
      'name': name,
      'plate_number': plate,
      'rfid_uid': rfid,
    }),
  );

  if (response.statusCode == 201) {
    print("✅ User added successfully.");
    return true;
  } else if (response.statusCode == 409) {
    print("🚫 RFID UID is already in use by an ACTIVE user.");
    return false;
  } else {
    print("❌ Failed to add user: ${response.body}");
    return false;
  }
}

  // Exit a user manually via REST API
  static Future<bool> exitUser(String rfid) async {
    try {
      final response = await http.post(
        Uri.parse('$apiUrl/api/users/exit'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'rfid_uid': rfid}),
      );
      if (response.statusCode == 200) {
        print("✅ User exit processed.");
        return true;
      } else {
        print("❌ Failed to process exit: ${response.body}");
        return false;
      }
    } catch (e) {
      print('❌ Error exiting user: $e');
      return false;
    }
  }

  // ===== WebSocket for Entrance Scans =====
  static WebSocketChannel? _entranceChannel;
static void listenToEntranceWebSocket(Function(String) onRFIDReceived) {
  _entranceChannel = IOWebSocketChannel.connect(Uri.parse(wsUrl));
  print("🔗 Connecting to WebSocket (Entrance): $wsUrl");

  _entranceChannel!.stream.listen((data) {
    print("📩 WebSocket (Entrance) Message Received: $data");

    try {
      final decoded = jsonDecode(data);

      if (decoded['scanned_uid'] != null && decoded['type'] == 'ENTRANCE') {
        final uid = decoded['scanned_uid'];
        onRFIDReceived(uid);
      } else if (decoded['update'] == 'reservation_activated') {
        print("🚀 Reservation moved to ACTIVE: ${decoded['rfid_uid']}");
        onRFIDReceived(decoded['rfid_uid']);
      }
    } catch (e) {
      print("❌ JSON Parse Error (Entrance): $e");
    }
  }, onError: (error) {
    print("❌ WebSocket (Entrance) Error: $error");
  }, onDone: () {
    print("🔌 Entrance WebSocket Closed");
  });
}


  // ===== WebSocket for Exit Scans =====
  static WebSocketChannel? _exitChannel;
  static void listenToExitWebSocket(Function(String) onRFIDReceived) {
  _exitChannel = IOWebSocketChannel.connect(Uri.parse(wsUrl));
  print("🔗 Connecting to WebSocket (Exit): $wsUrl");

  _exitChannel!.stream.listen((data) {
    print("📩 WebSocket Message (Exit) Received: $data");

    try {
      final decoded = jsonDecode(data);
      if (decoded['scanned_uid'] != null) {
        final String uid = decoded['scanned_uid'];
        print("🎯 Exit RFID: $uid");
        onRFIDReceived(uid);
      }
    } catch (e) {
      print("❌ JSON Parse Error (Exit): $e");
    }
  }, onError: (error) {
    print("❌ WebSocket Error (Exit): $error");
  }, onDone: () {
    print("🔌 Exit WebSocket Closed");
  });

}

  // Dispose both WebSocket channels
  static void disposeWebSockets() {
    if (_entranceChannel != null) {
      _entranceChannel!.sink.close();
      print("🔴 Entrance WebSocket Closed");
    }
    if (_exitChannel != null) {
      _exitChannel!.sink.close();
      print("🔴 Exit WebSocket Closed");
    }
  }

static Future<List<dynamic>> fetchInactiveUsers() async {
  final response = await http.get(Uri.parse("$apiUrl/api/users/inactive"));
  if (response.statusCode == 200) {
    return jsonDecode(response.body) as List<dynamic>;
  } else {
    throw Exception("Failed to load inactive users");
  }
}


static Future<bool> addReservation({
  required String name,
  required String plate,
  required String rfid,
  required String expectedTime,
}) async {
  final response = await http.post(
    Uri.parse('$apiUrl/api/reservations'),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({
      'name': name,
      'plate_number': plate,
      'rfid_uid': rfid,
      'expected_time_in': expectedTime,
    }),
  );

  return response.statusCode == 201;
}



static Future<List<dynamic>> fetchReservations() async {
  final response = await http.get(Uri.parse("$apiUrl/api/reservations"));
  if (response.statusCode == 200) {
    return jsonDecode(response.body) as List<dynamic>;
  } else {
    throw Exception("Failed to load reservations");
  }
}



}


