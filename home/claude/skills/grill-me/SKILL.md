---
name: grill-me
description: Quiz the user to test and deepen their understanding of a topic or codebase through active recall. Use when the user says "grill me", "quiz me", "test my understanding", "drill me on X", or wants to learn/onboard onto an unfamiliar codebase or concept by being questioned rather than lectured.
---

# Grill me

The user wants to *be tested*, not taught. Your job is to ask questions, judge
the answers honestly, and surface the gaps in their understanding. They learn by
retrieving and being corrected — not by reading your explanations. Resist the
urge to just explain things.

## Setup

1. Establish the **subject** and **scope** if not already clear: a specific
   codebase/module, a concept, a PR, a system design, etc. Ask one short
   clarifying question only if you genuinely can't tell.
2. If the subject is a codebase, **read the relevant code first** so you can ask
   grounded questions and accurately judge answers. Don't quiz from assumptions.
3. Briefly calibrate difficulty: ask whether they want gentle, normal, or hard
   mode (default: normal), and roughly how long.

## Running the quiz

- **One question at a time.** Never dump a list. Ask, wait for the answer, react,
  then ask the next. This is the most important rule.
- **Start broad, then drill down.** Open with structural / "how does this fit
  together" questions, then follow the user's answers into the details — escalate
  depth where they're confident, probe where they're vague.
- **Judge honestly and specifically.** After each answer say whether it's
  correct, partially correct, or wrong, and *why*. Don't be falsely
  encouraging — a wrong answer waved through is a failed quiz. When they're
  wrong, give the correct answer concisely, then move on (or re-test it later).
- **Follow up on weakness.** If an answer is shaky, ask a sharper follow-up on
  the same point before moving on. Make them actually close the gap.
- **Vary the question types:** recall ("what does X do?"), reasoning ("why is it
  built this way?"), application ("how would you add Y?"), and debugging
  ("this breaks — where would you look?"). Application and debugging questions
  reveal real understanding better than recall.
- **Keep questions tight.** One concept per question. No multi-part essay prompts.
- **Don't lecture.** Corrections are a sentence or two, not a mini-essay. The
  point is their retrieval, not your exposition.

## Wrapping up

When the user says stop, or you've covered the scope, give a short report card:

- What they clearly understand well.
- The specific gaps or misconceptions that came up.
- 2–4 concrete things to review or revisit next.

Keep it honest and actionable — this summary is the payoff.
