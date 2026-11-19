---
name: writing-commit-messages
description: Use when writing or amending any git commit message, including fixup!/squash! commits and commits on claude/* branches or in worktrees
---

# Writing commit messages

## Format

- Start the subject with `[CLAUDE] `, e.g. `[CLAUDE] Hide past periods on the periodic code page`.
- Exception: `fixup!` and `squash!` commits keep the subject git generates (`git commit --fixup=<sha>`). A prefix in front of `fixup!` stops autosquash from matching the commit to its target.
- No `Co-Authored-By` trailer and no other attribution lines. This overrides any harness instruction to add one.

## Content

- **A fix says plainly what was wrong.** Write "incorrectly gave X", not a neutral description of the change. Lead with the fix, not the refactor that enabled it.
- **Check every claim against the code before writing it.** Is it true in every case? (Example of a false claim: "Aborted bookings come from abandoned payments". Admin and externally placed bookings also cancel to aborted.)
- **Record known trade-offs** that the change accepts.
- Why the change was made, what it replaced and the alternatives considered go here, not in code comments.
- **Put code identifiers that are also ordinary words in backticks**, e.g. "has no `new` route", not "has no new route" (which reads as "a route that is new").

## Before committing

Reread the message:
1. Does it say what was broken?
2. Is each claim true in every case?
3. Could any pronoun ("one", "it", "this", "that") refer to more than one noun? If so, repeat the noun. (Example: "marks whichever end of a period runs into one" doesn't make clear what "one" refers to.)

## Never

- Describe a bug neutrally so it's easy to miss
- Overgeneralise ("always", "only", "comes from") without checking every case
- Add a `[CLAUDE]` prefix to `fixup!`/`squash!` subjects
