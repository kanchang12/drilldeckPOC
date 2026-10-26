---
doc: checklist
status: approved
---

# Build Checklist

Build mode: fast

## Slices

- [x] **1. You can open DrillDeck, pick English, and practise Test 1 card by card with instant explanations**
  Becomes usable: The app runs on the phone fully offline. Home shows subjects (others say "Coming soon") → English → New test → Practice mode → 40 Test 1 cards; each answer reveals right/wrong, the correct option and the explanation → percentage score at the end.
  Why now: This is the kernel (premium offline practice with real explanations), end to end. It also puts the first 40 real questions and the branded look in front of the learner early, while their feedback can still shape the other 360 questions and the styling.
  PRD ref: `prd.md > The Core Journey` (steps 1–4, 6), `prd.md > Subjects and navigation`, `prd.md > Practice mode`, `prd.md > Question content`
  Spec ref: `spec.md > Stack`, `spec.md > Look and Feel`, `spec.md > HomeScreen`, `spec.md > EnglishScreen`, `spec.md > ModeSheet`, `spec.md > QuestionBank`, `spec.md > TestSession`, `spec.md > QuestionScreen`, `spec.md > ResultScreen`, `spec.md > Content validator (test)`, `spec.md > Data Model`, `spec.md > File Structure`
  Build: Scaffold the Flutter Android project in the repo root; add `shared_preferences`, bundled Poppins/Noto Sans fonts and the theme from the icon palette; write `assets/tests/test_01.json` (40 questions, 14/13/13 type mix, 5 options, explanations); add the models, QuestionBank, TestSession (practice flow + scoring), and the Home, English, ModeSheet (Exam option visible but labelled for the next slice), QuestionScreen (practice) and ResultScreen; add `content_test.dart` and the scoring tests in `session_test.dart`.
  Verify (mechanical): `flutter analyze` clean; `flutter test` passes (content test on test_01, practice scoring); `flutter build apk --debug` succeeds.
  Learner check: With the phone in airplane mode, open DrillDeck, tap English → New test → Practice, answer several questions (some wrong on purpose), and read the explanations. Do the look, the readability on the bus and the question quality feel right?
  Commit: `Add practice mode with English Test 1`

- [ ] **2. You can take Test 1 as a real timed exam and review it**
  Becomes usable: Exam mode: 50:00 countdown, previous/next, question palette, change answers, Submit with confirmation → percentage → Review with answers and explanations. On timeout: auto-submit → score → "Finish untimed" for the remaining questions, marked "Not scored" in the review.
  Why now: Exam mode is the second half of the core loop and has the trickiest logic (timer from a fixed end time, timeout, untimed answers that don't count). It's built on top of the working session from slice 1.
  PRD ref: `prd.md > Exam mode`, `prd.md > The Core Journey` (step 5)
  Spec ref: `spec.md > TestSession`, `spec.md > QuestionScreen`, `spec.md > ResultScreen`, `spec.md > ReviewScreen`, `spec.md > Important Failure Modes`
  Build: Extend TestSession with exam mode, end time, timeout and untimed answers; add the countdown timer and question palette widgets, the exam UI in QuestionScreen, auto-submit at 0:00 (including on return from a locked phone), ReviewScreen, and the "Finish untimed" flow.
  Verify (mechanical): `flutter analyze` clean; `flutter test` passes with new session tests (submit scoring, timeout freezes the score, untimed answers excluded, unanswered count as wrong); debug APK builds.
  Learner check: Start Test 1 in Exam mode, answer a few, jump around with the palette, submit, and read the review. (Optional: a debug-only short timer to see timeout behaviour quickly.)
  Commit: `Add timed exam mode, review, and timeout flow`

- [ ] **3. Your finished tests are remembered and the next new test opens**
  Becomes usable: Finished tests (either mode) are saved on the phone and listed under Completed with score, mode and date; tapping one opens Result → Review. New test opens the next untaken test. Includes first-use and all-done messages, the "Leave test?" confirmation that discards an attempt, and a friendly error if a test file can't load.
  Why now: Persistence turns single attempts into a product you come back to. It depends on the result shape from slices 1–2.
  PRD ref: `prd.md > Completed tests`, `prd.md > Starting a test`, `prd.md > States and Boundaries`
  Spec ref: `spec.md > ResultsStore`, `spec.md > CompletedScreen`, `spec.md > EnglishScreen`, `spec.md > Data Model`, `spec.md > Important Failure Modes`
  Build: Add the TestResult model and ResultsStore; save on finish (and on untimed completion); CompletedScreen; next-new-test logic; empty and all-done states; the back-button leave confirmation; the load-error fallback.
  Verify (mechanical): `flutter analyze` clean; `flutter test` passes with ResultsStore tests (mock shared_preferences: save/load, next test id, all done); debug APK builds.
  Learner check: Finish a test, fully close the app, reopen it, and confirm it's under Completed with its score. Then tap New test and confirm it opens Test 2 (or the all-done message, once the content exists).
  Commit: `Save results and add Completed tests`

- [ ] **4. All 10 English tests are in the app and pass the quality checks**
  Becomes usable: Tests 2–10 are available: 400 questions in total, each with 5 options and an explanation, in IBPS/SBI style.
  Why now: The slice 1 feedback on Test 1 shapes the tone, difficulty and format of the other 360 questions, so this comes after that feedback and after the app around the content is stable.
  PRD ref: `prd.md > Question content`
  Spec ref: `spec.md > Data Model`, `spec.md > Content validator (test)`, `spec.md > Decisions and Open Issues`
  Build: Write `test_02.json` to `test_10.json` with the agreed type mix and difficulty spread, self-review each test's answer keys, and extend the content test across all 10 files (no duplicate IDs or stems across tests).
  Verify (mechanical): `flutter test` passes with content checks for all 10 files; debug APK builds.
  Learner check: Spot-check at least 5 questions per test (50 in total, across all three types) in Practice mode or the JSON, and report any wrong answer key or unclear explanation.
  Commit: `Add English Tests 2–10`

- [ ] **5. DrillDeck installs with its own icon as a release APK**
  Becomes usable: The launcher icon comes from `icon.png`, the app is named "DrillDeck", and a release APK installs and runs offline on the phone. The README explains how to run and build it.
  Why now: Packaging is the last step before the demo recording and depends on everything else being in place.
  PRD ref: `prd.md > What We're Building`
  Spec ref: `spec.md > Where It Runs and How Someone Tries It`, `spec.md > Important Failure Modes` (icon mask)
  Build: Configure `flutter_launcher_icons` (with an adaptive icon background in brand blue), set the app label, build the release APK, and write README.md (what it is, running, building, offline note).
  Verify (mechanical): `flutter build apk --release` succeeds; the generated launcher icon files exist; `flutter test` still passes.
  Learner check: Install the release APK, check the icon on your home screen, and run one full test in airplane mode.
  Commit: `Add launcher icon, release build, and README`

## Hands-on Checkpoints

- [ ] Early usable behavior explored — after slice 1 (look, readability, Test 1 question quality) on the real phone
- [ ] Final kick-the-tires exploration and feedback completed

## Final Review

- [ ] Final review complete — feedback resolved and learner confirms ready to ship

## Code Tour and App Map

- [ ] Learning activity complete — guided route, focused alternative, prior practice connected, or brief recap
- [ ] Optional edit and transfer reflection addressed — offered/declined/already covered/not applicable as appropriate
- [ ] `devpost/app-map.html` generated from finished code, checked, and shown, including a project-grounded practice to reuse

Activity and evidence:
Route and stops:
Edit outcome:
Reflection:
Activity mode:

## Revisions
- Added `lib/widgets/question_card.dart` (question card, highlighted-stem renderer, explanation box) — shared by practice cards and the upcoming review screen; not listed in the spec file tree.
- Moved launcher icon + "DrillDeck" app label from slice 5 into slice 1 — learner asked to see their icon at the first checkpoint. The icon's white corners were filled blue (`assets/icon/icon_square.png`) and an adaptive foreground made (`assets/icon/icon_foreground.png`) so Android's icon mask shows no white box.
