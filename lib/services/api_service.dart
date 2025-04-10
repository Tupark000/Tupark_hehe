
// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'package:web_socket_channel/io.dart';
// import 'package:web_socket_channel/web_socket_channel.dart';

// class ApiService {
//   static final String apiUrl = "http://192.168.100.201:5000"; 

//   static const String wsUrl = "ws://192.168.100.201:3001";


//    // Login Function
//     Future<bool> login(String email, String password) async {
//     final response = await http.post(
//       Uri.parse("$apiUrl/login"),
//       headers: {"Content-Type": "application/json"},
//       body: jsonEncode({"email": email, "password": password}),
//     );

//     if (response.statusCode == 200) {
//       return true; // Login successful
//     } else {
//       return false; // Invalid credentials
//     }
//   }


//   // Fetch all users for the dashboard
//   static Future<List<dynamic>> fetchUsers() async {
//     final response = await http.get(Uri.parse("$apiUrl/api/users"));
//     if (response.statusCode == 200) {
//       return jsonDecode(response.body) as List<dynamic>;
//     } else {
//       throw Exception("Failed to load users");
//     }
//   }

//    static Future<bool> addUser(String name, String plate, String rfid) async {
//     try {
//       final response = await http.post(
//         Uri.parse('$apiUrl/api/users'),
//         headers: {'Content-Type': 'application/json'},
//         body: json.encode({
//           'name': name,
//           'plate_number': plate,
//           'rfid_uid': rfid,
//         }),
//       );
//       return response.statusCode == 201;
//     } catch (e) {
//       print('Error adding user: $e');
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
//       return response.statusCode == 200;
//     } catch (e) {
//       print('Error exiting user: $e');
//       return false;
//     }
//   }

  
//   // WebSocket functionality for real-time RFID scanning
//   static WebSocketChannel? _channel;

//   // Start listening on the WebSocket for RFID messages
//   static void listenToWebSocket(Function(String) onMessage) {
//     _channel = IOWebSocketChannel.connect(Uri.parse(wsUrl));
//     _channel!.stream.listen((data) {
//       final message = data.toString().trim();
//       onMessage(message);
//     });
//   }

//   // Close the WebSocket connection when done
//   static void disposeWebSocket() {
//     _channel?.sink.close();
//   }
// }


// //GOODS NA TO KASO AYAW PA MAG REALIME UPDATE

// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'package:web_socket_channel/io.dart';
// import 'package:web_socket_channel/web_socket_channel.dart';

// class ApiService {
//   static final String apiUrl = "http://192.168.100.201:5000";
//   static const String wsUrl = "ws://192.168.100.201:3001/ws/entrance"; 

//   // Login Function
//   Future<bool> login(String email, String password) async {
//     final response = await http.post(
//       Uri.parse("$apiUrl/login"),
//       headers: {"Content-Type": "application/json"},
//       body: jsonEncode({"email": email, "password": password}),
//     );
//     return response.statusCode == 200;
//   }

//   // Fetch all users for the dashboard
//   static Future<List<dynamic>> fetchUsers() async {
//     final response = await http.get(Uri.parse("$apiUrl/api/users"));
//     if (response.statusCode == 200) {
//       return jsonDecode(response.body) as List<dynamic>;
//     } else {
//       throw Exception("Failed to load users");
//     }
//   }

//   // Add user
//   static Future<bool> addUser(String name, String plate, String rfid) async {
//     try {
//       if (rfid == "Waiting...") {
//         print("⚠️ No valid RFID scanned.");
//         return false;
//       }

//       final response = await http.post(
//         Uri.parse('$apiUrl/api/users'),
//         headers: {'Content-Type': 'application/json'},
//         body: json.encode({'name': name, 'plate_number': plate, 'rfid_uid': rfid}),
//       );
//       return response.statusCode == 201;
//     } catch (e) {
//       print('❌ Error adding user: $e');
//       return false;
//     }
//   }

//   // Exit user
//   static Future<bool> exitUser(String rfid) async {
//     try {
//       final response = await http.post(
//         Uri.parse('$apiUrl/api/users/exit'),
//         headers: {'Content-Type': 'application/json'},
//         body: json.encode({'rfid_uid': rfid}),
//       );
//       return response.statusCode == 200;
//     } catch (e) {
//       print('❌ Error exiting user: $e');
//       return false;
//     }
//   }

//   // WebSocket functionality for real-time RFID scanning
//   static WebSocketChannel? _channel;
//   static Function(String)? _onRFIDReceived;

//   // Start listening on the WebSocket for RFID messages
//     static void listenToWebSocket(Function(String) onRFIDReceived) {
//     _channel = IOWebSocketChannel.connect(Uri.parse(wsUrl));
//     print("🔗 Connecting to WebSocket: $wsUrl");

//     _channel!.stream.listen((data) {
//       print("📩 WebSocket Message Received: $data");  // Debug log

//       try {
//         final decodedMessage = jsonDecode(data);
//         if (decodedMessage['success'] == true && decodedMessage['rfid'] != null) {
//           String receivedRFID = decodedMessage['rfid'];
//           print("🎯 Valid RFID: $receivedRFID");
//           onRFIDReceived(receivedRFID);  // Send RFID to UI
//         } else {
//           print("⚠️ WebSocket Invalid Data: $decodedMessage");
//         }
//       } catch (e) {
//         print("❌ WebSocket JSON Error: $e");
//       }
//     }, onError: (error) {
//       print("❌ WebSocket Error: $error");
//     }, onDone: () {
//       print("🔴 WebSocket Closed");
//     });
//   }


//   // Handle WebSocket reconnection
//   static void _reconnectWebSocket() async {
//     print("🔄 Reconnecting WebSocket...");
//     await Future.delayed(Duration(seconds: 3)); // Wait before reconnecting
//     listenToWebSocket(_onRFIDReceived!);
//   }

//   // Close WebSocket when done
//   static void disposeWebSocket() {
//     if (_channel != null) {
//       _channel!.sink.close();
//       print("🔴 WebSocket Closed");
//     }
//   }
// }

// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'package:web_socket_channel/io.dart';
// import 'package:web_socket_channel/web_socket_channel.dart';

// class ApiService {
//   static final String apiUrl = "http://192.168.100.201:5000";
//   static const String wsUrl = "ws://192.168.100.201:3001"; 

  // // Login Function
  // Future<bool> login(String email, String password) async {
  //   final response = await http.post(
  //     Uri.parse("$apiUrl/login"),
  //     headers: {"Content-Type": "application/json"},
  //     body: jsonEncode({"email": email, "password": password}),
  //   );
  //   return response.statusCode == 200;
  // }

//   // Fetch all users for the dashboard
//   static Future<List<dynamic>> fetchUsers() async {
//     final response = await http.get(Uri.parse("$apiUrl/api/users"));
//     if (response.statusCode == 200) {
//       return jsonDecode(response.body) as List<dynamic>;
//     } else {
//       throw Exception("Failed to load users");
//     }
//   }

//   // Add user
//   static Future<bool> addUser(String name, String plate, String rfid) async {
//     try {
//       if (rfid == "Waiting...") {
//         print("⚠️ No valid RFID scanned.");
//         return false;
//       }

//       final response = await http.post(
//         Uri.parse('$apiUrl/api/users'),
//         headers: {'Content-Type': 'application/json'},
//         body: json.encode({'name': name, 'plate_number': plate, 'rfid_uid': rfid}),
//       );
//       return response.statusCode == 201;
//     } catch (e) {
//       print('❌ Error adding user: $e');
//       return false;
//     }
//   }

  // // Exit user
  // static Future<bool> exitUser(String rfid) async {
  //   try {
  //     final response = await http.post(
  //       Uri.parse('$apiUrl/api/users/exit'),
  //       headers: {'Content-Type': 'application/json'},
  //       body: json.encode({'rfid_uid': rfid}),
  //     );
  //     return response.statusCode == 200;
  //   } catch (e) {
  //     print('❌ Error exiting user: $e');
  //     return false;
  //   }
  // }

//   // WebSocket functionality for real-time RFID scanning
//   static WebSocketChannel? _channel;
//   static Function(String, String)? _onRFIDReceived;

//   static void listenToWebSocket(Function(String, String) onRFIDReceived) {
//     _onRFIDReceived = onRFIDReceived;
//     _channel = IOWebSocketChannel.connect(Uri.parse(wsUrl));
//     print("🔗 Connecting to WebSocket: $wsUrl");

//     _channel!.stream.listen((data) {
//       print("📩 WebSocket Message Received: $data"); 

//       try {
//         final decodedMessage = jsonDecode(data);
//         if (decodedMessage['success'] == true && decodedMessage['scanned_uid'] != null) {
//           String receivedRFID = decodedMessage['scanned_uid'];
//           String type = decodedMessage['type'];
//           print("🎯 RFID Scanned: $receivedRFID ($type)");
//           _onRFIDReceived!(receivedRFID, type);
//         } else {
//           print("⚠️ WebSocket Invalid Data: $decodedMessage");
//         }
//       } catch (e) {
//         print("❌ WebSocket JSON Error: $e");
//       }
//     }, onError: (error) {
//       print("❌ WebSocket Error: $error");
//     }, onDone: () {
//       print("🔴 WebSocket Closed");
//       _reconnectWebSocket();
//     });
//   }

//   static void _reconnectWebSocket() async {
//     print("🔄 Reconnecting WebSocket...");
//     await Future.delayed(Duration(seconds: 3)); 
//     listenToWebSocket(_onRFIDReceived!);
//   }

//   static void disposeWebSocket() {
//     _channel?.sink.close();
//     print("🔴 WebSocket Closed");
//   }
// }

// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'package:web_socket_channel/io.dart';
// import 'package:web_socket_channel/web_socket_channel.dart';

// class ApiService {
//   static final String apiUrl = "http://192.168.100.201:5000";
//   static const String wsUrl = "ws://192.168.100.201:3001";

//   // Fetch all users for the dashboard
//   static Future<List<dynamic>> fetchUsers() async {
//     final response = await http.get(Uri.parse("$apiUrl/api/users"));
//     if (response.statusCode == 200) {
//       return jsonDecode(response.body) as List<dynamic>;
//     } else {
//       throw Exception("Failed to load users");
//     }
//   }

//    // Login Function
//   Future<bool> login(String email, String password) async {
//     final response = await http.post(
//       Uri.parse("$apiUrl/login"),
//       headers: {"Content-Type": "application/json"},
//       body: jsonEncode({"email": email, "password": password}),
//     );
//     return response.statusCode == 200;
//   }

//   // Add user
//   static Future<bool> addUser(String name, String plate, String rfid) async {
//     if (rfid == "Waiting..." || rfid.isEmpty) {
//       print("⚠️ No valid RFID scanned.");
//       return false;
//     }

//     final response = await http.post(
//       Uri.parse('$apiUrl/api/users'),
//       headers: {'Content-Type': 'application/json'},
//       body: json.encode({'name': name, 'plate_number': plate, 'rfid_uid': rfid}),
//     );

//     return response.statusCode == 201;
//   }

  
//   // Exit user
//   static Future<bool> exitUser(String rfid) async {
//     try {
//       final response = await http.post(
//         Uri.parse('$apiUrl/api/users/exit'),
//         headers: {'Content-Type': 'application/json'},
//         body: json.encode({'rfid_uid': rfid}),
//       );
//       return response.statusCode == 200;
//     } catch (e) {
//       print('❌ Error exiting user: $e');
//       return false;
//     }
//   }


//   // WebSocket functionality for real-time RFID scanning
//   static WebSocketChannel? _channel;
//   static Function(String)? _onRFIDReceived;

//   // Start listening on the WebSocket for RFID messages
//   static void listenToWebSocket(Function(String) onRFIDReceived) {
//     _channel = IOWebSocketChannel.connect(Uri.parse(wsUrl));
//     print("🔗 Connecting to WebSocket: $wsUrl");

//     _channel!.stream.listen((data) {
//       print("📩 WebSocket Message Received: $data");

//       try {
//         final decodedMessage = jsonDecode(data);
//         if (decodedMessage['scanned_uid'] != null) {
//           String receivedRFID = decodedMessage['scanned_uid'];
//           print("🎯 Scanned RFID: $receivedRFID");
//           onRFIDReceived(receivedRFID);
//         }
//       } catch (e) {
//         print("❌ WebSocket JSON Error: $e");
//       }
//     }, onError: (error) {
//       print("❌ WebSocket Error: $error");
//     }, onDone: () {
//       print("🔴 WebSocket Closed");
//     });
//   }

//   // Close WebSocket when done
//   static void disposeWebSocket() {
//     if (_channel != null) {
//       _channel!.sink.close();
//       print("🔴 WebSocket Closed");
//     }
//   }
// }

// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'package:web_socket_channel/io.dart';
// import 'package:web_socket_channel/web_socket_channel.dart';

// class ApiService {
//   static final String apiUrl = "http://192.168.100.201:5000";
//   static const String wsEntranceUrl = "ws://192.168.100.201:3001/ws/entrance";
//   static const String wsExitUrl = "ws://192.168.100.201:3001/ws/exit";

//   // Fetch all users for the dashboard
//   static Future<List<dynamic>> fetchUsers() async {
//     final response = await http.get(Uri.parse("$apiUrl/api/users"));
//     if (response.statusCode == 200) {
//       return jsonDecode(response.body) as List<dynamic>;
//     } else {
//       throw Exception("Failed to load users");
//     }
//   }

//   // Login Function
//   Future<bool> login(String email, String password) async {
//     final response = await http.post(
//       Uri.parse("$apiUrl/login"),
//       headers: {"Content-Type": "application/json"},
//       body: jsonEncode({"email": email, "password": password}),
//     );
//     return response.statusCode == 200;
//   }

//   // Add user
//   static Future<bool> addUser(String name, String plate, String rfid) async {
//     if (rfid == "Waiting..." || rfid.isEmpty) {
//       print("⚠️ No valid RFID scanned.");
//       return false;
//     }

//     final response = await http.post(
//       Uri.parse('$apiUrl/api/users'),
//       headers: {'Content-Type': 'application/json'},
//       body: json.encode({'name': name, 'plate_number': plate, 'rfid_uid': rfid}),
//     );

//     return response.statusCode == 201;
//   }

//   // Exit user
//   static Future<bool> exitUser(String rfid) async {
//     try {
//       final response = await http.post(
//         Uri.parse('$apiUrl/api/users/exit'),
//         headers: {'Content-Type': 'application/json'},
//         body: json.encode({'rfid_uid': rfid}),
//       );
//       return response.statusCode == 200;
//     } catch (e) {
//       print('❌ Error exiting user: $e');
//       return false;
//     }
//   }

//   // WebSocket for Entrance Scans
//   static WebSocketChannel? _entranceChannel;
//   static Function(String)? _onEntranceRFIDReceived;

//   static void listenToEntranceWebSocket(Function(String) onRFIDReceived) {
//     _entranceChannel = IOWebSocketChannel.connect(Uri.parse(wsEntranceUrl));
//     print("🔗 Connecting to WebSocket (Entrance): $wsEntranceUrl");

//     _entranceChannel!.stream.listen((data) {
//       print("📩 WebSocket Message (Entrance) Received: $data");

//       try {
//         final decodedMessage = jsonDecode(data);
//         if (decodedMessage['scanned_uid'] != null) {
//           String receivedRFID = decodedMessage['scanned_uid'];
//           print("🎯 Scanned Entrance RFID: $receivedRFID");
//           onRFIDReceived(receivedRFID);
//         }
//       } catch (e) {
//         print("❌ WebSocket (Entrance) JSON Error: $e");
//       }
//     }, onError: (error) {
//       print("❌ WebSocket (Entrance) Error: $error");
//     }, onDone: () {
//       print("🔴 WebSocket (Entrance) Closed");
//     });
//   }

//   // WebSocket for Exit Scans
//   static WebSocketChannel? _exitChannel;
//   static Function(String)? _onExitRFIDReceived;

//   static void listenToExitWebSocket(Function(String) onRFIDReceived) {
//     _exitChannel = IOWebSocketChannel.connect(Uri.parse(wsExitUrl));
//     print("🔗 Connecting to WebSocket (Exit): $wsExitUrl");

//     _exitChannel!.stream.listen((data) {
//       print("📩 WebSocket Message (Exit) Received: $data");

//       try {
//         final decodedMessage = jsonDecode(data);
//         if (decodedMessage['scanned_uid'] != null) {
//           String receivedRFID = decodedMessage['scanned_uid'];
//           print("🎯 Scanned Exit RFID: $receivedRFID");
//           onRFIDReceived(receivedRFID);
//         }
//       } catch (e) {
//         print("❌ WebSocket (Exit) JSON Error: $e");
//       }
//     }, onError: (error) {
//       print("❌ WebSocket (Exit) Error: $error");
//     }, onDone: () {
//       print("🔴 WebSocket (Exit) Closed");
//     });
//   }

//   // Close WebSockets when done
//   static void disposeWebSockets() {
//     if (_entranceChannel != null) {
//       _entranceChannel!.sink.close();
//       print("🔴 WebSocket (Entrance) Closed");
//     }
//     if (_exitChannel != null) {
//       _exitChannel!.sink.close();
//       print("🔴 WebSocket (Exit) Closed");
//     }
//   }
// }




  // Fetch users from the database
  // Future<List<dynamic>> fetchUsers() async {
  //   final response = await http.get(Uri.parse("$apiUrl/users"));

  //   if (response.statusCode == 200) {
  //     return jsonDecode(response.body); // Returns list of users
  //   } else {
  //     throw Exception("Failed to load users");
  //   }
  // }

  


//   Future<bool> exitUser(String rfid) async {
//   final response = await http.post(
//     Uri.parse('$apiUrl/exit-user'),
//     body: jsonEncode({"rfid": rfid}),
//     headers: {"Content-Type": "application/json"},
//   );

//   return response.statusCode == 200;
//  }



// static Future<bool> addUser(String name, String plate, String uid) async {
//     final response = await http.post(
//       Uri.parse('$apiUrl/api/users/add'), // Now correctly accesses apiUrl
//       headers: {'Content-Type': 'application/json'},
//       body: jsonEncode({
//         'name': name,
//         'plate_number': plate,
//         'rfid_uid': uid,
//       }),
//     );

//     return response.statusCode == 200;
//   }



  // Add a new user (Entrance page)
  // static Future<bool> addUser(String name, String plate, String uid) async {
  //   final response = await http.post(
  //     Uri.parse('$apiUrl/api/users/add'),
  //     headers: {'Content-Type': 'application/json'},
  //     body: jsonEncode({
  //       'name': name,
  //       'plate_number': plate,
  //       'rfid_uid': uid,
  //     }),
  //   );
  //   return response.statusCode == 200;
  // }

//   Future<List<Map<String, dynamic>>> fetchUsers() async {
//   final response = await http.get(Uri.parse('$apiUrl/api/users'));

//   if (response.statusCode == 200) {
//     final List<dynamic> data = jsonDecode(response.body);
//     return data.cast<Map<String, dynamic>>();
//   } else {
//     throw Exception("Failed to load users");
//   }
//  }

// static Future<bool> exitUser(String uid) async {
//     final response = await http.post(
//       Uri.parse('$apiUrl/api/users/exit'), // Uses static apiUrl
//       headers: {'Content-Type': 'application/json'},
//       body: jsonEncode({'rfid_uid': uid}),
//     );

//     return response.statusCode == 200;
//   }

// Mark a user as exited (Exit page)
  // static Future<bool> exitUser(String uid) async {
  //   final response = await http.post(
  //     Uri.parse('$apiUrl/api/users/exit'),
  //     headers: {'Content-Type': 'application/json'},
  //     body: jsonEncode({'rfid_uid': uid}),
  //   );
  //   return response.statusCode == 200;
  // }



//   static const String webSocketUrl = 'ws://your-websocket-url'; // Replace with your WebSocket URL
//   static WebSocketChannel? _channel;

//   static void listenToWebSocket(Function(dynamic) onMessage) {
//     _channel = WebSocketChannel.connect(Uri.parse(webSocketUrl));

//     _channel!.stream.listen((message) {
//       onMessage(message);
//     });
//   }

//   static void disposeWebSocket() {
//     _channel?.sink.close();
// }


import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class ApiService {
  // Base URL for REST API and WebSockets
  static final String apiUrl = "http://192.168.100.96:5000";
  static const String wsEntranceUrl = "ws://192.168.100.96:3001/ws/entrance";
  static const String wsExitUrl = "ws://192.168.100.96:3001/ws/exit";

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
  _entranceChannel = IOWebSocketChannel.connect(Uri.parse(wsEntranceUrl));
  print("🔗 Connecting to WebSocket (Entrance): $wsEntranceUrl");

  _entranceChannel!.stream.listen((data) {
    print("📩 WebSocket (Entrance) Message Received: $data");

    try {
      final decoded = jsonDecode(data);

      if (decoded['scanned_uid'] != null) {
        final uid = decoded['scanned_uid'];
        onRFIDReceived(uid);
      } else if (decoded['update'] == 'reservation_activated') {
        print("🚀 Reservation moved to ACTIVE: ${decoded['rfid_uid']}");
        onRFIDReceived(decoded['rfid_uid']); // trigger refresh
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
    _exitChannel = IOWebSocketChannel.connect(Uri.parse(wsExitUrl));
    print("🔗 Connecting to WebSocket (Exit): $wsExitUrl");

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






