
// require("dotenv").config();
// const express = require("express");
// const expressWs = require("express-ws");
// const mysql = require("mysql2");
// const cors = require("cors");
// const bodyParser = require("body-parser");
// const WebSocket = require("ws");
// const moment = require('moment');

// const app = express();
// expressWs(app);

// const PORT = process.env.PORT || 5000;
// const WEBSOCKET_PORT = 3001;

// app.use(express.json());
// app.use(bodyParser.json());
// app.use(cors());

// const db = mysql.createConnection({
//   host: process.env.DB_HOST,
//   user: process.env.DB_USER,
//   password: process.env.DB_PASSWORD,
//   database: process.env.DB_NAME,
//   port: process.env.DB_PORT
// });


// db.connect((err) => {
//   if (err) {
//     console.error('❌ Database connection failed:', err);
//     return;
//   }
//   console.log('✅ Connected to MySQL database');
// });


// // WebSocket Server
// const wss = new WebSocket.Server({ port: WEBSOCKET_PORT }, () => {
//   console.log(`🔗 WebSocket Server running on ws://192.168.100.96:${WEBSOCKET_PORT}`);
// });

// // Broadcast message to all connected clients
// function broadcastToClients(message) {
//   const data = JSON.stringify(message);
//   wss.clients.forEach((client) => {
//     if (client.readyState === WebSocket.OPEN) {
//       client.send(data);
//     }
//   });
// }

// // WebSocket handling
// wss.on("connection", (ws) => {
//   console.log("🌐 New WebSocket Connection");

//   ws.on("message", (msg) => {
//     try {
//       const data = JSON.parse(msg);
//       const uid = data.scanned_uid;
//       const type = data.type;

//       if (!uid) {
//         console.log("⚠️ No UID received");
//         return;
//       }

//       if (type === "exit") {
//         processExitRFID(uid);
//       } else {
//         // Broadcast to all (entrance and reservation included)
//         broadcastToClients({ scanned_uid: uid });
//       }
//     } catch (err) {
//       console.error("❌ WebSocket error:", err);
//     }
//   });

//   ws.on("close", () => {
//     console.log("🔌 WebSocket Disconnected");
//   });
// });

// // Process Exit
// function processExitRFID(rfid_uid) {
//   const checkQuery = "SELECT * FROM users WHERE rfid_uid = ? AND status = 'ACTIVE'";
//   db.query(checkQuery, [rfid_uid], (err, result) => {
//     if (err) {
//       console.error("❌ DB error:", err);
//       return;
//     }

//     if (result.length === 0) {
//       console.log("⚠️ UID not found or already exited.");
//       return;
//     }

//     const updateQuery = "UPDATE users SET status = 'INACTIVE', time_out = NOW() WHERE rfid_uid = ?";
//     db.query(updateQuery, [rfid_uid], (err2) => {
//       if (err2) {
//         console.error("❌ Exit update error:", err2);
//         return;
//       }

//       console.log(`✅ RFID ${rfid_uid} marked as INACTIVE`);
//       broadcastToClients({ update: "user_exited", rfid_uid });
//     });
//   });
// }

// // Login
// app.post("/login", (req, res) => {
//   const { email, password } = req.body;
//   const query = "SELECT * FROM admins WHERE email = ? AND password = ?";
//   db.query(query, [email, password], (err, result) => {
//     if (err) return res.status(500).json({ success: false });
//     if (result.length > 0) {
//       res.json({ success: true, admin: result[0] });
//     } else {
//       res.status(401).json({ success: false });
//     }
//   });
// });

// // Add User (Entrance)
// app.post("/api/users", (req, res) => {
//   const { name, plate_number, rfid_uid } = req.body;

//   if (!name || !plate_number || !rfid_uid) {
//     return res.status(400).json({ message: "Missing required fields" });
//   }

//   const checkQuery = "SELECT * FROM users WHERE rfid_uid = ? AND status = 'ACTIVE'";
//   db.query(checkQuery, [rfid_uid], (err, results) => {
//     if (err) {
//       console.error("❌ Error checking UID:", err);
//       return res.status(500).json({ message: "Database error" });
//     }

//     if (results.length > 0) {
//       return res.status(409).json({ message: "RFID is currently in use by an ACTIVE user." });
//     }

//     const insertQuery = `
//       INSERT INTO users (name, plate_number, rfid_uid, time_in, status)
//       VALUES (?, ?, ?, NOW(), 'ACTIVE')
//     `;

//     db.query(insertQuery, [name, plate_number, rfid_uid], (err2) => {
//       if (err2) {
//         console.error("❌ Insert user failed:", err2);
//         return res.status(500).json({ message: "Insert failed" });
//       }

//       console.log(`✅ Added user ${name} with RFID ${rfid_uid}`);
//       broadcastToClients({ update: "new_user_added", name, plate_number, rfid_uid });

//       res.status(201).json({ message: "User added successfully" });
//     });
//   });
// });

// // Get all ACTIVE users
// app.get("/api/users", (req, res) => {
//   const query = "SELECT * FROM users WHERE status = 'ACTIVE' ORDER BY time_in DESC";
//   db.query(query, (err, results) => {
//     if (err) return res.status(500).json({ error: "Database error" });
//     res.status(200).json(results);
//   });
// });

// // Get INACTIVE users (for exit dashboard)
// app.get("/api/users/inactive", (req, res) => {
//   const query = "SELECT * FROM users WHERE status = 'INACTIVE' ORDER BY time_out DESC";
//   db.query(query, (err, results) => {
//     if (err) return res.status(500).json({ error: "Database error" });
//     res.status(200).json(results);
//   });
// });

// // Manual exit endpoint
// app.post("/api/users/exit", (req, res) => {
//   const { rfid_uid } = req.body;
//   if (!rfid_uid) return res.status(400).json({ error: "Missing RFID UID" });

//   processExitRFID(rfid_uid);
//   res.status(200).json({ message: "Exit processed" });
// });

// // Add Reservation
// app.post("/api/reservations", (req, res) => {
//   const { name, plate_number, rfid_uid, expected_time_in } = req.body;

//   if (!name || !plate_number || !rfid_uid || !expected_time_in) {
//     return res.status(400).json({ error: "Missing reservation fields" });
//   }

//   const insertQuery = `
//   INSERT INTO reservation (name, plate_number, rfid_uid, expected_time_in)
//   VALUES (?, ?, ?, ?)
// `;

//   db.query(insertQuery, [name, plate_number, rfid_uid, expected_time_in], (err, result) => {
//     if (err) {
//       console.error("❌ Reservation error:", err);
//       return res.status(500).json({ error: "Failed to add reservation" });
//     }

//     console.log(`📌 Reservation for ${name} added`);
//     res.status(201).json({ message: "Reservation added" });
//   });
// });

// // 📥 Get all Reservations
// app.get("/api/reservations", (req, res) => {
//   const query = "SELECT * FROM reservation ORDER BY expected_time_in DESC";
//   db.query(query, (err, results) => {
//     if (err) {
//       console.error("❌ Error fetching reservations:", err);
//       return res.status(500).json({ error: "Database error" });
//     }
//     res.status(200).json(results);
//   });
// });


// setInterval(() => {
//   const query = `SELECT * FROM reservation WHERE expected_time_in <= NOW()`;

//   db.query(query, (err, results) => {
//     if (err) {
//       console.error("❌ Error checking reservations:", err);
//       return;
//     }

//     results.forEach((reservation) => {
//       const { name, plate_number, rfid_uid, expected_time_in } = reservation;

//       // First, check if the RFID is already active (just in case)
//       const checkUser = "SELECT * FROM users WHERE rfid_uid = ? AND status = 'ACTIVE'";
//       db.query(checkUser, [rfid_uid], (err2, existing) => {
//         if (err2) {
//           console.error("❌ Error checking active users before reservation transfer:", err2);
//           return;
//         }

//         if (existing.length === 0) {
//           // No active user with that RFID, so transfer to users table
//           const insertUser = `
//             INSERT INTO users (name, plate_number, rfid_uid, time_in, status)
//             VALUES (?, ?, ?, NOW(), 'ACTIVE')
//           `;
//           db.query(insertUser, [name, plate_number, rfid_uid], (err3) => {
//             if (err3) {
//               console.error("❌ Error inserting reservation into users:", err3);
//               return;
//             }

//             // Now delete the reservation
//             const deleteReservation = `DELETE FROM reservation WHERE rfid_uid = ?`;
//             db.query(deleteReservation, [rfid_uid], (err4) => {
//               if (err4) {
//                 console.error("❌ Error deleting reservation:", err4);
//               } else {
//                 console.log(`✅ Reservation for ${name} transferred to ACTIVE users.`);
//                 broadcastToClients({ update: "reservation_transferred", rfid_uid });
//               }
//             });
//           });
//         }
//       });
//     });
//   });
// }, 30000); // Runs every 30 seconds


// // 🔄 Periodically check for due reservations and move them to users
// setInterval(() => {
//   const now = new Date();
//   const formattedNow = now.toISOString().slice(0, 19).replace("T", " ");

//   const fetchDueQuery = `SELECT * FROM reservation WHERE expected_time_in <= ?`;

//   db.query(fetchDueQuery, [formattedNow], (err, results) => {
//     if (err) {
//       console.error("❌ Error fetching due reservations:", err);
//       return;
//     }

//     results.forEach((resv) => {
//       const { name, plate_number, rfid_uid, expected_time_in } = resv;

//       // Prevent duplicate ACTIVE users
//       const checkQuery = "SELECT * FROM users WHERE rfid_uid = ? AND status = 'ACTIVE'";
//       db.query(checkQuery, [rfid_uid], (checkErr, checkResult) => {
//         if (checkErr || checkResult.length > 0) return;

//         const insertQuery = `
//           INSERT INTO users (name, plate_number, rfid_uid, time_in, status)
//           VALUES (?, ?, ?, ?, 'ACTIVE')
//         `;
//         db.query(insertQuery, [name, plate_number, rfid_uid, expected_time_in], (insertErr) => {
//           if (insertErr) return;

//           // Delete reservation after transfer
//           db.query("DELETE FROM reservation WHERE rfid_uid = ?", [rfid_uid]);

//           console.log(`🔄 Reservation for ${name} transferred to active users`);

//           // Notify WebSocket clients (Dashboard)
//           broadcastToClients({ update: "reservation_activated", rfid_uid });
//         });
//       });
//     });
//   });
// }, 5000); // Check every 5 seconds


// // ⚠️ Make sure this line remains LAST in your server.js
// app.listen(PORT, () => {
//   console.log(`🚀 Express server running at  http://localhost:${PORT}`);
// });

// require("dotenv").config();
// const express = require("express");
// const expressWs = require("express-ws");
// const mysql = require("mysql2");
// const cors = require("cors");
// const bodyParser = require("body-parser");
// const WebSocket = require("ws");
// const moment = require("moment");

// const app = express();
// expressWs(app);

// const PORT = process.env.PORT || 5000;

// app.use(express.json());
// app.use(bodyParser.json());
// app.use(cors());

// // MySQL Connection
// const db = mysql.createConnection({
//   host: process.env.DB_HOST,
//   user: process.env.DB_USER,
//   password: process.env.DB_PASSWORD,
//   database: process.env.DB_NAME,
//   port: process.env.DB_PORT,
// });

// db.connect((err) => {
//   if (err) {
//     console.error("❌ Database connection failed:", err);
//     return;
//   }
//   console.log("✅ Connected to MySQL database");
// });

// // Start Express HTTP Server
// const server = app.listen(PORT, () => {
//   console.log(`🚀 Express server running at http://localhost:${PORT}`);
// });

// // Attach WebSocket to same server (Render-safe)
// const wss = new WebSocket.Server({ server }, () => {
//   console.log(`📡 WebSocket Server running on ws://localhost:${PORT}/ws`);
// });

// // Broadcast to all connected WebSocket clients
// function broadcastToClients(message) {
//   const data = JSON.stringify(message);
//   wss.clients.forEach((client) => {
//     if (client.readyState === WebSocket.OPEN) {
//       client.send(data);
//     }
//   });
// }

// // Handle WebSocket connections
// wss.on("connection", (ws) => {
//   console.log("🌐 New WebSocket Connection");

//   ws.on("message", (msg) => {
//     try {
//       const data = JSON.parse(msg);
//       const uid = data.scanned_uid;
//       const type = data.type;

//       if (!uid) {
//         console.log("⚠️ No UID received");
//         return;
//       }

//       if (type === "exit") {
//         processExitRFID(uid);
//       } else {
//         broadcastToClients({ scanned_uid: uid });
//       }
//     } catch (err) {
//       console.error("❌ WebSocket error:", err);
//     }
//   });

//   ws.on("close", () => {
//     console.log("🔌 WebSocket Disconnected");
//   });
// });

// // Helper: Process exit logic
// function processExitRFID(rfid_uid) {
//   const checkQuery =
//     "SELECT * FROM users WHERE rfid_uid = ? AND status = 'ACTIVE'";
//   db.query(checkQuery, [rfid_uid], (err, result) => {
//     if (err) {
//       console.error("❌ DB error:", err);
//       return;
//     }

//     if (result.length === 0) {
//       console.log("⚠️ UID not found or already exited.");
//       return;
//     }

//     const updateQuery =
//       "UPDATE users SET status = 'INACTIVE', time_out = NOW() WHERE rfid_uid = ?";
//     db.query(updateQuery, [rfid_uid], (err2) => {
//       if (err2) {
//         console.error("❌ Exit update error:", err2);
//         return;
//       }

//       console.log(`✅ RFID ${rfid_uid} marked as INACTIVE`);
//       broadcastToClients({ update: "user_exited", rfid_uid });
//     });
//   });
// }

// // --- API Routes ---

// // Admin Login
// app.post("/login", (req, res) => {
//   const { email, password } = req.body;
//   const query = "SELECT * FROM admins WHERE email = ? AND password = ?";
//   db.query(query, [email, password], (err, result) => {
//     if (err) return res.status(500).json({ success: false });
//     if (result.length > 0) {
//       res.json({ success: true, admin: result[0] });
//     } else {
//       res.status(401).json({ success: false });
//     }
//   });
// });

// // Add User (Entrance)
// app.post("/api/users", (req, res) => {
//   const { name, plate_number, rfid_uid } = req.body;
//   if (!name || !plate_number || !rfid_uid) {
//     return res.status(400).json({ message: "Missing required fields" });
//   }

//   const checkQuery =
//     "SELECT * FROM users WHERE rfid_uid = ? AND status = 'ACTIVE'";
//   db.query(checkQuery, [rfid_uid], (err, results) => {
//     if (err) {
//       console.error("❌ Error checking UID:", err);
//       return res.status(500).json({ message: "Database error" });
//     }

//     if (results.length > 0) {
//       return res
//         .status(409)
//         .json({ message: "RFID is currently in use by an ACTIVE user." });
//     }

//     const insertQuery = `
//       INSERT INTO users (name, plate_number, rfid_uid, time_in, status)
//       VALUES (?, ?, ?, NOW(), 'ACTIVE')
//     `;

//     db.query(insertQuery, [name, plate_number, rfid_uid], (err2) => {
//       if (err2) {
//         console.error("❌ Insert user failed:", err2);
//         return res.status(500).json({ message: "Insert failed" });
//       }

//       console.log(`✅ Added user ${name} with RFID ${rfid_uid}`);
//       broadcastToClients({
//         update: "new_user_added",
//         name,
//         plate_number,
//         rfid_uid,
//       });

//       res.status(201).json({ message: "User added successfully" });
//     });
//   });
// });

// // Get ACTIVE Users
// app.get("/api/users", (req, res) => {
//   const query =
//     "SELECT * FROM users WHERE status = 'ACTIVE' ORDER BY time_in DESC";
//   db.query(query, (err, results) => {
//     if (err) return res.status(500).json({ error: "Database error" });
//     res.status(200).json(results);
//   });
// });

// // Get INACTIVE Users
// app.get("/api/users/inactive", (req, res) => {
//   const query =
//     "SELECT * FROM users WHERE status = 'INACTIVE' ORDER BY time_out DESC";
//   db.query(query, (err, results) => {
//     if (err) return res.status(500).json({ error: "Database error" });
//     res.status(200).json(results);
//   });
// });

// // Manual Exit
// app.post("/api/users/exit", (req, res) => {
//   const { rfid_uid } = req.body;
//   if (!rfid_uid) return res.status(400).json({ error: "Missing RFID UID" });

//   processExitRFID(rfid_uid);
//   res.status(200).json({ message: "Exit processed" });
// });

// // Add Reservation
// app.post("/api/reservations", (req, res) => {
//   const { name, plate_number, rfid_uid, expected_time_in } = req.body;
//   if (!name || !plate_number || !rfid_uid || !expected_time_in) {
//     return res.status(400).json({ error: "Missing reservation fields" });
//   }

//   const insertQuery = `
//     INSERT INTO reservation (name, plate_number, rfid_uid, expected_time_in)
//     VALUES (?, ?, ?, ?)
//   `;

//   db.query(
//     insertQuery,
//     [name, plate_number, rfid_uid, expected_time_in],
//     (err) => {
//       if (err) {
//         console.error("❌ Reservation error:", err);
//         return res.status(500).json({ error: "Failed to add reservation" });
//       }

//       console.log(`📌 Reservation for ${name} added`);
//       res.status(201).json({ message: "Reservation added" });
//     }
//   );
// });

// // Get All Reservations
// app.get("/api/reservations", (req, res) => {
//   const query = "SELECT * FROM reservation ORDER BY expected_time_in DESC";
//   db.query(query, (err, results) => {
//     if (err) {
//       console.error("❌ Error fetching reservations:", err);
//       return res.status(500).json({ error: "Database error" });
//     }
//     res.status(200).json(results);
//   });
// });

// // Reservation Activation Loop (5s)
// setInterval(() => {
//   const now = new Date();
//   const formattedNow = now.toISOString().slice(0, 19).replace("T", " ");
//   const fetchDueQuery =
//     "SELECT * FROM reservation WHERE expected_time_in <= ?";

//   db.query(fetchDueQuery, [formattedNow], (err, results) => {
//     if (err) {
//       console.error("❌ Error fetching due reservations:", err);
//       return;
//     }

//     results.forEach((resv) => {
//       const { name, plate_number, rfid_uid, expected_time_in } = resv;

//       const checkQuery =
//         "SELECT * FROM users WHERE rfid_uid = ? AND status = 'ACTIVE'";
//       db.query(checkQuery, [rfid_uid], (checkErr, checkResult) => {
//         if (checkErr || checkResult.length > 0) return;

//         const insertQuery = `
//           INSERT INTO users (name, plate_number, rfid_uid, time_in, status)
//           VALUES (?, ?, ?, ?, 'ACTIVE')
//         `;
//         db.query(
//           insertQuery,
//           [name, plate_number, rfid_uid, expected_time_in],
//           (insertErr) => {
//             if (insertErr) return;

//             db.query(
//               "DELETE FROM reservation WHERE rfid_uid = ?",
//               [rfid_uid]
//             );

//             console.log(`🔄 Reservation for ${name} transferred to active users`);
//             broadcastToClients({
//               update: "reservation_activated",
//               rfid_uid,
//             });
//           }
//         );
//       });
//     });
//   });
// }, 5000);


require("dotenv").config();
const express = require("express");
const expressWs = require("express-ws");
const mysql = require("mysql2");
const cors = require("cors");
const bodyParser = require("body-parser");
const WebSocket = require("ws");
const moment = require("moment");

const app = express();
const expressWsInstance = expressWs(app);

const PORT = process.env.PORT || 5000;

app.use(express.json());
app.use(bodyParser.json());
app.use(cors());

// ====== MySQL Connection ======
const db = mysql.createConnection({
  host: process.env.DB_HOST,
  user: process.env.DB_USER,
  password: process.env.DB_PASSWORD,
  database: process.env.DB_NAME,
  port: process.env.DB_PORT,
});

db.connect((err) => {
  if (err) {
    console.error("❌ Database connection failed:", err);
    return;
  }
  console.log("✅ Connected to MySQL database");
});

// ====== Start Server ======
const server = app.listen(PORT, () => {
  console.log(`🚀 Express server running at http://localhost:${PORT}`);
});

// ====== WebSocket Setup (/ws for both entrance & exit) ======
function broadcastToClients(message) {
  const data = JSON.stringify(message);
  expressWsInstance.getWss().clients.forEach((client) => {
    if (client.readyState === WebSocket.OPEN) {
      client.send(data);
    }
  });
}

// ======== ✅ WebSocket: Unified /ws route ========
app.ws("/ws", (ws, req) => {
  console.log("🔓 WebSocket connected: /ws");

  ws.on("message", (msg) => {
    try {
      const data = JSON.parse(msg);
      const uid = data.scanned_uid;
      const type = (data.type || "").toUpperCase();

      if (!uid || !type) return;

      if (type === "EXIT_SCAN") {
        console.log(`📥 EXIT_SCAN UID: ${uid}`);
        broadcastToClients({ scanned_uid: uid, type: "EXIT_SCAN" }); // Just broadcast, no DB update
      } else if (type === "ENTRANCE") {
        console.log(`📥 ENTRANCE UID: ${uid}`);
        broadcastToClients({ scanned_uid: uid, type: "ENTRANCE" });
      } else {
        console.warn(`⚠️ Unknown WebSocket type: ${type}`);
      }
    } catch (err) {
      console.error("❌ WebSocket Error:", err);
    }
  });

  ws.on("close", () => {
    console.log("🔌 WebSocket Disconnected: /ws");
  });
});

// ====== Process Exit ======
function processExitRFID(rfid_uid) {
  const checkQuery =
    "SELECT * FROM users WHERE rfid_uid = ? AND status = 'ACTIVE'";
  db.query(checkQuery, [rfid_uid], (err, result) => {
    if (err) return console.error("❌ DB error:", err);
    if (result.length === 0) {
      console.log("⚠️ UID not found or already exited.");
      return;
    }

    const updateQuery =
      "UPDATE users SET status = 'INACTIVE', time_out = NOW() WHERE rfid_uid = ?";
    db.query(updateQuery, [rfid_uid], (err2) => {
      if (err2) return console.error("❌ Exit update error:", err2);
      console.log(`✅ RFID ${rfid_uid} marked as INACTIVE`);
      broadcastToClients({ update: "user_exited", rfid_uid });
    });
  });
}

// ========== API Routes ==========

app.post("/login", (req, res) => {
  const { email, password } = req.body;
  const query = "SELECT * FROM admins WHERE email = ? AND password = ?";
  db.query(query, [email, password], (err, result) => {
    if (err) return res.status(500).json({ success: false });
    if (result.length > 0) {
      res.json({ success: true, admin: result[0] });
    } else {
      res.status(401).json({ success: false });
    }
  });
});

app.post("/api/users", (req, res) => {
  const { name, plate_number, rfid_uid } = req.body;
  if (!name || !plate_number || !rfid_uid) {
    return res.status(400).json({ message: "Missing required fields" });
  }

  const checkQuery =
    "SELECT * FROM users WHERE rfid_uid = ? AND status = 'ACTIVE'";
  db.query(checkQuery, [rfid_uid], (err, results) => {
    if (err) return res.status(500).json({ message: "Database error" });

    if (results.length > 0) {
      return res
        .status(409)
        .json({ message: "RFID is currently in use by an ACTIVE user." });
    }

    const insertQuery = `
      INSERT INTO users (name, plate_number, rfid_uid, time_in, status)
      VALUES (?, ?, ?, NOW(), 'ACTIVE')
    `;
    db.query(insertQuery, [name, plate_number, rfid_uid], (err2) => {
      if (err2) return res.status(500).json({ message: "Insert failed" });

      console.log(`✅ Added user ${name} with RFID ${rfid_uid}`);
      broadcastToClients({
        update: "new_user_added",
        name,
        plate_number,
        rfid_uid,
      });
      res.status(201).json({ message: "User added successfully" });
    });
  });
});

app.get("/api/users", (req, res) => {
  const query =
    "SELECT * FROM users WHERE status = 'ACTIVE' ORDER BY time_in DESC";
  db.query(query, (err, results) => {
    if (err) return res.status(500).json({ error: "Database error" });
    res.status(200).json(results);
  });
});

app.get("/api/users/inactive", (req, res) => {
  const query =
    "SELECT * FROM users WHERE status = 'INACTIVE' ORDER BY time_out DESC";
  db.query(query, (err, results) => {
    if (err) return res.status(500).json({ error: "Database error" });
    res.status(200).json(results);
  });
});

app.post("/api/users/exit", (req, res) => {
  const { rfid_uid } = req.body;
  if (!rfid_uid) return res.status(400).json({ error: "Missing RFID UID" });

  processExitRFID(rfid_uid);
  res.status(200).json({ message: "Exit processed" });
});

app.post("/api/reservations", (req, res) => {
  const { name, plate_number, rfid_uid, expected_time_in } = req.body;
  if (!name || !plate_number || !rfid_uid || !expected_time_in) {
    return res.status(400).json({ error: "Missing reservation fields" });
  }

  const insertQuery = `
    INSERT INTO reservation (name, plate_number, rfid_uid, expected_time_in)
    VALUES (?, ?, ?, ?)
  `;

  db.query(
    insertQuery,
    [name, plate_number, rfid_uid, expected_time_in],
    (err) => {
      if (err) return res.status(500).json({ error: "Failed to add reservation" });

      console.log(`📌 Reservation for ${name} added`);
      res.status(201).json({ message: "Reservation added" });
    }
  );
});
app.get("/api/reservations", (req, res) => {
  const query = "SELECT * FROM reservation ORDER BY expected_time_in DESC";
  db.query(query, (err, results) => {
    if (err) return res.status(500).json({ error: "Database error" });
    res.status(200).json(results);
  });
});

app.get("/api/users/:rfid_uid", (req, res) => {
  const { rfid_uid } = req.params;
  const query = `
    SELECT * FROM users
    WHERE rfid_uid = ? 
    ORDER BY time_in DESC LIMIT 1
  `;
  db.query(query, [rfid_uid], (err, results) => {
    if (err) return res.status(500).json({ error: "Database error" });
    if (results.length === 0) return res.status(404).json({ error: "No active user found" });
    res.status(200).json(results[0]);
  });
});





// ======= Reservation Auto Activation =======
setInterval(() => {
  const now = new Date();
  const formattedNow = now.toISOString().slice(0, 19).replace("T", " ");
  const fetchDueQuery =
    "SELECT * FROM reservation WHERE expected_time_in <= ?";

  db.query(fetchDueQuery, [formattedNow], (err, results) => {
    if (err) return;

    results.forEach((resv) => {
      const { name, plate_number, rfid_uid, expected_time_in } = resv;

      // Make sure the user doesn't already exist as ACTIVE or INACTIVE
      const checkQuery = "SELECT * FROM users WHERE rfid_uid = ?";
      db.query(checkQuery, [rfid_uid], (checkErr, checkResult) => {
        if (checkErr || checkResult.length > 0) return;  // Do nothing if UID exists

        

        const insertQuery = `
          INSERT INTO users (name, plate_number, rfid_uid, time_in, status)
          VALUES (?, ?, ?, ?, 'ACTIVE')
        `;
        db.query(
          insertQuery,
          [name, plate_number, rfid_uid, expected_time_in],
          (insertErr) => {
            if (insertErr) return;

            db.query("DELETE FROM reservation WHERE rfid_uid = ?", [rfid_uid]);

            console.log(`🔄 Reservation for ${name} activated`);
            broadcastToClients({
              update: "reservation_activated",
              rfid_uid,
            });
          }
        );
      });
    });
  });
}, 5000);
