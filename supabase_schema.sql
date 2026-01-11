-- Custom users table for manual authentication
CREATE TABLE users (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  username TEXT UNIQUE NOT NULL,
  phone TEXT UNIQUE NOT NULL,
  password TEXT NOT NULL, -- In a real app, this would be hashed
  role TEXT DEFAULT 'user',
  created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
);

-- Enable RLS and add policies for manual auth
ALTER TABLE users ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Allow public insert for sign up" ON users FOR INSERT WITH CHECK (true);
CREATE POLICY "Allow public select for login" ON users FOR SELECT USING (true);

-- Update bookings to reference the new users table
ALTER TABLE bookings DROP CONSTRAINT IF EXISTS bookings_user_id_fkey;
ALTER TABLE bookings ADD CONSTRAINT bookings_user_id_fkey FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE;

-- Create pitches table
CREATE TABLE pitches (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  name TEXT NOT NULL,
  description TEXT,
  pitch_type TEXT NOT NULL, -- e.g., '5-a-side', '7-a-side'
  price_per_hour DECIMAL NOT NULL,
  is_active BOOLEAN DEFAULT true,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
);

-- Create bookings table
CREATE TABLE bookings (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  user_id UUID REFERENCES profiles(id) ON DELETE CASCADE,
  pitch_id UUID REFERENCES pitches(id) ON DELETE CASCADE,
  start_time TIMESTAMP WITH TIME ZONE NOT NULL,
  end_time TIMESTAMP WITH TIME ZONE NOT NULL,
  total_price DECIMAL NOT NULL,
  team_name TEXT NOT NULL,
  status TEXT DEFAULT 'confirmed' CHECK (status IN ('pending', 'confirmed', 'cancelled', 'completed')),
  is_recurring BOOLEAN DEFAULT false,
  recurring_group_id UUID,
  extras JSONB, -- { "bibs": true, "balls": 2 }
  created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
);

-- Set up Row Level Security (RLS)
ALTER TABLE profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE pitches ENABLE ROW LEVEL SECURITY;
ALTER TABLE bookings ENABLE ROW LEVEL SECURITY;

-- Profiles: Users can read all, but only update their own
CREATE POLICY "Public profiles are viewable by everyone." ON profiles FOR SELECT USING (true);
CREATE POLICY "Users can update own profile." ON profiles FOR UPDATE USING (auth.uid() = id);

-- Pitches: Viewable by everyone, only admins can modify
CREATE POLICY "Pitches are viewable by everyone." ON pitches FOR SELECT USING (true);
CREATE POLICY "Only admins can modify pitches." ON pitches FOR ALL USING (
  EXISTS (SELECT 1 FROM profiles WHERE id = auth.uid() AND role = 'admin')
);

-- Bookings: Users can view and create their own, admins see all
CREATE POLICY "Users can view their own bookings." ON bookings FOR SELECT USING (
  auth.uid() = user_id OR EXISTS (SELECT 1 FROM profiles WHERE id = auth.uid() AND role IN ('admin', 'staff'))
);
CREATE POLICY "Users can create their own bookings." ON bookings FOR INSERT WITH CHECK (auth.uid() = user_id);
-- Seed the single stadium
INSERT INTO pitches (name, description, pitch_type, price_per_hour)
VALUES ('Main Stadium', 'The primary professional arena', '11-a-side', 100)
ON CONFLICT DO NOTHING;
