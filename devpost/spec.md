---
doc: spec
status: approved
---

# DrillDeck — Technical Spec

## How This Works, In Plain Language
DrillDeck is a single Flutter app installed on an Android phone. Everything it needs lives inside the app itself, so it never touches the internet.

- **The questions** are 10 JSON files packed into the app (one per English test). When you open a test, the app reads that file from inside itself, just like reading a page in a book you're carrying.
- **The test session** is a small piece of code that tracks one attempt while it happens: which question you're on, what you've answered, how much time is left, and whether you're in Exam or Practice mode.
- **Your results** are saved on the phone with `shared_preferences`, a simple key-value notebook that Android keeps for the app. When a test finishes, its answers and score are written there. When you reopen the app, the Completed list reads them back.
- **The screens** (Home, English, Mode choice, Question card, Result, Review, Completed) just show what the session or saved results tell them.

Why this shape: there are no servers, no accounts and no database to set up. Ten bundled files plus one small saved notebook is the smallest thing that fully delivers "works anywhere, no internet".

## The Core Journey Through the System
PRD ref: `prd.md > The Core Journey`.

1. Phone is in airplane mode → open DrillDeck → **HomeScreen** draws the subject cards. Only English is active; tapping any other shows a "Coming soon" snackbar.
2. Tap English → **EnglishScreen** loads the saved results from `ResultsStore` to know which tests are done. It shows **New test** and **Completed**.
3. Tap New test → the app finds the lowest-numbered test (1–10) with no saved result. If all 10 are done → it shows the "all completed" message.
4. **ModeSheet** asks Exam or Practice → `QuestionBank` loads `assets/tests/test_NN.json` → a `TestSession` is created.
5. **QuestionScreen** shows one card at a time from the session.
   - Exam: a countdown computed from a fixed end time; previous/next and a question palette; Submit.
   - Practice: after selecting an answer, the card reveals right/wrong, the correct option and the explanation; Next.
6. Submit, timeout or last Practice question → the session computes the score → `ResultsStore` saves the result → **ResultScreen** shows the percentage.
   - Timeout: the score is frozen first; then "Finish untimed" lets the user answer the remaining questions. Those answers are stored as untimed and never change the score.
7. **ReviewScreen** lists each question with the user's answer, the correct answer and the explanation.
8. Back to English → the test now appears in **CompletedScreen** with its score; tapping it opens Result → Review.

## Stack
- **Flutter 3.44.8 (stable) / Dart**, already installed. Android target only. Docs: https://docs.flutter.dev
  Learner's choice: Android app built with Flutter.
- **Material 3** widgets (built in), themed with the DrillDeck palette.
- **shared_preferences**: on-device key-value storage for results. https://pub.dev/packages/shared_preferences
- **flutter_launcher_icons** (dev only): generates the Android launcher icons from `icon.png`. https://pub.dev/packages/flutter_launcher_icons
- **Bundled fonts** (Poppins for headings, Noto Sans for body), downloaded once from Google Fonts during the build and shipped in `assets/fonts/`. There's no runtime font fetching, which would break offline. https://fonts.google.com
- **State handling:** plain `setState` plus a `TestSession` class; no state-management package. This was recommended because the learner had no preference. Tradeoff accepted: the full version may want Provider/Riverpod later.
- *To verify early in the build:* that the latest `shared_preferences` and `flutter_launcher_icons` versions resolve cleanly with Flutter 3.44.8.

## Where It Runs and How Someone Tries It
- **Runtime:** an Android phone (learner's real device, USB debugging on). The minimum Android version is Flutter's default `minSdk`.
- **Run during development:** `flutter run` with the phone connected (`flutter devices` to confirm).
- **Demo video:** put the phone in airplane mode and record with Android's built-in screen recorder. Show: Home → English → New test → Exam mode (a few questions, then submit) → percentage → Review; then a Practice-mode card showing the instant explanation; then Completed.
- **Release build:** `flutter build apk --release` produces `build/app/outputs/flutter-apk/app-release.apk`. Attaching it to a GitHub Release lets others install it directly (optional; `6-ship` decides).
- **Required for submission:** the demo video + public GitHub repository. No deployment needed.

## Look and Feel
From `prd.md > Look and Feel` and the learner's `icon.png`.
- **Palette** (from the icon):
  - Brand blue `#0B5ED7` (app bar, primary buttons, active subject card)
  - Deep navy `#0A2A66` (headings, body text)
  - Yellow `#FFD43B` (highlights, progress bar, score accent, "Deck" in the wordmark)
  - Card white `#FFFFFF` on a soft background `#F3F6FB`
  - Correct `#1E9E5A` / wrong `#D93B30`, used only for answer feedback
  - "Coming soon" subjects: muted with a small label, still bright, but clearly inactive
- **Typography:** Poppins SemiBold/Bold for titles, scores and the wordmark (matches the icon's bold rounded type). Noto Sans for question text and options. Question text at least 18sp, options at least 16sp, so they're readable on a moving bus.
- **Cards:** white, rounded (16dp radius), soft shadow, generous padding. One question per screen. Options are large full-width tappable tiles labelled A–E.
- **Density:** spacious and calm. Primary actions sit at the bottom, within thumb reach for one-handed use.
- **Copy tone:** short, encouraging, plain English ("Nice work!", "Time's up — here's your score").

## Components

### HomeScreen
Subject cards: English (active), Quantitative Aptitude, Reasoning, Maths (each shows "Coming soon").
PRD ref: `prd.md > Subjects and navigation`.

### EnglishScreen
Two large cards: New test (showing "Test N of 10") and Completed (showing the count). It handles the first-use and all-done states.
PRD ref: `prd.md > Starting a test`, `prd.md > States and Boundaries`.

### ModeSheet
A bottom sheet: Exam (40 Qs · 50 min) or Practice (untimed, explanations as you go).
PRD ref: `prd.md > Starting a test`.

### QuestionBank
Loads and parses `assets/tests/test_NN.json` into `Question` objects. Read-only.
PRD ref: `prd.md > Question content`.

### TestSession
The in-memory state of one attempt: mode, questions, answers map, current index, end time (Exam), timedOut flag, untimed answers. It computes the score as correct ÷ 40 × 100, rounded to a whole percentage. Unanswered questions count as not correct.
PRD ref: `prd.md > Exam mode`, `prd.md > Practice mode`.

### QuestionScreen
Renders the current card. **Exam:** countdown timer driven by a 1-second ticker that compares against the fixed end time, so locking the phone doesn't pause it. Also has previous/next, a question palette (answered/unanswered) and Submit with a confirmation. At 0:00 it auto-submits. **Practice:** no timer; tapping an option locks it in and reveals feedback and the explanation, then Next. The back button asks "Leave test?", and leaving discards the attempt.
PRD ref: `prd.md > Exam mode`, `prd.md > Practice mode`, `prd.md > States and Boundaries`.

### ResultScreen
A large percentage, correct/total and the mode label. Buttons: Review, plus "Finish untimed" if the test timed out with unanswered questions.
PRD ref: `prd.md > Exam mode`, `prd.md > Completed tests`.

### ReviewScreen
A scrollable list: each question, the user's answer (marked green/red), the correct answer and the explanation. Untimed answers are marked "Not scored".
PRD ref: `prd.md > Exam mode`, `prd.md > Completed tests`.

### CompletedScreen
A list of finished tests with score, mode and date; tapping one opens ResultScreen. It has an empty state message.
PRD ref: `prd.md > Completed tests`, `prd.md > States and Boundaries`.

### ResultsStore
Wraps `shared_preferences`: `saveResult`, `loadAll`, `isCompleted(testId)`, `nextNewTestId()`. It also saves the untimed answers after timeout.
PRD ref: `prd.md > Completed tests`.

### Content validator (test)
`test/content_test.dart` loads all 10 JSON files and fails if: a test doesn't have exactly 40 questions; options ≠ 5; `answer` is out of range; any stem or explanation is empty; a question ID or stem is duplicated across tests; a `type` is outside the three allowed types.
PRD ref: `prd.md > Question content`.

## Data Model

**Question file**: `assets/tests/test_01.json` … `test_10.json` (bundled, read-only)
```json
{
  "id": 1,
  "title": "English Test 1",
  "durationMinutes": 50,
  "questions": [
    {
      "id": "t01q01",
      "type": "error_spotting | sentence_correction | fill_blank",
      "stem": "Read the sentence to find out whether there is any error...",
      "options": ["(A) ...", "(B) ...", "(C) ...", "(D) ...", "(E) No error"],
      "answer": 2,
      "explanation": "..."
    }
  ]
}
```
- **Mix per test:** about 14 error spotting, 13 sentence correction (with a "No correction required" option), 13 fill-in-the-blanks. Graded at IBPS/SBI Clerk–PO level, with a mix of easy, medium and hard.
- It never changes at runtime. It's updated only by editing the JSON and rebuilding.

**Saved result**: `shared_preferences` key `result_<testId>` → JSON string
```json
{ "testId": 3, "mode": "exam|practice", "scorePercent": 72, "correct": 29, "total": 40,
  "answers": {"t03q01": 2}, "untimedAnswers": {"t03q38": 1},
  "timedOut": true, "completedAt": "2026-10-26T09:14:00" }
```
- It's written when a test finishes, and updated only to add untimed answers.
- It persists across app restarts. It's lost only if app data is cleared or the app is uninstalled.

**In-progress attempt**: lives in `TestSession` memory only. Leaving the test, or the app being killed, discards it, and the test stays New (`prd.md > States and Boundaries`).

## File Structure
```
DrillDeck/
├── lib/
│   ├── main.dart                 # app entry, MaterialApp, theme, routes
│   ├── theme.dart                # palette, typography, card styles
│   ├── models/
│   │   ├── question.dart         # Question + TestBank parsing from JSON
│   │   └── test_result.dart      # saved result model (to/from JSON)
│   ├── services/
│   │   ├── question_bank.dart    # loads assets/tests/*.json
│   │   └── results_store.dart    # shared_preferences wrapper
│   ├── session/
│   │   └── test_session.dart     # live attempt state, timer end, scoring
│   ├── screens/
│   │   ├── home_screen.dart
│   │   ├── english_screen.dart
│   │   ├── question_screen.dart  # exam + practice card flow
│   │   ├── result_screen.dart
│   │   ├── review_screen.dart
│   │   └── completed_screen.dart
│   └── widgets/
│       ├── mode_sheet.dart
│       ├── option_tile.dart      # A–E answer tile (neutral/selected/correct/wrong)
│       ├── countdown_timer.dart
│       └── question_palette.dart
├── assets/
│   ├── tests/test_01.json … test_10.json   # 400 questions
│   └── fonts/                    # Poppins, Noto Sans (.ttf + OFL licences)
├── test/
│   ├── content_test.dart         # validates all question files
│   └── session_test.dart         # scoring, timeout, untimed-not-scored
├── android/                      # generated Flutter Android project
├── icon.png                      # learner's app icon (launcher icon source)
├── pubspec.yaml                  # deps, assets, fonts, launcher icon config
├── README.md
└── devpost/                      # Devpost learning workspace
```

## External Services and Dependencies
None at runtime: no APIs, no network, no keys, no cost.
Build-time only: pub.dev packages (`shared_preferences`, `flutter_launcher_icons`) and the Google Fonts downloads (both OFL-licensed).

## Important Failure Modes
- **A question file is malformed or missing** → caught before shipping by `content_test.dart`. At runtime, the app shows "This test couldn't be loaded" and returns to English instead of crashing.
- **A wrong answer key or bad explanation in the content** → the automated check can't catch this. The learner's spot-check covers it, plus the AI's self-review pass while writing each test.
- **Timer drift or phone lock during Exam** → the time is computed from a fixed end timestamp, not by counting ticks, so the remaining time is always correct after unlocking. If the time ran out while locked, it auto-submits on return.
- **Icon has baked-in rounded corners and background** → it may look boxed inside Android's adaptive icon mask. Check on the device; if needed, crop or use the blue as the adaptive background.

## What Was Simplified and Why
- **shared_preferences JSON** instead of a database: 10 results don't need queries. The full version (unlimited generated tests) might move to SQLite.
- **Fixed bundled tests** instead of generated questions: proves the experience. Generation is the full version's job (`scope.md > Later`).
- **In-progress attempts aren't saved**: keeps the session logic simple. Resuming would mean saving the session on every answer.
- **No retake**: per `prd.md > Deferred From the POC`.
- **No state-management package**: the app is small enough for `setState`.

## Decisions and Open Issues
**Learner decisions**
- Android app built with Flutter (`2-scope`).
- Test and record on a real Android phone.
- Use the existing `icon.png` as the app icon and the source of the palette.
- No state-management preference → accepted the recommended plain `setState` + `TestSession`.

**Implementation details derived from these**
- Bundled JSON question files; shared_preferences for results; bundled fonts; an end-timestamp timer; 5 options per question; the question-type mix above.

**Learner's uncertainty: question quality**
Clarified with a three-layer approach: (1) a strict schema in IBPS/SBI style with a written explanation for every answer; (2) `content_test.dart` enforces structure (40 per test, 5 options, a valid answer index, non-empty explanation, no duplicates); (3) **the learner spot-checks at least 5 questions per test** (50 total, across all three types) before content is marked done. Evidence in the build: the content test passes, and the learner confirms the spot-check.

**Open**
- None blocking the build. `prd.md > Open Questions` had none blocking. Whether to publish the APK on a GitHub Release is decided in `6-ship`.
