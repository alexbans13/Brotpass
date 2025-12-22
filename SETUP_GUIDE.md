# Brotpass Setup Guide

## ✅ What's Been Set Up

### 1. Project Structure
- Clean, organized folder structure following Expo Router conventions
- Separation of concerns: components, services, hooks, constants
- TypeScript configuration with path aliases (`@/` for `src/`)

### 2. Database Schema (Supabase)
Complete SQL migration file at `supabase/migrations/001_initial_schema.sql` includes:

**Tables:**
- `users` - User profiles with stats
- `breads` - Bread catalog
- `bakeries` - Bakery entities with Google Maps integration
- `bread_bakeries` - Many-to-many relationship
- `check_ins` - User check-ins with optional ratings, notes, price
- `check_in_photos` - Photos (max 3 per check-in)
- `badges` - Badge definitions
- `user_badges` - User badge progress tracking

**Features:**
- Row Level Security (RLS) policies
- Automatic user stats updates via triggers
- User profile creation on signup
- Proper indexes for performance

### 3. Navigation Structure
- **Auth Stack**: Welcome → Login/Signup
- **Onboarding**: 3-step wizard
- **Main App**: 4 bottom tabs
  - Discover
  - Check In
  - Badges
  - Profile
- **Detail Screens**: Bread detail, Badge detail

### 4. Core Files Created

**Configuration:**
- `package.json` - Dependencies (Expo, Supabase, image picker, camera)
- `app.json` - Expo configuration
- `tsconfig.json` - TypeScript config
- `babel.config.js` - Babel config with module resolver
- `.env.example` - Environment variables template

**Source Code:**
- `src/lib/supabase.ts` - Supabase client setup
- `src/lib/types.ts` - TypeScript type definitions
- `src/constants/colors.ts` - Color palette
- `src/constants/breadTypes.ts` - Bread type definitions

**Screens:**
- Auth: welcome, login, signup
- Onboarding: step1, step2, step3
- Tabs: discover, check-in, badges, profile
- Details: bread/[id], badge/[id]

## 🚀 Next Steps

### 1. Install Dependencies
```bash
npm install
```

### 2. Set Up Supabase
1. Create a Supabase project at https://supabase.com
2. Copy your project URL and anon key
3. Create `.env` file:
   ```
   EXPO_PUBLIC_SUPABASE_URL=your_url_here
   EXPO_PUBLIC_SUPABASE_ANON_KEY=your_key_here
   ```

### 3. Run Database Migration
1. Go to Supabase Dashboard → SQL Editor
2. Copy and paste the contents of `supabase/migrations/001_initial_schema.sql`
3. Run the migration

### 4. Start Development
```bash
npm start
```

## 📋 What's Next to Build

The foundation is ready. Next steps:

1. **Services Layer** - API functions for:
   - Auth (login, signup, session management)
   - Bread (search, fetch, details)
   - Check-ins (create, list)
   - Badges (fetch, progress tracking)

2. **UI Components** - Reusable components:
   - Bread cards
   - Check-in form
   - Badge display
   - Rating input
   - Photo picker

3. **Screen Implementation**:
   - Discover: Search and bread listing
   - Check In: Form with bread search, rating, photos, notes
   - Badges: Badge grid with progress
   - Profile: User stats and highlighted badges

4. **Badge System Logic**:
   - Progress calculation functions
   - Badge unlock detection
   - Celebration animations

## 🎨 Design Notes

- Color palette is warm and artisanal (golden browns, creams)
- UI should feel elegant but playful
- All screens have placeholder content ready for implementation
- Navigation is fully functional

## 🔒 Security

- RLS policies are set up for all tables
- Users can only create/update their own data
- Public data (breads, badges) is readable by all
- Check-ins are public by default but users can see their own private ones

