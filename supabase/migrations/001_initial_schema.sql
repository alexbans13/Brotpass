-- Brotpass V1 Database Schema
-- Supabase migration file

-- Enable UUID extension
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- ============================================
-- ENUMS
-- ============================================

-- Bread type enum (fixed list)
CREATE TYPE bread_type AS ENUM (
  'wheat_bread',
  'mixed_wheat_bread',
  'mixed_rye_bread',
  'rye_bread',
  'wholegrain_bread',
  'multigrain'
);

-- Badge category enum
CREATE TYPE badge_category AS ENUM (
  'volume',
  'bread_style',
  'region',
  'bakery_hopping'
);

-- ============================================
-- TABLES
-- ============================================

-- Users table (extends Supabase auth.users)
CREATE TABLE public.users (
  id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
  email TEXT UNIQUE NOT NULL,
  username TEXT UNIQUE NOT NULL,
  avatar TEXT,
  bio TEXT,
  location TEXT,
  check_ins_count INTEGER DEFAULT 0,
  breads_tried_count INTEGER DEFAULT 0,
  avg_rating NUMERIC(3, 2), -- e.g., 4.25
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Bakeries table
CREATE TABLE public.bakeries (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  name TEXT NOT NULL,
  google_maps_place_id TEXT UNIQUE,
  address TEXT,
  country TEXT,
  region TEXT,
  is_chain BOOLEAN DEFAULT FALSE,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Bread catalog table
CREATE TABLE public.breads (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  name TEXT NOT NULL,
  bread_type bread_type NOT NULL,
  country TEXT,
  region TEXT,
  description TEXT,
  created_by UUID REFERENCES auth.users(id),
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Junction table: breads <-> bakeries (many-to-many)
CREATE TABLE public.bread_bakeries (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  bread_id UUID NOT NULL REFERENCES public.breads(id) ON DELETE CASCADE,
  bakery_id UUID NOT NULL REFERENCES public.bakeries(id) ON DELETE CASCADE,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  UNIQUE(bread_id, bakery_id)
);

-- Check-ins table
CREATE TABLE public.check_ins (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID NOT NULL REFERENCES public.users(id) ON DELETE CASCADE,
  bread_id UUID NOT NULL REFERENCES public.breads(id) ON DELETE CASCADE,
  rating NUMERIC(3, 2) CHECK (rating >= 1 AND rating <= 5), -- 1-5 with 0.25 increments
  notes TEXT,
  price NUMERIC(10, 2),
  is_public BOOLEAN DEFAULT TRUE,
  created_at TIMESTAMPTZ DEFAULT NOW()
  -- Users can check in to the same bread multiple times
  -- No unique constraint on (user_id, bread_id)
  -- Check-ins cannot be edited or deleted in V1
);

-- Check-in photos table (max 3 per check-in)
CREATE TABLE public.check_in_photos (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  check_in_id UUID NOT NULL REFERENCES public.check_ins(id) ON DELETE CASCADE,
  photo_url TEXT NOT NULL,
  display_order INTEGER NOT NULL CHECK (display_order >= 1 AND display_order <= 3),
  created_at TIMESTAMPTZ DEFAULT NOW(),
  UNIQUE(check_in_id, display_order)
);

-- Badges definition table
CREATE TABLE public.badges (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  name TEXT NOT NULL,
  description TEXT,
  category badge_category NOT NULL,
  level INTEGER NOT NULL DEFAULT 1,
  max_level INTEGER NOT NULL DEFAULT 1,
  progress_requirement INTEGER NOT NULL, -- e.g., "try 10 breads" = 10
  icon_name TEXT, -- For future icon system
  created_at TIMESTAMPTZ DEFAULT NOW(),
  UNIQUE(name, level)
);

-- User badges (progress tracking)
CREATE TABLE public.user_badges (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID NOT NULL REFERENCES public.users(id) ON DELETE CASCADE,
  badge_id UUID NOT NULL REFERENCES public.badges(id) ON DELETE CASCADE,
  current_progress INTEGER DEFAULT 0,
  is_unlocked BOOLEAN DEFAULT FALSE,
  unlocked_at TIMESTAMPTZ,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW(),
  UNIQUE(user_id, badge_id)
);

-- ============================================
-- INDEXES
-- ============================================

CREATE INDEX idx_check_ins_user_id ON public.check_ins(user_id);
CREATE INDEX idx_check_ins_bread_id ON public.check_ins(bread_id);
CREATE INDEX idx_check_ins_created_at ON public.check_ins(created_at DESC);
CREATE INDEX idx_breads_bread_type ON public.breads(bread_type);
CREATE INDEX idx_breads_country ON public.breads(country);
CREATE INDEX idx_user_badges_user_id ON public.user_badges(user_id);
CREATE INDEX idx_user_badges_badge_id ON public.user_badges(badge_id);
CREATE INDEX idx_bread_bakeries_bread_id ON public.bread_bakeries(bread_id);
CREATE INDEX idx_bread_bakeries_bakery_id ON public.bread_bakeries(bakery_id);

-- ============================================
-- ROW LEVEL SECURITY (RLS)
-- ============================================

-- Enable RLS on all tables
ALTER TABLE public.users ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.breads ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.bakeries ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.bread_bakeries ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.check_ins ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.check_in_photos ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.badges ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.user_badges ENABLE ROW LEVEL SECURITY;

-- Users: Can read all, update own
CREATE POLICY "Users are viewable by everyone" ON public.users
  FOR SELECT USING (true);

CREATE POLICY "Users can update own profile" ON public.users
  FOR UPDATE USING (auth.uid() = id);

-- Breads: Public read, admin write
CREATE POLICY "Breads are viewable by everyone" ON public.breads
  FOR SELECT USING (true);

-- Bakeries: Public read, admin write
CREATE POLICY "Bakeries are viewable by everyone" ON public.bakeries
  FOR SELECT USING (true);

-- Bread-bakery links: Public read
CREATE POLICY "Bread bakeries are viewable by everyone" ON public.bread_bakeries
  FOR SELECT USING (true);

-- Check-ins: Public read, users can create own
CREATE POLICY "Check-ins are viewable by everyone" ON public.check_ins
  FOR SELECT USING (is_public = true OR auth.uid() = user_id);

CREATE POLICY "Users can create own check-ins" ON public.check_ins
  FOR INSERT WITH CHECK (auth.uid() = user_id);

-- Check-in photos: Same as check-ins
CREATE POLICY "Check-in photos are viewable by everyone" ON public.check_in_photos
  FOR SELECT USING (
    EXISTS (
      SELECT 1 FROM public.check_ins
      WHERE check_ins.id = check_in_photos.check_in_id
      AND (check_ins.is_public = true OR check_ins.user_id = auth.uid())
    )
  );

CREATE POLICY "Users can create photos for own check-ins" ON public.check_in_photos
  FOR INSERT WITH CHECK (
    EXISTS (
      SELECT 1 FROM public.check_ins
      WHERE check_ins.id = check_in_photos.check_in_id
      AND check_ins.user_id = auth.uid()
    )
  );

-- Badges: Public read
CREATE POLICY "Badges are viewable by everyone" ON public.badges
  FOR SELECT USING (true);

-- User badges: Users can read all, update own
CREATE POLICY "User badges are viewable by everyone" ON public.user_badges
  FOR SELECT USING (true);

CREATE POLICY "Users can update own badge progress" ON public.user_badges
  FOR UPDATE USING (auth.uid() = user_id);

CREATE POLICY "System can insert user badges" ON public.user_badges
  FOR INSERT WITH CHECK (true); -- Will be handled by triggers/functions

-- ============================================
-- FUNCTIONS & TRIGGERS
-- ============================================

-- Function to update user stats after check-in
CREATE OR REPLACE FUNCTION update_user_stats_after_checkin()
RETURNS TRIGGER AS $$
BEGIN
  UPDATE public.users
  SET
    check_ins_count = (
      SELECT COUNT(*) FROM public.check_ins
      WHERE user_id = NEW.user_id
    ),
    breads_tried_count = (
      SELECT COUNT(DISTINCT bread_id) FROM public.check_ins
      WHERE user_id = NEW.user_id
    ),
    avg_rating = (
      SELECT AVG(rating) FROM public.check_ins
      WHERE user_id = NEW.user_id AND rating IS NOT NULL
    ),
    updated_at = NOW()
  WHERE id = NEW.user_id;
  
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Trigger to update stats on check-in insert
CREATE TRIGGER trigger_update_user_stats
  AFTER INSERT ON public.check_ins
  FOR EACH ROW
  EXECUTE FUNCTION update_user_stats_after_checkin();

-- Function to create user profile on signup
CREATE OR REPLACE FUNCTION handle_new_user()
RETURNS TRIGGER AS $$
BEGIN
  INSERT INTO public.users (id, email, username)
  VALUES (
    NEW.id,
    NEW.email,
    COALESCE(NEW.raw_user_meta_data->>'username', 'user_' || substr(NEW.id::text, 1, 8))
  );
  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Trigger to create user profile
CREATE TRIGGER on_auth_user_created
  AFTER INSERT ON auth.users
  FOR EACH ROW
  EXECUTE FUNCTION handle_new_user();

-- Function to update updated_at timestamp
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Triggers for updated_at
CREATE TRIGGER update_users_updated_at BEFORE UPDATE ON public.users
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_bakeries_updated_at BEFORE UPDATE ON public.bakeries
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_breads_updated_at BEFORE UPDATE ON public.breads
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_user_badges_updated_at BEFORE UPDATE ON public.user_badges
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

