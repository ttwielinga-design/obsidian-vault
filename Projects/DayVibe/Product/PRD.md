---
title: "PRD"
date: 2026-05-10
type: reference
area: projects
project: dayvibe
tags: [type/reference, area/projects, project/dayvibe, status/active, topic/product, topic/software]
status: active
---


# DayVibe MVP Build Instructions for Replit

## Project Initialization
Create React Native (Expo) project with these exact dependencies:
- expo-av (voice recording)
- supabase/supabase-js (database)
- clerk/clerk-expo (auth + payments)
- stripe-react-native (payments)
- react-native-firebase/app (FCM core)
- react-native-firebase/messaging (FCM notifications)


## Database Setup Instructions
Connect to Supabase and create these exact tables:
1. **users**: clerk_id, email, subscription_status, stripe_customer_id, created_at
2. **journal_entries**: user_id, audio_url, transcription, ai_insights (JSONB), created_at  
3. **weekly_reviews**: user_id, week_start, review_data (JSONB), created_at

Enable Row Level Security on all tables with user-based access policies.

## Core Features to Build

### 1. Voice Recording Component
- Require microphone permissions
- 5-minute max recording limit
  - Visual recording indicator with timer
  - Auto-stop at 5 minutes
- M4A format 


### 2. AI Service Wrapper
Create abstracted functions for easy API switching:
- `transcribeAudio()` → OpenAI Whisper
- `generateInsights()` → OpenAI GPT-4 with this exact JSON response:
```json
{
  "sentiment": {"score": 0.8, "label": "positive"},
  "topics": ["career", "stress"], 
  "goals_mentioned": ["promotion"],
  "actionable_insights": ["Consider setting boundaries..."],
  "blind_spots": ["Avoiding discussion of..."]
}
```

### 3. Authentication Flow
- Clerk prebuilt UI with Google, Apple, email/password
- Auto-sync new users to Supabase users table
- Real-time subscription status sync

### 4. Core Screens
- Auth screen (Clerk prebuilt)
- Home: Record button + recent insights
- Journal: Entry history with AI insights
- Reviews: Weekly summaries (generated Sundays)
- Settings: Subscription management

### 5. Subscription System
- Freemium: 15 entries/month, basic insights
- Premium (€12.99/month): Unlimited entries [once per day], advanced insights, weekly reviews
- Stripe integration through Clerk
- Real-time subscription status updates

### 6. Notification System
- Firebase Cloud Messaging setup
- Push after 2 and 3 days of inactivity
- Weekly review ready notifications (Sundays)
- Personalized nudges based on last entry topics

### 7. Color Scheme Implementation
Apply exact colors throughout:
- Primary Purple: #c9a4e3
- Text: #4a5568  
- Background: #ffecd2
- Avatar: #fcf4f4
- Avatar Halo: #f4d03f

### 8. Avatar
- description: interactive gamiffied avatar interacting with user's reflections
- requirements: 
    - use the four different type of avatars as loading screens or motivation. "DayVibe" should appear under the avatar
    - when recording show the floating zen avatar too. this should be above the record button. 
    - the avatar types will be uses for later development post mvp


## Technical Requirements
- All features require internet connection (no offline mode)
- <5 second AI response time requirement
- Audio files uploaded to Supabase storage
- Environment variables managed through Replit Secrets
- Real-time data sync between Clerk and Supabase

## Weekly Review Logic
- Auto-generate every Sunday at 9 AM user local time
- Analyze past 7 days of entries
- Extract patterns, progress on goals, recurring themes
- Store in weekly_reviews table as JSONB

## Performance Targets
- App launch: <5 seconds
- Voice-to-insight pipeline: <10 seconds
- 95%+ transcription accuracy
- Real-time subscription status updates

## Build Priority
**Build Priority**: Authentication → Voice Recording → AI Pipeline → Insights Display → Subscription → Notifications → Reviews

Replit should implement these features in this exact order with the specified technical constraints and UI requirements.


## architecture
  dayvibe/
  ├── app/                    # Expo Router screens
  │   ├── (auth)/
  │   ├── (tabs)/
  │   └── _layout.tsx
  │
  ├── src/
  │   ├── services/          # API integrations
  │   │   ├── ai.ts
  │   │   ├── audio.ts
  │   │   ├── db.ts
  │   │   └── auth.ts
  │   │
  │   ├── components/        # Reusable UI
  │   │   ├── RecordButton.tsx
  │   │   └── InsightCard.tsx
  │   │
  │   ├── hooks/            # Custom hooks
  │   │   ├── useRecording.ts
  │   │   └── useInsights.ts
  │   │
  │   └── types.ts          # All TypeScript types
  │
  ├── app.json
  ├── package.json
  ├── .env
  └── README.md