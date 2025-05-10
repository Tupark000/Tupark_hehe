
// require("dotenv").config();
// const express = require("express");
// const expressWs = require("express-ws");
// const mysql = require("mysql2");
// const cors = require("cors");
// const bodyParser = require("body-parser");
// const WebSocket = require("ws");
// const moment = require("moment");

// const app = express();
// const expressWsInstance = expressWs(app);

// const PORT = process.env.PORT || 5000;

// app.use(express.json());
// app.use(bodyParser.json());
// app.use(cors());

// // ====== MySQL Connection ======
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

// // ====== Start Server ======
// const server = app.listen(PORT, () => {
//   console.log(`🚀 Express server running at http://localhost:${PORT}`);
// });

// // ====== WebSocket Setup (/ws for both entrance & exit) ======
// function broadcastToClients(message) {
//   const data = JSON.stringify(message);
//   expressWsInstance.getWss().clients.forEach((client) => {
//     if (client.readyState === WebSocket.OPEN) {
//       client.send(data);
//     }
//   });
// }

// // ======== ✅ WebSocket: Unified /ws route ========
// app.ws("/ws", (ws, req) => {
//   console.log("🔓 WebSocket connected: /ws");

//   ws.on("message", (msg) => {
//     try {
//       const data = JSON.parse(msg);
//       const uid = data.scanned_uid;
//       const type = (data.type || "").toUpperCase();

//       if (!uid || !type) return;

//       if (type === "EXIT_SCAN") {
//         console.log(`📥 EXIT_SCAN UID: ${uid}`);
//         broadcastToClients({ scanned_uid: uid, type: "EXIT_SCAN" }); // Just broadcast, no DB update
//       } else if (type === "ENTRANCE") {
//         console.log(`📥 ENTRANCE UID: ${uid}`);
//         broadcastToClients({ scanned_uid: uid, type: "ENTRANCE" });
//       } else {
//         console.warn(`⚠️ Unknown WebSocket type: ${type}`);
//       }
//     } catch (err) {
//       console.error("❌ WebSocket Error:", err);
//     }
//   });

//   ws.on("close", () => {
//     console.log("🔌 WebSocket Disconnected: /ws");
//   });
// });

// // ====== Process Exit ======
// function processExitRFID(rfid_uid) {
//   const checkQuery = `
//     SELECT * FROM users 
//     WHERE rfid_uid = ? AND status = 'ACTIVE' 
//     ORDER BY time_in DESC LIMIT 1
//   `;

//   db.query(checkQuery, [rfid_uid], (err, result) => {
//     if (err) return console.error("❌ DB error:", err);
//     if (result.length === 0) {
//       console.log("⚠️ No ACTIVE record found for RFID:", rfid_uid);
//       return;
//     }

//     const userId = result[0].id; // assuming you have an `id` column as a unique primary key
//     const updateQuery = `
//       UPDATE users SET status = 'INACTIVE', time_out = NOW()
//       WHERE id = ?
//     `;

//     db.query(updateQuery, [userId], (err2) => {
//       if (err2) return console.error("❌ Exit update error:", err2);
//       console.log(`✅ RFID ${rfid_uid} (user ID ${userId}) marked as INACTIVE`);
//       broadcastToClients({ update: "user_exited", rfid_uid });
//     });
//   });
// }


// // ========== API Routes ==========

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

// app.post("/api/users", (req, res) => {
//   const { name, plate_number, rfid_uid, vehicle_type } = req.body;
//   if (!name || !plate_number || !rfid_uid) {
//     return res.status(400).json({ message: "Missing required fields" });
//   }

//   const checkQuery =
//     "SELECT * FROM users WHERE rfid_uid = ? AND status = 'ACTIVE'";
//   db.query(checkQuery, [rfid_uid], (err, results) => {
//     if (err) return res.status(500).json({ message: "Database error" });

//     if (results.length > 0) {
//       return res
//         .status(409)
//         .json({ message: "RFID is currently in use by an ACTIVE user." });
//     }

//     const insertQuery = `
//     INSERT INTO users (name, plate_number, rfid_uid, vehicle_type, time_in, status)
//     VALUES (?, ?, ?, ?, NOW(), 'ACTIVE')
//   `;
//   db.query(insertQuery, [name, plate_number, rfid_uid, vehicle_type], (err2) => {

//       if (err2) return res.status(500).json({ message: "Insert failed" });

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

// app.get("/api/users", (req, res) => {
//   const query =
//     "SELECT * FROM users WHERE status = 'ACTIVE' ORDER BY time_in DESC";
//   db.query(query, (err, results) => {
//     if (err) return res.status(500).json({ error: "Database error" });
//     res.status(200).json(results);
//   });
// });

// app.get("/api/users/inactive", (req, res) => {
//   const query =
//     "SELECT * FROM users WHERE status = 'INACTIVE' ORDER BY time_out DESC";
//   db.query(query, (err, results) => {
//     if (err) return res.status(500).json({ error: "Database error" });
//     res.status(200).json(results);
//   });
// });

// app.post("/api/users/exit", (req, res) => {
//   const { rfid_uid } = req.body;
//   if (!rfid_uid) return res.status(400).json({ error: "Missing RFID UID" });

//   processExitRFID(rfid_uid);
//   res.status(200).json({ message: "Exit processed" });
// });

// app.post("/api/reservations", (req, res) => {
//   const { name, plate_number, rfid_uid, vehicle_type, expected_time_in } = req.body;
//   if (!name || !plate_number || !rfid_uid || !vehicle_type || !expected_time_in) {
//     return res.status(400).json({ error: "Missing reservation fields" });
//   }

//     const insertQuery = `
//     INSERT INTO reservation (name, plate_number, rfid_uid, vehicle_type, expected_time_in)
//     VALUES (?, ?, ?, ?, ?)
//   `;

//   db.query(
//     insertQuery,
//     [name, plate_number, rfid_uid, vehicle_type, expected_time_in],
//     (err) => {
//       if (err) return res.status(500).json({ error: "Failed to add reservation" });

//       console.log(`📌 Reservation for ${name} added`);
//       res.status(201).json({ message: "Reservation added" });
//     }
//   );
// });

// app.get("/api/reservations", (req, res) => {
//   const query = "SELECT * FROM reservation ORDER BY expected_time_in DESC";
//   db.query(query, (err, results) => {
//     if (err) return res.status(500).json({ error: "Database error" });
//     res.status(200).json(results);
//   });
// });

// app.get("/api/users/:rfid_uid", (req, res) => {
//   const { rfid_uid } = req.params;
//   const query = ` 
//     SELECT * FROM users
//     WHERE rfid_uid = ? 
//     ORDER BY time_in DESC LIMIT 1
//   `;
//   db.query(query, [rfid_uid], (err, results) => {
//     if (err) return res.status(500).json({ error: "Database error" });
//     if (results.length === 0) return res.status(404).json({ error: "No active user found" });
//     res.status(200).json(results[0]);
//   });
// });


// // ======= Reservation Auto Activation =======
// setInterval(() => {
//   const now = new Date();
//   const formattedNow = now.toISOString().slice(0, 19).replace("T", " ");
//   const fetchDueQuery =
//     "SELECT * FROM reservation WHERE expected_time_in <= ?";

//   db.query(fetchDueQuery, [formattedNow], (err, results) => {
//     if (err) return;

//     results.forEach((resv) => {
//       const { name, plate_number, rfid_uid, expected_time_in, vehicle_type } = resv;

//       // Make sure the user doesn't already exist as ACTIVE or INACTIVE
//       const checkQuery = "SELECT * FROM users WHERE rfid_uid = ?";
//       db.query(checkQuery, [rfid_uid], (checkErr, checkResult) => {
//         if (checkErr || checkResult.length > 0) return;  // Do nothing if UID exists


//         const insertQuery = `
//           INSERT INTO users (name, plate_number, rfid_uid, vehicle_type, time_in, status)
//           VALUES (?, ?, ?, ?, ?, 'ACTIVE')
//         `;
//         db.query(
//           insertQuery,
//           [name, plate_number, rfid_uid, vehicle_type, expected_time_in],
//           (insertErr) => {
//             if (insertErr) return;

//             db.query("DELETE FROM reservation WHERE rfid_uid = ?", [rfid_uid]);

//             console.log(`🔄 Reservation for ${name} activated`);
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
const moment = require("moment-timezone");

const app = express();
const expressWsInstance = expressWs(app);
const PORT = process.env.PORT || 5000;

app.use(express.json());
app.use(bodyParser.json());
app.use(cors());

// ====== MySQL Connection ======
// const db = mysql.createConnection({
//   host: process.env.DB_HOST,
//   user: process.env.DB_USER,
//   password: process.env.DB_PASSWORD,
//   database: process.env.DB_NAME,
//   port: process.env.DB_PORT,
// });

const db = mysql.createPool({
  host: process.env.DB_HOST,
  user: process.env.DB_USER,
  password: process.env.DB_PASSWORD,
  database: process.env.DB_NAME,
  port: process.env.DB_PORT,
  waitForConnections: true,
  connectionLimit: 10,
  queueLimit: 0
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
        broadcastToClients({ scanned_uid: uid, type: "EXIT_SCAN" });
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
  const checkQuery = `
    SELECT * FROM users 
    WHERE rfid_uid = ? AND status = 'ACTIVE' 
    ORDER BY time_in DESC LIMIT 1
  `;

  db.query(checkQuery, [rfid_uid], (err, result) => {
    if (err) return console.error("❌ DB error:", err);
    if (result.length === 0) {
      console.log("⚠️ No ACTIVE record found for RFID:", rfid_uid);
      return;
    }

    const userId = result[0].id;
    const updateQuery = `
      UPDATE users SET status = 'INACTIVE', time_out = ? 
      WHERE id = ?
    `;
    const timeOut = moment().tz("Asia/Manila").format("YYYY-MM-DD HH:mm:ss");

    db.query(updateQuery, [timeOut, userId], (err2) => {
      if (err2) return console.error("❌ Exit update error:", err2);
      console.log(`✅ RFID ${rfid_uid} (user ID ${userId}) marked as INACTIVE`);
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
  const { name, plate_number, rfid_uid, vehicle_type } = req.body;
  if (!name || !plate_number || !rfid_uid || !vehicle_type) {
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
      INSERT INTO users (name, plate_number, rfid_uid, vehicle_type, time_in, status)
      VALUES (?, ?, ?, ?, ?, 'ACTIVE')
    `;
    const timeIn = moment().tz("Asia/Manila").format("YYYY-MM-DD HH:mm:ss");

    db.query(insertQuery, [name, plate_number, rfid_uid, vehicle_type, timeIn], (err2) => {
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

// app.post("/api/reservations", (req, res) => {
//   const { name, plate_number, rfid_uid, vehicle_type, expected_time_in } = req.body;
//   if (!name || !plate_number || !rfid_uid || !vehicle_type || !expected_time_in) {
//     return res.status(400).json({ error: "Missing reservation fields" });
//   }

//   const insertQuery = `
//     INSERT INTO reservation (name, plate_number, rfid_uid, vehicle_type, expected_time_in)
//     VALUES (?, ?, ?, ?, ?)
//   `;

//   db.query(insertQuery, [name, plate_number, rfid_uid, vehicle_type, expected_time_in], (err) => {
//     if (err) return res.status(500).json({ error: "Failed to add reservation" });

//     console.log(`📌 Reservation for ${name} added`);
//     res.status(201).json({ message: "Reservation added" });
//   });
// });

app.post("/api/reservations", (req, res) => {
  const { name, plate_number, rfid_uid, vehicle_type, expected_time_in } = req.body;

  // 🚨 Validate required fields
  if (!name || !plate_number || !rfid_uid || !vehicle_type || !expected_time_in) {
    return res.status(400).json({ error: "Missing reservation fields" });
  }

  // 🕓 Validate and format expected_time_in in Asia/Manila timezone
  const parsedExpectedTime = moment(expected_time_in).isValid()
    ? moment(expected_time_in).tz("Asia/Manila").format("YYYY-MM-DD HH:mm:ss")
    : null;

  if (!parsedExpectedTime) {
    return res.status(400).json({ error: "Invalid expected_time_in format" });
  }

  // 💾 Insert into reservation table
  const insertQuery = `
    INSERT INTO reservation (name, plate_number, rfid_uid, vehicle_type, expected_time_in)
    VALUES (?, ?, ?, ?, ?)
  `;

  db.query(
    insertQuery,
    [name, plate_number, rfid_uid, vehicle_type, parsedExpectedTime],
    (err) => {
      if (err) {
        console.error("❌ Reservation insert error:", err);
        return res.status(500).json({ error: "Failed to add reservation" });
      }

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
  const formattedNow = moment().tz("Asia/Manila").format("YYYY-MM-DD HH:mm:ss");

  const fetchDueQuery = `
    SELECT * FROM reservation 
    WHERE expected_time_in <= ? AND status = 'PENDING'
  `;

  db.query(fetchDueQuery, [formattedNow], (err, results) => {
    if (err) {
      console.error("❌ Error fetching due reservations:", err);
      return;
    }

    results.forEach((resv) => {
      const { id, name, plate_number, rfid_uid, expected_time_in, vehicle_type } = resv;

      // Avoid duplicating users
      const checkQuery = "SELECT * FROM users WHERE rfid_uid = ? AND status = 'ACTIVE'";
      db.query(checkQuery, [rfid_uid], (checkErr, checkResults) => {
        if (checkErr) {
          console.error("❌ Error checking active user:", checkErr);
          return;
        }

        if (checkResults.length === 0) {
          // Insert to users table
          const insertQuery = `
            INSERT INTO users (name, plate_number, rfid_uid, vehicle_type, time_in, status)
            VALUES (?, ?, ?, ?, ?, 'ACTIVE')
          `;
          db.query(insertQuery, [name, plate_number, rfid_uid, vehicle_type, expected_time_in], (insertErr) => {
            if (insertErr) {
              console.error("❌ Error inserting into users:", insertErr);
              return;
            }

            // ✅ Update reservation status to 'ACTIVATED'
            db.query("UPDATE reservation SET status = 'ACTIVATED' WHERE id = ?", [id]);

            console.log(`🚀 Activated reservation for ${name} (RFID: ${rfid_uid})`);
            broadcastToClients({
              update: "reservation_activated",
              rfid_uid,
            });
          });
        }
      });
    });
  });
}, 5000);


