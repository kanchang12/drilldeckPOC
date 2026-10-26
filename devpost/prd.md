---
doc: prd
status: approved
---

# DrillDeck — Product Requirements

An offline Android app for Indian bank and government exam aspirants (23–32, small towns and villages, studying on crowded buses) to practise the English section with real bank-exam-style tests.
Source: `scope.md > Who It's For`, `scope.md > The Unique Kernel`.

## The Core Journey
Source: `scope.md > The Core Loop`, `scope.md > What "Working" Looks Like`.

1. With the phone in airplane mode, the aspirant opens DrillDeck.
2. **Home** shows the subjects. English is active. Every other subject shows "Coming soon" when tapped.
3. They tap **English** and see two options: **New test** and **Completed**.
4. They tap **New test**. The next test they haven't taken opens, and they choose **Exam mode** or **Practice mode**.
5. **Exam mode:** 40 questions with a 50-minute countdown. One question per card. No answers are shown during the test.
   - They finish (or submit early) → they see their **percentage score** → they review every question with the correct answer and explanation.
   - If time runs out → they see their percentage score, then can go through the unanswered questions **without a timer**. Those answers don't count toward the score.
6. **Practice mode:** the same 40-question test, untimed. After each answer the card shows whether it was right, the correct answer and the explanation. At the end they see their percentage score.
7. The test is now listed under **Completed**. Tapping it shows the score and the full review.
8. They go back and start the next new test.

## Screens and Layout
- **Home (Subjects):** a list of subject cards. English is active; the other subjects (Maths, Quants, Logical Reasoning) show "Coming soon".
- **English:** two clear options, **New test** and **Completed**.
- **Mode choice:** shown after tapping New test. Exam (40 Qs · 50 min) or Practice (untimed, explanations as you go).
- **Question card:** one question per screen, with its options. Exam mode also shows the countdown timer and the question number (e.g. 12 / 40).
- **Result:** the percentage score for the test, plus a way into the review.
- **Review:** each question with the learner's answer, the correct answer and the explanation.
- **Completed list:** the tests already taken, each with its score. Tapping one opens Result/Review.

## Look and Feel
Source: `scope.md > Inspiration & Identity`.
- Bright colours on the cards, but **readable and professional**. It should feel premium, not childish.
- Uncluttered, one thing per screen, easy to use one-handed on a crowded bus.
- *Assumption (learner delegated the details):* white or very light question cards with dark, high-contrast text. Bright accent colours on subject cards, buttons and progress. A clean, modern sans-serif font that's large enough to read on a moving bus. Clear green/red only for correct and wrong answers.

## Features and Behavior

### Subjects and navigation
- [ ] Home lists the subjects; only English opens.
- [ ] Tapping any other subject shows "Coming soon" and nothing else happens.
- [ ] English shows New test and Completed.

### Starting a test
- [ ] New test opens the next of the 10 English tests that hasn't been taken yet.
- [ ] The aspirant chooses Exam or Practice mode before the first question.

### Exam mode
- [ ] 40 questions, a visible 50:00 countdown, one question per card.
- [ ] No correctness or explanation is shown before the test ends.
- [ ] On submit: the percentage score is shown, then the review with the correct answer and explanation for each question.
- [ ] On timeout: the percentage score is shown (unanswered questions count as not correct). Then the remaining questions can be answered untimed, and these do **not** change the score.

### Practice mode
- [ ] Untimed: no clock is shown.
- [ ] After each answer: right/wrong indication, the correct answer and the explanation, then on to the next card.
- [ ] At the end: the percentage score.

### Completed tests
- [ ] Every finished test (either mode) appears under Completed with its score.
- [ ] Tapping one shows the score and full review.
- [ ] Completed tests and scores are still there after closing and reopening the app.

### Question content
- [ ] 10 English tests × 40 questions = **400 questions**, each with 4–5 options, one correct answer and a short explanation.
- [ ] A mix of the three types in scope: grammar error spotting, sentence correction and fill-in-the-blanks, in IBPS/SBI exam style.
- Drafted by the AI during the build; the learner spot-checks them for accuracy.

## States and Boundaries
- **Offline always:** every screen and every test works with no internet, from the first launch onward.
- **First use:** Completed is empty and shows a short message such as "No tests completed yet". New test opens Test 1.
- **All 10 done:** New test shows a friendly "You've completed all English tests" message and points to Completed.
- **Persistence:** completed tests, their answers and their scores are saved on the phone.
- *Assumption:* **leaving mid-test** (back button or app closed) discards that attempt, after a "Leave test?" confirmation. The test stays New.
- *Assumption:* in Exam mode, the aspirant can move back and forward between questions and change answers before submitting, as in the real exam.

## Product Decisions
- Home shows all subjects, with only English live: this signals the full product while keeping the POC to English.
- Each test follows the standard bank-exam format of 40 questions in 50 minutes, for realism.
- Two modes: Exam (timed, explanations at the end) and Practice (untimed, explanation after each card). Learning and exam realism are kept separate.
- On timeout: show the score, then allow untimed completion that doesn't count. The score stays honest and nothing is wasted.
- Tapping a completed test shows its score and review.
- *Assumption (delegated):* the mode is chosen after tapping New test, and Practice-mode tests also count as Completed with a score, labelled "Practice".

## What We're Building
- The Home, English, Mode choice, Question card, Result, Review and Completed screens described above.
- Exam mode and Practice mode with the behaviours above.
- 10 complete English tests (400 questions with explanations), bundled in the app.
- Completed tests and scores saved on the phone.
- Fully offline.

## Deferred From the POC
- Maths, Quants and Logical Reasoning content: these show "Coming soon" only.
- Template-generated questions and unlimited mocks: the POC uses fixed tests.
- 5 free tests and the one-time ₹250 unlock: no payments in this repo.
- Retaking a completed test: Completed shows the score and review only.

## Possible Later Enhancements
- Sectional analytics (accuracy by question type).
- Bookmarking hard questions.
- Hindi-medium explanations.

## Non-Goals
- No accounts, login or cloud sync, because everything is on the device.
- No internet use at all.
- No ads.

## Open Questions
- None blocking `4-spec`. The assumptions above (leaving mid-test, exam navigation, where the mode is chosen, styling details) take effect unless the learner changes them in review.
