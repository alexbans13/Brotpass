# Brotpass Project Structure

```
Brotpass/
├── app/                          # Expo Router app directory (if using) or screens
│   ├── (auth)/                   # Auth screens (welcome, login, signup)
│   │   ├── welcome.tsx
│   │   ├── login.tsx
│   │   └── signup.tsx
│   ├── (tabs)/                   # Main app tabs
│   │   ├── discover.tsx
│   │   ├── check-in.tsx
│   │   ├── badges.tsx
│   │   └── profile.tsx
│   ├── bread/
│   │   └── [id].tsx              # Bread detail screen
│   ├── badge/
│   │   └── [id].tsx              # Badge detail screen
│   └── onboarding/
│       ├── step1.tsx
│       ├── step2.tsx
│       └── step3.tsx
├── src/
│   ├── components/               # Reusable UI components
│   │   ├── ui/                   # Base UI components (buttons, inputs, etc.)
│   │   ├── bread/                # Bread-specific components
│   │   ├── badge/                # Badge components
│   │   └── check-in/             # Check-in components
│   ├── lib/                      # Utilities and helpers
│   │   ├── supabase.ts           # Supabase client
│   │   ├── types.ts              # TypeScript types
│   │   └── utils.ts              # Helper functions
│   ├── hooks/                    # Custom React hooks
│   │   ├── useAuth.ts
│   │   ├── useBread.ts
│   │   └── useBadges.ts
│   ├── services/                 # API/service layer
│   │   ├── auth.ts
│   │   ├── bread.ts
│   │   ├── checkin.ts
│   │   └── badges.ts
│   └── constants/                # App constants
│       ├── breadTypes.ts
│       └── colors.ts
├── assets/                       # Images, fonts, etc.
│   ├── images/
│   └── fonts/
├── supabase/
│   └── migrations/               # SQL migration files
│       └── 001_initial_schema.sql
├── app.json                      # Expo config
├── package.json
├── tsconfig.json
├── .env.example                  # Environment variables template
└── README.md
```

