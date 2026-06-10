require('dotenv').config();
const express = require('express');
const cors = require('cors');
const helmet = require('helmet');
const bodyParser = require('body-parser');
const rateLimit = require('express-rate-limit');
const path = require('path');

const app = express();
const PORT = process.env.PORT || 3001;

// ── Security ──────────────────────────────────────────────────────────────────
app.use(helmet({ contentSecurityPolicy: false }));
app.use(cors({ origin: '*', credentials: true }));
app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: true }));

// Serve static files (images, index.html)
app.use(express.static(path.join(__dirname)));

// Rate limiting
const limiter = rateLimit({ windowMs: 15 * 60 * 1000, max: 50 });
app.use('/api/', limiter);

// ── Supabase Admin client (secret key — backend only) ─────────────────────────
let supabaseAdmin = null;
if (process.env.SUPABASE_URL && process.env.SUPABASE_SECRET_KEY) {
  try {
    const { createClient } = require('@supabase/supabase-js');
    supabaseAdmin = createClient(
      process.env.SUPABASE_URL,
      process.env.SUPABASE_SECRET_KEY,
      { auth: { autoRefreshToken: false, persistSession: false } }
    );
    console.log('✅ Supabase admin client initialized');
  } catch (e) {
    console.warn('⚠️  Supabase admin client failed:', e.message);
  }
} else {
  console.warn('⚠️  SUPABASE_URL or SUPABASE_SECRET_KEY not set — Supabase admin disabled');
}

// ── Health check ──────────────────────────────────────────────────────────────
app.get('/health', (req, res) => {
  res.json({
    status: 'OK',
    timestamp: new Date().toISOString(),
    supabase: supabaseAdmin ? 'connected' : 'not configured'
  });
});

// ── Contact form (keeps existing SQLite fallback) ─────────────────────────────
const db = (() => {
  try { return require('./db'); } catch { return null; }
})();

app.post('/api/contact', async (req, res) => {
  try {
    const { name, email, phone, subject, message } = req.body;
    if (!name || !email || !message) {
      return res.status(400).json({ error: 'Name, email, and message are required' });
    }
    const contact = {
      name: name.trim(), email: email.trim().toLowerCase(),
      phone: phone || null, subject: subject || 'General Inquiry',
      message: message.trim()
    };

    // Try Supabase first, fall back to SQLite
    if (supabaseAdmin) {
      const { error } = await supabaseAdmin.from('contacts').insert([contact]);
      if (error) console.error('Supabase contact insert error:', error.message);
    } else if (db) {
      const { v4: uuidv4 } = require('uuid');
      await db.insertContact({
        id: uuidv4(), ...contact,
        ip: req.ip, timestamp: new Date().toISOString()
      });
    }
    res.json({ success: true, message: 'Message sent successfully!' });
  } catch (error) {
    console.error('Contact error:', error);
    res.status(500).json({ error: 'Server error' });
  }
});

// ── Booking status update (admin only via server) ─────────────────────────────
app.patch('/api/bookings/:id/status', async (req, res) => {
  if (!supabaseAdmin) return res.status(503).json({ error: 'Supabase not configured' });
  try {
    const { status } = req.body;
    const allowed = ['pending', 'confirmed', 'completed', 'cancelled'];
    if (!allowed.includes(status)) {
      return res.status(400).json({ error: 'Invalid status' });
    }
    const { error } = await supabaseAdmin
      .from('bookings')
      .update({ status })
      .eq('id', req.params.id);
    if (error) throw error;
    res.json({ success: true, message: `Status updated to ${status}` });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

// ── Get all bookings (admin proxy) ────────────────────────────────────────────
app.get('/api/admin/bookings', async (req, res) => {
  if (!supabaseAdmin) return res.status(503).json({ error: 'Supabase not configured' });
  try {
    const { data, error } = await supabaseAdmin
      .from('bookings')
      .select('*')
      .order('created_at', { ascending: false });
    if (error) throw error;
    res.json({ success: true, bookings: data });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

app.listen(PORT, () => {
  console.log(`🚀 RideIndia Backend → http://localhost:${PORT}`);
  console.log(`📋 Health → http://localhost:${PORT}/health`);
});
