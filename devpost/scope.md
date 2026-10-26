---
doc: scope
status: approved
---

# DrillDeck

Offline, premium-feeling English practice for Indian bank and government exam aspirants who study on buses and trains with poor internet.

## The Unique Kernel
Premium exam practice that works anywhere, any time, with no internet — built for aspirants the big apps don't serve well. In the full product: 5 free tests, then pay once (₹250) and practise as much as you want. In this POC, the kernel is proven by the experience alone: fully offline, bright and premium, real exam-style questions with instant explanations.

## Who It's For
Indian students, college students, and first-job workers (roughly 23–32), boys and girls, preparing for bank and government exams — especially from villages and small towns far from coaching centres, with tight budgets. Picture them standing on a crowded bus with a phone in hand and no signal.
Today they use apps like Testbook or Adda247. In the learner's words: "the existing ones are good, but not good for poor money constraint people far away from main centers, villagers."

## The Core Loop
Open DrillDeck → pick an English test → answer one question per card → see the correct answer and explanation instantly → move to the next → see the score at the end of the test → pick another.
They come back because it's always available — no signal, no data cost — and it feels good to use.

## Inspiration & Identity
Bright screen, bright cards, uncluttered. Easy to practise on a crowded bus. Looks and feels premium despite being built for budget users.

## Why This Matters to the Learner
Wants a ready-to-ship app that serves aspirants priced out or left out by existing apps. The hackathon POC is the English slice of a real product they intend to take further.

## What "Working" Looks Like
In a ~1-minute demo: phone in airplane mode → open DrillDeck → choose one of the 10 English tests → answer questions card by card, seeing the right answer and explanation after each → finish and see the score. The "oh, that's cool" beat: it all works with no internet and still looks premium.

## The POC Boundary
- 10 ready-to-use English tests: grammar error spotting, sentence correction, fill-in-the-blanks.
- Fully offline.
- One question per screen, instant answer + explanation, score at the end of each test.
- Bright, uncluttered card design.
"For the hackathon 10 English ready-to-use tests, nothing else."

## Later
(Full version — not in this repo.)
- Maths, Quants, and Logical Reasoning sections.
- Template-generated questions for unlimited complex, real-world mock tests.
- 5 free tests per section, then a one-time ₹250 unlock.

## Explicitly Cut
- Payments / unlock flow — belongs to the full version; not needed to prove the offline practice experience.
- Question generation — the POC uses fixed, ready-made questions.
- Non-English sections — English alone proves the core loop.

## Open for Later Phases
- Platform: learner chose an **Android app built with Flutter**. `4-spec` works out the details.
- Where the question content comes from and how many questions per test — decide in `3-prd`.
