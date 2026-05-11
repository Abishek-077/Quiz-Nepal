# Quiz Nepal

Quiz Nepal is a Nepal-focused quiz battle MVP for people preparing for driving license written exams, Loksewa GK, Nepal GK, Computer/IT GK, and quick Fun/IQ practice. The product is designed around value-first conversion: users choose a category, start a 10-question quiz quickly, see immediate explanations, review mistakes, and return for a healthy daily streak.

## App description

The MVP turns boring PDF-style preparation into a clean, mobile-first practice loop:

1. Open the app and see a simple welcome screen.
2. Choose an exam category.
3. Take a 10-question multiple-choice quiz.
4. Learn from instant correct/wrong feedback and explanations.
5. Finish with score, coins, streak, weak-topic review, leaderboard, and share placeholders.

Copy uses simple Nepali-English cues such as “Wrong answer? Learn why,” “Complete today’s quiz and keep your streak,” and “Beat your previous score.”

## Setup instructions

```bash
npm install
npm run typecheck
npm start
```

Then open the Expo app on a simulator, Android emulator, iOS simulator, or physical device.

## Folder structure

```text
.
├── App.tsx                         # Small state-machine navigation shell
├── app.json                        # Expo app configuration and deep-link scheme
├── package.json                    # Expo/React Native/TypeScript scripts and dependencies
├── src
│   ├── components                  # Reusable UI components
│   │   ├── AdPlaceholder.tsx
│   │   ├── PrimaryButton.tsx
│   │   └── ProgressBar.tsx
│   ├── data                        # Local MVP content and mock admin-style data
│   │   ├── categories.ts
│   │   ├── leaderboard.ts
│   │   └── questions.ts
│   ├── screens                     # Required MVP screens
│   │   ├── CategoryScreen.tsx
│   │   ├── LeaderboardScreen.tsx
│   │   ├── ProfileScreen.tsx
│   │   ├── QuizScreen.tsx
│   │   ├── ResultScreen.tsx
│   │   └── WelcomeScreen.tsx
│   ├── types
│   │   └── quiz.ts
│   └── utils
│       └── progress.ts             # Local progress, streak, coins, weak topics
└── PRODUCT_STRATEGY.md             # Product, funnel, retention, monetization, content strategy
```

## Current features

- Splash/welcome experience with streak and coins.
- Category selection for Driving License, Loksewa GK, Nepal GK, Computer/IT GK, and Fun/IQ Quiz.
- 50 local sample questions: at least 10 per category.
- 10-question quiz flow with large answer buttons and progress bar.
- Immediate answer feedback, correct answer, explanation, topic, and difficulty.
- Wrong answers marked for review.
- Score calculation and friendly rank-style result message.
- Local progress persistence via a small storage adapter for web/local MVP state.
- Daily streak, coins, completed quiz count, best scores, weak topics, and review list.
- Mock leaderboard.
- Share score and share question card placeholders using native share.
- AdMob-ready placeholder components for banner, interstitial, and rewarded ad use cases.
- Premium upsell placeholder that is intentionally non-aggressive.
- Deep-link-ready route slugs and Expo scheme (`quiznepal://`).

## Future roadmap

- Add production AdMob integration after retention and content quality are validated.
- Add premium subscription: no ads, full mock tests, detailed AI explanations, exam-specific question packs, and progress analytics.
- Add backend sync for accounts, real leaderboards, campaign links, and remote question updates.
- Add admin CMS for question review, difficulty tagging, versioning, and localization.
- Add mock tests that mirror official exam patterns.
- Add share-image generation for “Can you answer this?” viral cards.
- Add push reminders that are opt-in, useful, and never manipulative.
