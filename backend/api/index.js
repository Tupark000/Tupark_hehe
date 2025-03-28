// import express from "express";
// import pool from "../db.js";
// import cors from "cors";

// api/index.js
const express = require("express");
const mysql = require("mysql2/promise");
const cors = require("cors");
require("dotenv").config();

const app = express();
app.use(cors());
app.use(express.json());

// Database connection pool
const db = mysql.createPool({
  host: process.env.DB_HOST || "localhost",
  user: process.env.DB_USER || "root",
  password: process.env.DB_PASS || "admin12345",
  database: process.env.DB_NAME || "rfid_db",
});

// All your API routes...
// Keep your routes like /login, /add-user, /exit-user, etc.

// API Route: Get active users
app.get("/users", (req, res) => {
    db.query("SELECT * FROM users WHERE active = 1", (err, results) => {
      if (err) {
        return res.status(500).json({ error: err.message });
      }
      res.json(results);
    });
  });
  
  // API Route: Add new user
  app.post("/add-user", (req, res) => {
    const { name, plate_no, rfid } = req.body;
    const sql = "INSERT INTO users (name, plate_no, rfid, active) VALUES (?, ?, ?, 1)";
    db.query(sql, [name, plate_no, rfid], (err, result) => {
      if (err) return res.status(500).json({ error: err.message });
      res.json({ message: "User added successfully", userId: result.insertId });
    });
  });
  
  // API Route: Mark RFID as inactive (exit scanner)
  app.post("/deactivate-rfid", (req, res) => {
    const { rfid } = req.body;
    const sql = "UPDATE users SET active = 0 WHERE rfid = ?";
    db.query(sql, [rfid], (err, result) => {
      if (err) return res.status(500).json({ error: err.message });
      res.json({ message: "RFID deactivated successfully" });
    });
  });
  
  // Login API
  app.post("/login", (req, res) => {
      const { email, password } = req.body;
      const query = "SELECT * FROM admins WHERE email = ? AND password = ?";
      
      db.query(query, [email, password], (err, result) => {
        if (err) {
          res.status(500).send("Server error");
        } else if (result.length > 0) {
          res.status(200).json({ message: "Login successful" });
        } else {
          res.status(401).json({ message: "Invalid email or password" });
        }
      });
    });
  
    app.post("/deactivate-rfid", (req, res) => {
      const { rfid } = req.body;
      const sql = "UPDATE users SET active = 0, time_out = NOW() WHERE rfid = ? AND active = 1";
      
      db.query(sql, [rfid], (err, result) => {
        if (err) return res.status(500).json({ error: err.message });
        if (result.affectedRows > 0) {
          res.json({ message: "RFID deactivated successfully" });
        } else {
          res.status(400).json({ error: "RFID not found or already inactive" });
        }
      });
    });
  
    // API Route: Add a Reservation
  app.post("/add-reservation", (req, res) => {
      const { name, plate_no, rfid, expected_time } = req.body;
      const sql = "INSERT INTO reservations (name, plate_no, rfid, expected_time, status) VALUES (?, ?, ?, ?, 'Pending')";
      
      db.query(sql, [name, plate_no, rfid, expected_time], (err, result) => {
        if (err) return res.status(500).json({ error: err.message });
        res.json({ message: "Reservation added successfully", reservationId: result.insertId });
      });
    });
    
    // API Route: Get Pending Reservations
    app.get("/reservations", (req, res) => {
      db.query("SELECT * FROM reservations WHERE status = 'Pending'", (err, results) => {
        if (err) return res.status(500).json({ error: err.message });
        res.json(results);
      });
    });
    
   // API Route: Transfer reservations to active users when time arrives
   app.post('/transfer-reservations', async (req, res) => {
      try {
          const now = new Date(); 
          const formattedNow = now.toISOString().slice(0, 19).replace('T', ' ');
  
          const [reservations] = await db.query(
              "SELECT * FROM reservations WHERE expected_time <= ?", [formattedNow]
          );
  
          for (let reservation of reservations) {
              await db.query(
                  "INSERT INTO active_users (name, plate_number, rfid, time_in) VALUES (?, ?, ?, ?)",
                  [reservation.name, reservation.plate_number, reservation.rfid, formattedNow]
              );
  
              await db.query("DELETE FROM reservations WHERE rfid = ?", [reservation.rfid]);
          }
  
          res.json({ message: "Reservations transferred successfully." });
      } catch (error) {
          console.error(error);
          res.status(500).json({ error: "Error transferring reservations." });
      }
    
      
      // Get the reservation details
      const getReservation = "SELECT * FROM reservations WHERE rfid = ? AND status = 'Pending'";
      db.query(getReservation, [rfid], (err, result) => {
        if (err) return res.status(500).json({ error: err.message });
        if (result.length === 0) return res.status(404).json({ message: "No pending reservation found" });
    
        const user = result[0];
        const time_in = new Date();
    
        // Insert into users table
        const insertUser = "INSERT INTO users (name, plate_no, rfid, time_in, active) VALUES (?, ?, ?, ?, 1)";
        db.query(insertUser, [user.name, user.plate_no, user.rfid, time_in], (err, response) => {
          if (err) return res.status(500).json({ error: err.message });
    
          // Mark reservation as 'Active'
          const updateReservation = "UPDATE reservations SET status = 'Active' WHERE rfid = ?";
          db.query(updateReservation, [rfid], (err) => {
            if (err) return res.status(500).json({ error: err.message });
            res.json({ message: "Reservation activated successfully" });
          });
        });
      });
    });  
  
    app.post('/exit-user', async (req, res) => {
      const { rfid } = req.body;
  
      if (!rfid) {
          return res.status(400).json({ message: "RFID is required" });
      }
  
      try {
          const [user] = await db.query("SELECT * FROM users WHERE rfid = ? AND active = 1", [rfid]);
  
          if (user.length === 0) {
              return res.status(404).json({ message: "Active user not found" });
          }
  
          // Mark user as inactive & log exit time
          await db.query("UPDATE users SET active = 0, time_out = NOW() WHERE rfid = ?", [rfid]);
  
          return res.json({ message: "User exited successfully" });
      } catch (error) {
          console.error(error);
          return res.status(500).json({ message: "Server error" });
    }});


module.exports = app;

