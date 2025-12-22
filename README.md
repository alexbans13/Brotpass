# Brotpass

A fun, gamified mobile app for bread lovers to discover, check in, and celebrate bread experiences.

## Tech Stack

- **Framework**: Expo / React Native
- **Navigation**: Expo Router
- **Backend**: Supabase
- **Language**: TypeScript

## Setup

1. Install dependencies:
```bash
npm install
```

2. Set up environment variables:
```bash
cp .env.example .env
```

Fill in your Supabase credentials:
- `EXPO_PUBLIC_SUPABASE_URL`
- `EXPO_PUBLIC_SUPABASE_ANON_KEY`

3. Run database migrations:
   - Go to your Supabase dashboard
   - Navigate to SQL Editor
   - Run the SQL from `supabase/migrations/001_initial_schema.sql`

4. Start the development server:
```bash
npm start
```

## Project Structure

- `app/` - Expo Router screens and navigation
- `src/` - Source code (components, lib, hooks, services)
- `supabase/` - Database migrations
- `assets/` - Images, fonts, etc.

## V1 Scope

✅ User accounts & auth
✅ Bread catalog
✅ Bakery entities
✅ Check-ins with ratings, photos, notes
✅ Badge system
✅ User profiles & stats
✅ Bread search
✅ Onboarding

🚫 Out of scope: Social feed, friends, likes, comments, leaderboards, map discovery, notifications

## Development Notes

- All check-ins are public by default
- Users can check in to the same bread multiple times
- Check-ins cannot be edited or deleted in V1
- Badges are automatically unlocked based on progress
- Photos: max 3 per check-in (camera + gallery)

