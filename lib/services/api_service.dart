

// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'package:web_socket_channel/io.dart';
// import 'package:web_socket_channel/web_socket_channel.dart';

// class ApiService {
//   // Base URL for REST API and WebSockets
// static final String apiUrl = "https://tuparkhehe-production.up.railway.app";
// static const String wsUrl = "wss://tuparkhehe-production.up.railway.app/ws";
// static const String wsUnifiedUrl = "wss://tuparkhehe-production.up.railway.app/ws";


//   // Fetch all users
//   static Future<List<dynamic>> fetchUsers() async {
//     final response = await http.get(Uri.parse("$apiUrl/api/users"));
//     if (response.statusCode == 200) {
//       return jsonDecode(response.body) as List<dynamic>;
//     } else {
//       throw Exception("Failed to load users");
//     }
//   }

  

//   // Login function
//   Future<bool> login(String email, String password) async {
//     final response = await http.post(
//       Uri.parse("$apiUrl/login"),
//       headers: {"Content-Type": "application/json"},
//       body: jsonEncode({"email": email, "password": password}),
//     );
//     return response.statusCode == 200;
//   }

//   // Add a new user
// // ✅ Updated Add User method with vehicle_type
// static Future<bool> addUser(String name, String plate, String rfid, String vehicleType) async {
//   if (rfid == "Waiting..." || rfid.isEmpty) {
//     print("⚠️ No valid RFID scanned.");
//     return false;
//   }

//   final response = await http.post(
//     Uri.parse('$apiUrl/api/users'),
//     headers: {'Content-Type': 'application/json'},
//     body: json.encode({
//       'name': name,
//       'plate_number': plate,
//       'rfid_uid': rfid,
//       'vehicle_type': vehicleType,  // ✅ Added field
//     }),
//   );

//   if (response.statusCode == 201) {
//     print("✅ User added successfully.");
//     return true;
//   } else if (response.statusCode == 409) {
//     print("🚫 RFID UID is already in use by an ACTIVE user.");
//     return false;
//   } else {
//     print("❌ Failed to add user: ${response.body}");
//     return false;
//   }
// }


//   // Exit a user manually via REST API
//   static Future<bool> exitUser(String rfid) async {
//     try {
//       final response = await http.post(
//         Uri.parse('$apiUrl/api/users/exit'),
//         headers: {'Content-Type': 'application/json'},
//         body: json.encode({'rfid_uid': rfid}),
//       );
//       if (response.statusCode == 200) {
//         print("✅ User exit processed.");
//         return true;
//       } else {
//         print("❌ Failed to process exit: ${response.body}");
//         return false;
//       }
//     } catch (e) {
//       print('❌ Error exiting user: $e');
//       return false;
//     }
//   }

//   // ===== WebSocket for Entrance Scans =====
//   static WebSocketChannel? _entranceChannel;
// static void listenToEntranceWebSocket(Function(String) onRFIDReceived) {
//   _entranceChannel = IOWebSocketChannel.connect(Uri.parse(wsUrl));
//   print("🔗 Connecting to WebSocket (Entrance): $wsUrl");

//   _entranceChannel!.stream.listen((data) {
//     print("📩 WebSocket (Entrance) Message Received: $data");

//     try {
//       final decoded = jsonDecode(data);

//       if (decoded['scanned_uid'] != null && decoded['type'] == 'ENTRANCE') {
//         final uid = decoded['scanned_uid'];
//         onRFIDReceived(uid);
//       } else if (decoded['update'] == 'reservation_activated') {
//         print("🚀 Reservation moved to ACTIVE: ${decoded['rfid_uid']}");
//         onRFIDReceived(decoded['rfid_uid']);
//       }
//     } catch (e) {
//       print("❌ JSON Parse Error (Entrance): $e");
//     }
//   }, onError: (error) {
//     print("❌ WebSocket (Entrance) Error: $error");
//   }, onDone: () {
//     print("🔌 Entrance WebSocket Closed");
//   });
// }


//   // ===== WebSocket for Exit Scans =====
//   static WebSocketChannel? _exitChannel;
//   static void listenToExitWebSocket(Function(String) onRFIDReceived) {
//   _exitChannel = IOWebSocketChannel.connect(Uri.parse(wsUnifiedUrl));
//   print("🔗 Connecting to WebSocket (Exit): $wsUnifiedUrl");

//   _exitChannel!.stream.listen((data) {
//     print("📩 WebSocket Message (Exit) Received: $data");

//     try {
//       final decoded = jsonDecode(data);

//       if (decoded['scanned_uid'] != null && decoded['type'] == 'EXIT_SCAN') {
//         final uid = decoded['scanned_uid'];
//         onRFIDReceived(uid);  // Trigger display on UI
//       }
//     } catch (e) {
//       print("❌ JSON Parse Error (Exit): $e");
//     }
//   }, onError: (error) {
//     print("❌ WebSocket Error (Exit): $error");
//   }, onDone: () {
//     print("🔌 Exit WebSocket Closed");
//   });
//  }


//   // Dispose both WebSocket channels
//   static void disposeWebSockets() {
//     if (_entranceChannel != null) {
//       _entranceChannel!.sink.close();
//       print("🔴 Entrance WebSocket Closed");
//     }
//     if (_exitChannel != null) {
//       _exitChannel!.sink.close();
//       print("🔴 Exit WebSocket Closed");
//     }
//   }

// static Future<List<dynamic>> fetchInactiveUsers() async {
//   final response = await http.get(Uri.parse("$apiUrl/api/users/inactive"));
//   if (response.statusCode == 200) {
//     return jsonDecode(response.body) as List<dynamic>;
//   } else {
//     throw Exception("Failed to load inactive users");
//   }
// }


// // ✅ Updated Reservation Add method with vehicle_type
// static Future<bool> addReservation({
//   required String name,
//   required String plate,
//   required String rfid,
//   required String expectedTime,
//   required String vehicleType,
// }) async {
//   final response = await http.post(
//     Uri.parse('$apiUrl/api/reservations'),
//     headers: {'Content-Type': 'application/json'},
//     body: jsonEncode({
//       'name': name,
//       'plate_number': plate,
//       'rfid_uid': rfid,
//       'expected_time_in': expectedTime,
//       'vehicle_type': vehicleType,
//     }),
//   );

//   return response.statusCode == 201;
// }



// static Future<List<dynamic>> fetchReservations() async {
//   final response = await http.get(Uri.parse("$apiUrl/api/reservations"));
//   if (response.statusCode == 200) {
//     return jsonDecode(response.body) as List<dynamic>;
//   } else {
//     throw Exception("Failed to load reservations");
//   }
// }

// static Future<Map<String, dynamic>?> fetchUserDetails(String rfid) async {
//   try {
//     final url = '$apiUrl/api/users/$rfid';
//     print("📡 Fetching user details from: $url");

//     final response = await http.get(Uri.parse(url));

//     if (response.statusCode == 200) {
//       print("✅ User data: ${response.body}");
//       return jsonDecode(response.body);
//     } else {
//       print("❌ No active user found. Status: ${response.statusCode}");
//       return null;
//     }
//   } catch (e) {
//     print("❌ Error fetching user: $e");
//     return null;
//   }
// }

// static void listenToReservationActivation(Function(String) onRFIDActivated) {
//   _entranceChannel ??= IOWebSocketChannel.connect(Uri.parse(wsUrl));
//   print("🔗 Listening for reservation activation on WebSocket: $wsUrl");

//   _entranceChannel!.stream.listen((data) {
//     try {
//       final decoded = jsonDecode(data);
//       if (decoded['update'] == 'reservation_activated' && decoded['rfid_uid'] != null) {
//         onRFIDActivated(decoded['rfid_uid']);
//       }
//     } catch (e) {
//       print("❌ Error decoding reservation activation message: $e");
//     }
//   }, onError: (error) {
//     print("❌ WebSocket error (reservation activation): $error");
//   });
// }

// }

// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'package:web_socket_channel/io.dart';
// import 'package:web_socket_channel/web_socket_channel.dart';

// class ApiService {
//   static final String apiUrl = "https://tuparkhehe-production.up.railway.app";
//   static const String wsUrl = "wss://tuparkhehe-production.up.railway.app/ws";
//   static const String wsUnifiedUrl = "wss://tuparkhehe-production.up.railway.app/ws";

//   // Login method
//   Future<bool> login(String email, String password) async {
//     final response = await http.post(
//       Uri.parse("$apiUrl/login"),
//       headers: {"Content-Type": "application/json"},
//       body: jsonEncode({"email": email, "password": password}),
//     );
//     return response.statusCode == 200;
//   }

//   // ===== REST API METHODS =====
//   static Future<List<dynamic>> fetchUsers() async {
//     final response = await http.get(Uri.parse("$apiUrl/api/users"));
//     if (response.statusCode == 200) {
//       return jsonDecode(response.body) as List<dynamic>;
//     } else {
//       throw Exception("Failed to load users");
//     }
//   }

//   static Future<List<dynamic>> fetchInactiveUsers() async {
//     final response = await http.get(Uri.parse("$apiUrl/api/users/inactive"));
//     if (response.statusCode == 200) {
//       return jsonDecode(response.body) as List<dynamic>;
//     } else {
//       throw Exception("Failed to load inactive users");
//     }
//   }

//   static Future<bool> addUser(String name, String plate, String rfid, String vehicleType) async {
//     if (rfid == "Waiting..." || rfid.isEmpty) {
//       print("⚠️ No valid RFID scanned.");
//       return false;
//     }

//     final response = await http.post(
//       Uri.parse('$apiUrl/api/users'),
//       headers: {'Content-Type': 'application/json'},
//       body: json.encode({
//         'name': name,
//         'plate_number': plate,
//         'rfid_uid': rfid,
//         'vehicle_type': vehicleType,
//       }),
//     );

//     if (response.statusCode == 201) {
//       print("✅ User added successfully.");
//       return true;
//     } else if (response.statusCode == 409) {
//       print("🚫 RFID UID is already in use by an ACTIVE user.");
//       return false;
//     } else {
//       print("❌ Failed to add user: ${response.body}");
//       return false;
//     }
//   }

//   static Future<bool> exitUser(String rfid) async {
//     try {
//       final response = await http.post(
//         Uri.parse('$apiUrl/api/users/exit'),
//         headers: {'Content-Type': 'application/json'},
//         body: json.encode({'rfid_uid': rfid}),
//       );
//       if (response.statusCode == 200) {
//         print("✅ User exit processed.");
//         return true;
//       } else {
//         print("❌ Failed to process exit: ${response.body}");
//         return false;
//       }
//     } catch (e) {
//       print('❌ Error exiting user: $e');
//       return false;
//     }
//   }

//   static Future<bool> addReservation({
//     required String name,
//     required String plate,
//     required String rfid,
//     required String expectedTime,
//     required String vehicleType,
//   }) async {
//     final response = await http.post(
//       Uri.parse('$apiUrl/api/reservations'),
//       headers: {'Content-Type': 'application/json'},
//       body: jsonEncode({
//         'name': name,
//         'plate_number': plate,
//         'rfid_uid': rfid,
//         'expected_time_in': expectedTime,
//         'vehicle_type': vehicleType,
//       }),
//     );

//     return response.statusCode == 201;
//   }

//   static Future<List<dynamic>> fetchReservations() async {
//     final response = await http.get(Uri.parse("$apiUrl/api/reservations"));
//     if (response.statusCode == 200) {
//       return jsonDecode(response.body) as List<dynamic>;
//     } else {
//       throw Exception("Failed to load reservations");
//     }
//   }

//   static Future<Map<String, dynamic>?> fetchUserDetails(String rfid) async {
//     try {
//       final url = '$apiUrl/api/users/$rfid';
//       print("📡 Fetching user details from: $url");

//       final response = await http.get(Uri.parse(url));

//       if (response.statusCode == 200) {
//         print("✅ User data: ${response.body}");
//         return jsonDecode(response.body);
//       } else {
//         print("❌ No active user found. Status: ${response.statusCode}");
//         return null;
//       }
//     } catch (e) {
//       print("❌ Error fetching user: $e");
//       return null;
//     }
//   }

//   // ===== WebSocket Setup =====
//   static WebSocketChannel? _entranceChannel;
//   static WebSocketChannel? _exitChannel;
//   static bool _isListeningEntrance = false;
//   static bool _isListeningExit = false;

//   static void listenToEntranceWebSocket(Function(String) onRFIDReceived) {
//     if (_isListeningEntrance) return;
//     _isListeningEntrance = true;

//     _entranceChannel ??= IOWebSocketChannel.connect(Uri.parse(wsUrl));
//     print("🔗 Connecting to WebSocket (Entrance): $wsUrl");

//     _entranceChannel!.stream.listen((data) {
//       print("📩 WebSocket (Entrance) Message Received: $data");
//       try {
//         final decoded = jsonDecode(data);
//         if (decoded['scanned_uid'] != null && decoded['type'] == 'ENTRANCE') {
//           final uid = decoded['scanned_uid'];
//           onRFIDReceived(uid);
//         } else if (decoded['update'] == 'reservation_activated') {
//           print("🚀 Reservation moved to ACTIVE: ${decoded['rfid_uid']}");
//           onRFIDReceived(decoded['rfid_uid']);
//         }
//       } catch (e) {
//         print("❌ JSON Parse Error (Entrance): $e");
//       }
//     }, onError: (error) {
//       print("❌ WebSocket (Entrance) Error: $error");
//     }, onDone: () {
//       print("🔌 Entrance WebSocket Closed");
//       _isListeningEntrance = false;
//     });
//   }

//   static void listenToExitWebSocket(Function(String) onRFIDReceived) {
//     if (_isListeningExit) return;
//     _isListeningExit = true;

//     _exitChannel ??= IOWebSocketChannel.connect(Uri.parse(wsUnifiedUrl));
//     print("🔗 Connecting to WebSocket (Exit): $wsUnifiedUrl");

//     _exitChannel!.stream.listen((data) {
//       print("📩 WebSocket Message (Exit) Received: $data");

//       try {
//         final decoded = jsonDecode(data);
//         if (decoded['scanned_uid'] != null && decoded['type'] == 'EXIT_SCAN') {
//           final uid = decoded['scanned_uid'];
//           onRFIDReceived(uid);
//         }
//       } catch (e) {
//         print("❌ JSON Parse Error (Exit): $e");
//       }
//     }, onError: (error) {
//       print("❌ WebSocket Error (Exit): $error");
//     }, onDone: () {
//       print("🔌 Exit WebSocket Closed");
//       _isListeningExit = false;
//     });
//   }

//   static void listenToReservationActivation(Function(String) onRFIDActivated) {
//     listenToEntranceWebSocket((rfid) {
//       onRFIDActivated(rfid);
//     });
//   }

//   static void disposeWebSockets() {
//     if (_entranceChannel != null) {
//       _entranceChannel!.sink.close();
//       _entranceChannel = null;
//       _isListeningEntrance = false;
//       print("🔴 Entrance WebSocket Closed");
//     }
//     if (_exitChannel != null) {
//       _exitChannel!.sink.close();
//       _exitChannel = null;
//       _isListeningExit = false;
//       print("🔴 Exit WebSocket Closed");
//     }
//   }
// }

// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'package:web_socket_channel/io.dart';
// import 'package:web_socket_channel/web_socket_channel.dart';
// import 'package:intl/intl.dart';

// class ApiService {
//   static final String apiUrl = "https://tuparkhehe-production.up.railway.app";
//   static const String wsUrl = "wss://tuparkhehe-production.up.railway.app/ws";
//   static const String wsUnifiedUrl = "wss://tuparkhehe-production.up.railway.app/ws";

//   // ✅ LOGIN FUNCTION
//   Future<bool> login(String email, String password) async {
//     final response = await http.post(
//       Uri.parse("$apiUrl/login"),
//       headers: {"Content-Type": "application/json"},
//       body: jsonEncode({"email": email, "password": password}),
//     );
//     return response.statusCode == 200;
//   }

//   // ✅ FETCH USERS (ACTIVE)
//   static Future<List<dynamic>> fetchUsers() async {
//     final response = await http.get(Uri.parse("$apiUrl/api/users"));
//     if (response.statusCode == 200) {
//       return jsonDecode(response.body) as List<dynamic>;
//     } else {
//       throw Exception("Failed to load users");
//     }
//   }

//   // ✅ FETCH INACTIVE USERS
//   static Future<List<dynamic>> fetchInactiveUsers() async {
//     final response = await http.get(Uri.parse("$apiUrl/api/users/inactive"));
//     if (response.statusCode == 200) {
//       return jsonDecode(response.body) as List<dynamic>;
//     } else {
//       throw Exception("Failed to load inactive users");
//     }
//   }

//   // ✅ ADD USER WITH VEHICLE TYPE
//   static Future<bool> addUser(String name, String plate, String rfid, String vehicleType) async {
//     if (rfid == "Waiting..." || rfid.isEmpty) {
//       print("⚠️ No valid RFID scanned.");
//       return false;
//     }

//     final response = await http.post(
//       Uri.parse('$apiUrl/api/users'),
//       headers: {'Content-Type': 'application/json'},
//       body: jsonEncode({
//         'name': name,
//         'plate_number': plate,
//         'rfid_uid': rfid,
//         'vehicle_type': vehicleType,
//       }),
//     );

//     if (response.statusCode == 201) {
//       print("✅ User added successfully.");
//       return true;
//     } else if (response.statusCode == 409) {
//       print("🚫 RFID UID is already in use by an ACTIVE user.");
//       return false;
//     } else {
//       print("❌ Failed to add user: ${response.body}");
//       return false;
//     }
//   }

//   // ✅ EXIT USER
//   static Future<bool> exitUser(String rfid) async {
//     try {
//       final response = await http.post(
//         Uri.parse('$apiUrl/api/users/exit'),
//         headers: {'Content-Type': 'application/json'},
//         body: jsonEncode({'rfid_uid': rfid}),
//       );
//       if (response.statusCode == 200) {
//         print("✅ User exit processed.");
//         return true;
//       } else {
//         print("❌ Failed to process exit: ${response.body}");
//         return false;
//       }
//     } catch (e) {
//       print("❌ Error exiting user: $e");
//       return false;
//     }
//   }

//   // ✅ ADD RESERVATION (Accurate date formatting)
//   static Future<bool> addReservation({
//     required String name,
//     required String plate,
//     required String rfid,
//     required DateTime expectedDateTime,
//     required String vehicleType,
//   }) async {
//     final expectedTime = DateFormat("yyyy-MM-dd HH:mm:ss").format(expectedDateTime);

//     final response = await http.post(
//       Uri.parse('$apiUrl/api/reservations'),
//       headers: {'Content-Type': 'application/json'},
//       body: jsonEncode({
//         'name': name,
//         'plate_number': plate,
//         'rfid_uid': rfid,
//         'expected_time_in': expectedTime,
//         'vehicle_type': vehicleType,
//       }),
//     );

//     if (response.statusCode == 201) {
//       print("✅ Reservation added.");
//       return true;
//     } else {
//       print("❌ Failed to add reservation: ${response.body}");
//       return false;
//     }
//   }

//   // ✅ FETCH RESERVATIONS
//   static Future<List<dynamic>> fetchReservations() async {
//     final response = await http.get(Uri.parse("$apiUrl/api/reservations"));
//     if (response.statusCode == 200) {
//       return jsonDecode(response.body) as List<dynamic>;
//     } else {
//       throw Exception("Failed to load reservations");
//     }
//   }

//   // ✅ FETCH USER BY RFID
//   static Future<Map<String, dynamic>?> fetchUserDetails(String rfid) async {
//     try {
//       final url = '$apiUrl/api/users/$rfid';
//       final response = await http.get(Uri.parse(url));

//       if (response.statusCode == 200) {
//         return jsonDecode(response.body);
//       } else {
//         print("❌ No active user found. Status: ${response.statusCode}");
//         return null;
//       }
//     } catch (e) {
//       print("❌ Error fetching user: $e");
//       return null;
//     }
//   }

//   // ✅ WEBSOCKET HANDLING
//   static WebSocketChannel? _entranceChannel;
//   static WebSocketChannel? _exitChannel;
//   static bool _isListeningEntrance = false;
//   static bool _isListeningExit = false;

//   static void listenToEntranceWebSocket(Function(String) onRFIDReceived) {
//     if (_isListeningEntrance) return;
//     _isListeningEntrance = true;

//     _entranceChannel ??= IOWebSocketChannel.connect(Uri.parse(wsUrl));
//     print("🔗 Connecting to WebSocket (Entrance): $wsUrl");

//     _entranceChannel!.stream.listen((data) {
//       try {
//         final decoded = jsonDecode(data);
//         if (decoded['scanned_uid'] != null && decoded['type'] == 'ENTRANCE') {
//           onRFIDReceived(decoded['scanned_uid']);
//         } else if (decoded['update'] == 'reservation_activated') {
//           onRFIDReceived(decoded['rfid_uid']);
//         }
//       } catch (e) {
//         print("❌ JSON Parse Error (Entrance): $e");
//       }
//     }, onError: (error) {
//       print("❌ WebSocket (Entrance) Error: $error");
//     }, onDone: () {
//       print("🔌 Entrance WebSocket Closed");
//       _isListeningEntrance = false;
//     });
//   }

//   static void listenToExitWebSocket(Function(String) onRFIDReceived) {
//     if (_isListeningExit) return;
//     _isListeningExit = true;

//     _exitChannel ??= IOWebSocketChannel.connect(Uri.parse(wsUnifiedUrl));
//     print("🔗 Connecting to WebSocket (Exit): $wsUnifiedUrl");

//     _exitChannel!.stream.listen((data) {
//       try {
//         final decoded = jsonDecode(data);
//         if (decoded['scanned_uid'] != null && decoded['type'] == 'EXIT_SCAN') {
//           onRFIDReceived(decoded['scanned_uid']);
//         }
//       } catch (e) {
//         print("❌ JSON Parse Error (Exit): $e");
//       }
//     }, onError: (error) {
//       print("❌ WebSocket Error (Exit): $error");
//     }, onDone: () {
//       print("🔌 Exit WebSocket Closed");
//       _isListeningExit = false;
//     });
//   }

//   static void disposeWebSockets() {
//     if (_entranceChannel != null) {
//       _entranceChannel!.sink.close();
//       _entranceChannel = null;
//       _isListeningEntrance = false;
//       print("🔴 Entrance WebSocket Closed");
//     }
//     if (_exitChannel != null) {
//       _exitChannel!.sink.close();
//       _exitChannel = null;
//       _isListeningExit = false;
//       print("🔴 Exit WebSocket Closed");
//     }
//   }
// }


import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:intl/intl.dart';

class ApiService {
  static final String apiUrl = "https://tuparkhehe-production.up.railway.app";
  static const String wsUrl = "wss://tuparkhehe-production.up.railway.app/ws";
  static const String wsUnifiedUrl = "wss://tuparkhehe-production.up.railway.app/ws";

  // ✅ LOGIN FUNCTION
  Future<bool> login(String email, String password) async {
    final response = await http.post(
      Uri.parse("$apiUrl/login"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"email": email, "password": password}),
    );
    return response.statusCode == 200;
  }

  // ✅ FETCH USERS (ACTIVE)
  static Future<List<dynamic>> fetchUsers() async {
    final response = await http.get(Uri.parse("$apiUrl/api/users"));
    if (response.statusCode == 200) {
      return jsonDecode(response.body) as List<dynamic>;
    } else {
      throw Exception("Failed to load users");
    }
  }

  // ✅ FETCH INACTIVE USERS
  static Future<List<dynamic>> fetchInactiveUsers() async {
    final response = await http.get(Uri.parse("$apiUrl/api/users/inactive"));
    if (response.statusCode == 200) {
      return jsonDecode(response.body) as List<dynamic>;
    } else {
      throw Exception("Failed to load inactive users");
    }
  }

  // ✅ ADD USER WITH VEHICLE TYPE
  static Future<bool> addUser(String name, String plate, String rfid, String vehicleType) async {
    if (rfid == "Waiting..." || rfid.isEmpty) {
      print("⚠️ No valid RFID scanned.");
      return false;
    }

    final response = await http.post(
      Uri.parse('$apiUrl/api/users'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'name': name,
        'plate_number': plate,
        'rfid_uid': rfid,
        'vehicle_type': vehicleType,
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

  // ✅ EXIT USER
  static Future<bool> exitUser(String rfid) async {
    try {
      final response = await http.post(
        Uri.parse('$apiUrl/api/users/exit'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'rfid_uid': rfid}),
      );
      if (response.statusCode == 200) {
        print("✅ User exit processed.");
        return true;
      } else {
        print("❌ Failed to process exit: ${response.body}");
        return false;
      }
    } catch (e) {
      print("❌ Error exiting user: $e");
      return false;
    }
  }

  // ✅ ADD RESERVATION (Accurate date formatting)
  static Future<bool> addReservation({
    required String name,
    required String plate,
    required String rfid,
    required String expectedTime, // <- this is correct
    required String vehicleType,
  }) async {
    final formattedExpectedTime = expectedTime; // Already a String, assumed formatted in caller

    final response = await http.post(
      Uri.parse('$apiUrl/api/reservations'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'name': name,
        'plate_number': plate,
        'rfid_uid': rfid,
        'expected_time_in': formattedExpectedTime,
        'vehicle_type': vehicleType,
      }),
    );


    if (response.statusCode == 201) {
      print("✅ Reservation added.");
      return true;
    } else {
      print("❌ Failed to add reservation: ${response.body}");
      return false;
    }
  }

  // ✅ FETCH RESERVATIONS
  static Future<List<dynamic>> fetchReservations() async {
    final response = await http.get(Uri.parse("$apiUrl/api/reservations"));
    if (response.statusCode == 200) {
      return jsonDecode(response.body) as List<dynamic>;
    } else {
      throw Exception("Failed to load reservations");
    }
  }

  // ✅ FETCH USER BY RFID
  static Future<Map<String, dynamic>?> fetchUserDetails(String rfid) async {
    try {
      final url = '$apiUrl/api/users/$rfid';
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        print("❌ No active user found. Status: ${response.statusCode}");
        return null;
      }
    } catch (e) {
      print("❌ Error fetching user: $e");
      return null;
    }
  }

  // ✅ WEBSOCKET HANDLING
  static WebSocketChannel? _entranceChannel;
  static WebSocketChannel? _exitChannel;
  static bool _isListeningEntrance = false;
  static bool _isListeningExit = false;

  static void listenToEntranceWebSocket(Function(String) onRFIDReceived) {
    if (_isListeningEntrance) return;
    _isListeningEntrance = true;

    _entranceChannel ??= IOWebSocketChannel.connect(Uri.parse(wsUrl));
    print("🔗 Connecting to WebSocket (Entrance): $wsUrl");

    _entranceChannel!.stream.listen((data) {
      try {
        final decoded = jsonDecode(data);
        if (decoded['scanned_uid'] != null && decoded['type'] == 'ENTRANCE') {
          onRFIDReceived(decoded['scanned_uid']);
        } else if (decoded['update'] == 'reservation_activated') {
          onRFIDReceived(decoded['rfid_uid']);
        }
      } catch (e) {
        print("❌ JSON Parse Error (Entrance): $e");
      }
    }, onError: (error) {
      print("❌ WebSocket (Entrance) Error: $error");
    }, onDone: () {
      print("🔌 Entrance WebSocket Closed");
      _isListeningEntrance = false;
    });
  }

  static void listenToExitWebSocket(Function(String) onRFIDReceived) {
    if (_isListeningExit) return;
    _isListeningExit = true;

    _exitChannel ??= IOWebSocketChannel.connect(Uri.parse(wsUnifiedUrl));
    print("🔗 Connecting to WebSocket (Exit): $wsUnifiedUrl");

    _exitChannel!.stream.listen((data) {
      try {
        final decoded = jsonDecode(data);
        if (decoded['scanned_uid'] != null && decoded['type'] == 'EXIT_SCAN') {
          onRFIDReceived(decoded['scanned_uid']);
        }
      } catch (e) {
        print("❌ JSON Parse Error (Exit): $e");
      }
    }, onError: (error) {
      print("❌ WebSocket Error (Exit): $error");
    }, onDone: () {
      print("🔌 Exit WebSocket Closed");
      _isListeningExit = false;
    });
  }

  static void disposeWebSockets() {
    if (_entranceChannel != null) {
      _entranceChannel!.sink.close();
      _entranceChannel = null;
      _isListeningEntrance = false;
      print("🔴 Entrance WebSocket Closed");
    }
    if (_exitChannel != null) {
      _exitChannel!.sink.close();
      _exitChannel = null;
      _isListeningExit = false;
      print("🔴 Exit WebSocket Closed");
    }
  }
}
