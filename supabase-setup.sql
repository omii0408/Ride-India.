-- ============================================================
-- RideIndia Supabase Database Setup
-- Run this entire script in Supabase SQL Editor
-- ============================================================

-- ============================================================
-- 1. TABLES
-- ============================================================

-- Vehicles table
CREATE TABLE IF NOT EXISTS vehicles (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  name text NOT NULL,
  type text NOT NULL CHECK (type IN ('scooty','bike','premium','electric')),
  description text,
  price_hour numeric NOT NULL,
  price_day numeric NOT NULL,
  deposit numeric DEFAULT 0,
  advance numeric DEFAULT 0,
  fuel text,
  mileage text,
  transmission text DEFAULT 'Manual',
  seats integer DEFAULT 2,
  helmet_included boolean DEFAULT true,
  image_url text,
  status text DEFAULT 'available' CHECK (status IN ('available','unavailable','maintenance')),
  is_active boolean DEFAULT true,
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now()
);

-- Bookings table
CREATE TABLE IF NOT EXISTS bookings (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  vehicle_id uuid REFERENCES vehicles(id) ON DELETE SET NULL,
  vehicle_name text,
  vehicle_type text,
  customer_name text NOT NULL,
  customer_email text,
  customer_phone text NOT NULL,
  pickup_city text,
  pickup_date date,
  pickup_time text,
  return_date date,
  return_time text,
  rental_type text DEFAULT 'daily',
  license_number text,
  notes text,
  rent_amount numeric DEFAULT 0,
  deposit_amount numeric DEFAULT 0,
  advance_amount numeric DEFAULT 0,
  total_amount numeric DEFAULT 0,
  payment_method text DEFAULT 'UPI',
  status text DEFAULT 'pending' CHECK (status IN ('pending','confirmed','completed','cancelled')),
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now()
);

-- Admin users table
CREATE TABLE IF NOT EXISTS admin_users (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  email text UNIQUE NOT NULL,
  created_at timestamptz DEFAULT now()
);

-- ============================================================
-- 2. INSERT ADMIN EMAIL
-- ============================================================
INSERT INTO admin_users (email) VALUES ('as8557148@gmail.com')
ON CONFLICT (email) DO NOTHING;

-- ============================================================
-- 3. SEED VEHICLES
-- ============================================================
INSERT INTO vehicles (name, type, description, price_hour, price_day, deposit, advance, fuel, mileage, transmission, seats, helmet_included, image_url, status, is_active) VALUES

('Honda Activa 6G', 'scooty',
 'India''s best-selling scooter. Smooth ride, fuel efficient, perfect for city commute. BS6 engine with silent start and LED headlamp.',
 80, 550, 500, 200, 'Petrol', '50 km/l', 'Automatic', 2, true,
 'https://imgd.aeplcdn.com/664x374/n/cw/ec/44686/activa-6g-right-side-view.jpeg', 'available', true),

('TVS Jupiter', 'scooty',
 'Spacious and comfortable scooter with best-in-class mileage. Features synchro braking, external fuel fill, and mobile charging.',
 75, 500, 500, 200, 'Petrol', '55 km/l', 'Automatic', 2, true,
 'https://imgd.aeplcdn.com/664x374/n/cw/ec/44702/jupiter-right-side-view.jpeg', 'available', true),

('Hero Splendor Plus', 'bike',
 'Most trusted commuter bike in India. Reliable engine, great mileage, comfortable for daily use and long distances.',
 70, 450, 500, 200, 'Petrol', '65 km/l', 'Manual', 2, true,
 'https://imgd.aeplcdn.com/664x374/n/cw/ec/37561/splendor-plus-right-side-view.jpeg', 'available', true),

('Bajaj Pulsar 150', 'bike',
 'Sporty and powerful commuter bike with DTSi engine. Perfect balance of performance and fuel efficiency for city and highway.',
 120, 800, 1000, 300, 'Petrol', '45 km/l', 'Manual', 2, true,
 'https://imgd.aeplcdn.com/664x374/n/cw/ec/35259/pulsar-150-right-side-view.jpeg', 'available', true),

('Royal Enfield Classic 350', 'premium',
 'The iconic thump machine. Perfect for long highway rides, Himalayan trips, and weekend getaways. Rich retro styling with modern features.',
 180, 1200, 2000, 500, 'Petrol', '35 km/l', 'Manual', 2, true,
 'https://imgd.aeplcdn.com/664x374/n/cw/ec/44709/classic-350-right-side-view.jpeg', 'available', true),

('TVS Apache RTR 200', 'bike',
 'Performance-focused naked sport bike with race-derived features. Ideal for riders who want excitement and speed on city roads.',
 150, 1000, 1500, 400, 'Petrol', '40 km/l', 'Manual', 2, true,
 'https://imgd.aeplcdn.com/664x374/n/cw/ec/41466/apache-rtr-200-4v-right-side-view.jpeg', 'available', true),

('Honda SP 125', 'bike',
 'Premium commuter bike with Honda''s BS6 compliant engine. Smart and stylish with Bluetooth connectivity and best-in-class refinement.',
 90, 600, 500, 200, 'Petrol', '55 km/l', 'Manual', 2, true,
 'https://imgd.aeplcdn.com/664x374/n/cw/ec/39870/sp-125-right-side-view.jpeg', 'available', true),

('Suzuki Access 125', 'scooty',
 'Premium scooter with large under-seat storage, smooth engine, and comfortable ergonomics. Great for both city and highway.',
 85, 550, 500, 200, 'Petrol', '50 km/l', 'Automatic', 2, true,
 'https://imgd.aeplcdn.com/664x374/n/cw/ec/41466/access-125-right-side-view.jpeg', 'available', true),

('Royal Enfield Himalayan', 'premium',
 'Purpose-built adventure tourer. Ready for any terrain — city, highway, hills, or off-road. Your ideal companion for long expedition rides.',
 250, 1700, 3000, 700, 'Petrol', '30 km/l', 'Manual', 2, true,
 'https://imgd.aeplcdn.com/664x374/n/cw/ec/40025/himalayan-right-side-view.jpeg', 'available', true),

('KTM Duke 200', 'premium',
 'Austrian precision engineering in Indian streets. Aggressive naked design, liquid-cooled engine, and precise handling for adrenaline seekers.',
 200, 1400, 2000, 500, 'Petrol', '35 km/l', 'Manual', 2, true,
 'https://imgd.aeplcdn.com/664x374/n/cw/ec/35108/duke-200-right-side-view.jpeg', 'available', true),

('Yamaha Fascino 125', 'scooty',
 'Stylish and trendy scooter with side stand engine cutoff, Bluetooth connectivity, and smooth CVT transmission. Perfect for fashion-conscious riders.',
 80, 520, 500, 200, 'Petrol', '50 km/l', 'Automatic', 2, true,
 'https://imgd.aeplcdn.com/664x374/n/cw/ec/126467/fascino-125-fi-hybrid-right-side-view.jpeg', 'available', true),

('Bajaj Chetak EV', 'electric',
 'India''s iconic scooter reimagined as an EV. Zero emissions, silent ride, low running cost at ₹0.50/km. Smart connectivity with Bajaj app.',
 120, 800, 1000, 300, 'Electric', '95 km/charge', 'Automatic', 2, true,
 'https://imgd.aeplcdn.com/664x374/n/cw/ec/44710/chetak-right-side-view.jpeg', 'available', true);

-- ============================================================
-- 4. HELPER FUNCTION: is_current_user_admin
-- ============================================================
CREATE OR REPLACE FUNCTION is_current_user_admin()
RETURNS boolean
LANGUAGE sql SECURITY DEFINER
AS $$
  SELECT EXISTS (
    SELECT 1 FROM admin_users
    WHERE email = auth.email()
  );
$$;

-- ============================================================
-- 5. UPDATED_AT TRIGGER
-- ============================================================
CREATE OR REPLACE FUNCTION handle_updated_at()
RETURNS trigger LANGUAGE plpgsql AS $$
BEGIN
  NEW.updated_at = now();
  RETURN NEW;
END;
$$;

DROP TRIGGER IF EXISTS vehicles_updated_at ON vehicles;
CREATE TRIGGER vehicles_updated_at
  BEFORE UPDATE ON vehicles
  FOR EACH ROW EXECUTE FUNCTION handle_updated_at();

DROP TRIGGER IF EXISTS bookings_updated_at ON bookings;
CREATE TRIGGER bookings_updated_at
  BEFORE UPDATE ON bookings
  FOR EACH ROW EXECUTE FUNCTION handle_updated_at();

-- ============================================================
-- 6. ROW LEVEL SECURITY
-- ============================================================

-- Enable RLS
ALTER TABLE vehicles ENABLE ROW LEVEL SECURITY;
ALTER TABLE bookings ENABLE ROW LEVEL SECURITY;
ALTER TABLE admin_users ENABLE ROW LEVEL SECURITY;

-- Drop existing policies first (safe re-run)
DROP POLICY IF EXISTS "Public can view active vehicles" ON vehicles;
DROP POLICY IF EXISTS "Admins can view all vehicles" ON vehicles;
DROP POLICY IF EXISTS "Admins can insert vehicles" ON vehicles;
DROP POLICY IF EXISTS "Admins can update vehicles" ON vehicles;
DROP POLICY IF EXISTS "Admins can delete vehicles" ON vehicles;
DROP POLICY IF EXISTS "Anyone can insert booking" ON bookings;
DROP POLICY IF EXISTS "Admins can view all bookings" ON bookings;
DROP POLICY IF EXISTS "Admins can update bookings" ON bookings;
DROP POLICY IF EXISTS "Admins can read admin_users" ON admin_users;

-- VEHICLES policies
CREATE POLICY "Public can view active vehicles"
  ON vehicles FOR SELECT
  TO anon, authenticated
  USING (is_active = true AND status = 'available');

CREATE POLICY "Admins can view all vehicles"
  ON vehicles FOR SELECT
  TO authenticated
  USING (is_current_user_admin());

CREATE POLICY "Admins can insert vehicles"
  ON vehicles FOR INSERT
  TO authenticated
  WITH CHECK (is_current_user_admin());

CREATE POLICY "Admins can update vehicles"
  ON vehicles FOR UPDATE
  TO authenticated
  USING (is_current_user_admin())
  WITH CHECK (is_current_user_admin());

CREATE POLICY "Admins can delete vehicles"
  ON vehicles FOR DELETE
  TO authenticated
  USING (is_current_user_admin());

-- BOOKINGS policies
CREATE POLICY "Anyone can insert booking"
  ON bookings FOR INSERT
  TO anon, authenticated
  WITH CHECK (true);

CREATE POLICY "Admins can view all bookings"
  ON bookings FOR SELECT
  TO authenticated
  USING (is_current_user_admin());

CREATE POLICY "Admins can update bookings"
  ON bookings FOR UPDATE
  TO authenticated
  USING (is_current_user_admin())
  WITH CHECK (is_current_user_admin());

-- ADMIN_USERS policies
CREATE POLICY "Admins can read admin_users"
  ON admin_users FOR SELECT
  TO authenticated
  USING (is_current_user_admin());

-- ============================================================
-- 7. STORAGE BUCKET (run after creating bucket in dashboard)
-- ============================================================
-- First create the bucket "vehicle-images" in Supabase Dashboard
-- Storage > New bucket > Name: vehicle-images > Public: YES
-- Then run these storage policies:

INSERT INTO storage.buckets (id, name, public) 
VALUES ('vehicle-images', 'vehicle-images', true)
ON CONFLICT (id) DO NOTHING;

CREATE POLICY "Public can view vehicle images"
  ON storage.objects FOR SELECT
  TO public
  USING (bucket_id = 'vehicle-images');

CREATE POLICY "Admins can upload vehicle images"
  ON storage.objects FOR INSERT
  TO authenticated
  WITH CHECK (bucket_id = 'vehicle-images' AND is_current_user_admin());

CREATE POLICY "Admins can update vehicle images"
  ON storage.objects FOR UPDATE
  TO authenticated
  USING (bucket_id = 'vehicle-images' AND is_current_user_admin());

CREATE POLICY "Admins can delete vehicle images"
  ON storage.objects FOR DELETE
  TO authenticated
  USING (bucket_id = 'vehicle-images' AND is_current_user_admin());

-- ============================================================
-- DONE! Verify setup:
-- ============================================================
-- SELECT * FROM vehicles;
-- SELECT * FROM admin_users;
-- SELECT is_current_user_admin();  (after logging in as admin)
