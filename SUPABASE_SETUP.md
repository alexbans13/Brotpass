# Supabase Connection Setup

## ⚠️ Important: Use the Anon Key, Not the Secret Key

The key you provided starts with `sb_secret_` which is a **secret key**. For client-side React Native apps, you must use the **anon/public key** instead.

## How to Find Your Anon Key

1. Go to your Supabase project dashboard: https://supabase.com/dashboard/project/voyzopfzgvyxedodaoid
2. Click on **Settings** (gear icon) in the left sidebar
3. Click on **API** in the settings menu
4. Under **Project API keys**, find the **anon public** key
5. Copy that key (it should start with `eyJ...` not `sb_secret_`)

## Create Your .env File

Create a file named `.env` in the root of your project with the following content:

```env
EXPO_PUBLIC_SUPABASE_URL=https://voyzopfzgvyxedodaoid.supabase.co
EXPO_PUBLIC_SUPABASE_ANON_KEY=your_anon_key_here
```

Replace `your_anon_key_here` with the anon key from step 5 above.

## Quick Setup Steps

1. **Get your anon key** from Supabase dashboard (Settings → API → anon public key)
2. **Create `.env` file** in the project root with the content above
3. **Restart your Expo dev server** if it's running (environment variables are loaded at startup)

## Verify Connection

After setting up, the app should be able to connect to Supabase. The connection is configured in `src/lib/supabase.ts`.

## Security Note

- ✅ **Anon key**: Safe to use in client-side code (has RLS protection)
- ❌ **Secret key**: Never use in client-side code (bypasses RLS)

Your database has Row Level Security (RLS) enabled, so the anon key is safe to use in the mobile app.

