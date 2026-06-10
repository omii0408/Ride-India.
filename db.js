const sqlite3 = require('sqlite3').verbose();
const path = require('path');

const dbPath = path.join(__dirname, 'rideindia.db');
const db = new sqlite3.Database(dbPath, (err) => {
  if (err) {
    console.error('Database connection error:', err.message);
  } else {
    console.log('Connected to SQLite database at', dbPath);
  }
});

// Initialize tables
db.serialize(() => {
  db.run(`CREATE TABLE IF NOT EXISTS contacts (
    id TEXT PRIMARY KEY,
    name TEXT NOT NULL,
    email TEXT NOT NULL,
    phone TEXT,
    subject TEXT,
    message TEXT NOT NULL,
    ip TEXT,
    timestamp DATETIME NOT NULL,
    isRead BOOLEAN DEFAULT FALSE,
    userId INTEGER
  )`);

  db.run(`CREATE TABLE IF NOT EXISTS bookings (
    id TEXT PRIMARY KEY,
    userId TEXT,
    vehicleId INTEGER NOT NULL,
    vehicleName TEXT NOT NULL,
    vehicleType TEXT NOT NULL,
    customerName TEXT NOT NULL,
    email TEXT NOT NULL,
    phone TEXT NOT NULL,
    city TEXT NOT NULL,
    pickupDate TEXT NOT NULL,
    pickupTime TEXT NOT NULL,
    returnDate TEXT NOT NULL,
    returnTime TEXT NOT NULL,
    rentalType TEXT NOT NULL,
    licenseNumber TEXT NOT NULL,
    notes TEXT,
    priceHour INTEGER NOT NULL,
    priceDay INTEGER NOT NULL,
    duration REAL NOT NULL,
    rentAmount INTEGER NOT NULL,
    depositAmount INTEGER NOT NULL,
    advanceAmount INTEGER NOT NULL,
    totalAmount INTEGER NOT NULL,
    paymentMethod TEXT NOT NULL,
    status TEXT DEFAULT 'Pending',
    createdAt DATETIME NOT NULL
  )`);
});

// ===== CONTACTS =====
async function insertContact(contact) {
  return new Promise((resolve, reject) => {
    const stmt = db.prepare(`
      INSERT INTO contacts (id, name, email, phone, subject, message, ip, timestamp)
      VALUES (?, ?, ?, ?, ?, ?, ?, ?)
    `);
    stmt.run([
      contact.id, contact.name, contact.email, contact.phone,
      contact.subject, contact.message, contact.ip, contact.timestamp
    ], function(err) {
      stmt.finalize();
      if (err) reject(err);
      else resolve({ id: this.lastID, ...contact });
    });
  });
}

async function getContacts(limit = 50) {
  return new Promise((resolve, reject) => {
    db.all(`SELECT * FROM contacts ORDER BY timestamp DESC LIMIT ?`, [limit], (err, rows) => {
      if (err) reject(err);
      else resolve(rows);
    });
  });
}

async function markAsRead(id) {
  return new Promise((resolve, reject) => {
    db.run('UPDATE contacts SET isRead = TRUE WHERE id = ?', [id], function(err) {
      if (err) reject(err);
      else resolve({ changes: this.changes });
    });
  });
}

// ===== BOOKINGS =====
async function insertBooking(booking) {
  return new Promise((resolve, reject) => {
    const stmt = db.prepare(`
      INSERT INTO bookings (
        id, userId, vehicleId, vehicleName, vehicleType,
        customerName, email, phone, city,
        pickupDate, pickupTime, returnDate, returnTime,
        rentalType, licenseNumber, notes,
        priceHour, priceDay, duration,
        rentAmount, depositAmount, advanceAmount, totalAmount,
        paymentMethod, status, createdAt
      ) VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)
    `);
    stmt.run([
      booking.id, booking.userId, booking.vehicleId, booking.vehicleName, booking.vehicleType,
      booking.customerName, booking.email, booking.phone, booking.city,
      booking.pickupDate, booking.pickupTime, booking.returnDate, booking.returnTime,
      booking.rentalType, booking.licenseNumber, booking.notes || '',
      booking.priceHour, booking.priceDay, booking.duration,
      booking.rentAmount, booking.depositAmount, booking.advanceAmount, booking.totalAmount,
      booking.paymentMethod, booking.status || 'Pending', booking.createdAt
    ], function(err) {
      stmt.finalize();
      if (err) reject(err);
      else resolve(booking);
    });
  });
}

async function getBookings(limit = 100) {
  return new Promise((resolve, reject) => {
    db.all(`SELECT * FROM bookings ORDER BY createdAt DESC LIMIT ?`, [limit], (err, rows) => {
      if (err) reject(err);
      else resolve(rows);
    });
  });
}

async function getBookingById(id) {
  return new Promise((resolve, reject) => {
    db.get(`SELECT * FROM bookings WHERE id = ?`, [id], (err, row) => {
      if (err) reject(err);
      else resolve(row);
    });
  });
}

async function updateBookingStatus(id, status) {
  return new Promise((resolve, reject) => {
    db.run(`UPDATE bookings SET status = ? WHERE id = ?`, [status, id], function(err) {
      if (err) reject(err);
      else resolve({ changes: this.changes });
    });
  });
}

async function getBookingsByUserId(userId) {
  return new Promise((resolve, reject) => {
    db.all(`SELECT * FROM bookings WHERE userId = ? ORDER BY createdAt DESC`, [userId], (err, rows) => {
      if (err) reject(err);
      else resolve(rows);
    });
  });
}

module.exports = {
  insertContact, getContacts, markAsRead,
  insertBooking, getBookings, getBookingById, updateBookingStatus, getBookingsByUserId,
  dbPath
};
