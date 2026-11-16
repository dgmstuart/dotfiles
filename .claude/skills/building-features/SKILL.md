---
name: building-features
description: Use when implementing a feature or user-facing change that will span more than one commit, or when planning the commits for a feature branch - including work on claude/* branches and in worktrees
---

# Building features outside-in

Each behaviour commit is one outside-in TDD cycle that adds one scenario to the feature's system spec. The system spec grows commit by commit, so a reviewer reads each commit as "this is what the user can now do, and this is how".

**REQUIRED SUB-SKILL:** superpowers:test-driven-development for each red/green step.

## 1. Plan the slices

Before writing code, list the commits:
- **Behaviour commits:** one system-spec scenario name each, e.g. `when the guest account holder follows the emailed link / shows the sign-up form, filled in from their latest booking`
- **Refactor commits** you already know you need, placed before the commit that needs them

Order the behaviour commits so that slices where end users act for themselves come before slices where admins act for them (dockadmin bookings, lightweight bookings). Cover every admin entry point that creates the same kind of record, e.g. lightweight bookings as well as dockadmin guest bookings.

Get the user's approval on the list. Then work through it without stopping for review between commits.

Every behaviour commit is a vertical slice that the user can see. Logic (eligibility rules, calculations, queries) goes into the commit whose scenario needs it. A model or service with nothing using it yet is never a commit on its own.

## 2. One cycle per behaviour commit

1. Add the scenario to the feature's system spec (`spec/system/...`). Run it and watch it fail for the right reason.
2. Follow the failure down. For logic in models, services, forms and mailers, write a failing unit spec, make it pass, and repeat.
3. Controllers and views are covered by the system scenario alone.
4. Make the scenario pass. Run the feature's specs and `bin/rubocop` on the changed files.
5. Commit the scenario together with everything it drove out, following writing-commit-messages. If the slice accepts a known trade-off (e.g. an unauthenticated form can change a guest's language), state it in that commit's message, not only in the plan. Start the next cycle.

Sad paths a user can see (expired link, validation error) are scenarios. Edge cases a user can't see stay in unit specs.

## 3. Refactoring mid-cycle

For a RuboCop metrics offence, follow resolving-metrics-offences, then continue the cycle.

For any other refactor the next change needs (code that's awkward to extend):
1. `git stash push --include-untracked`
2. Refactor on the clean tree, with the existing specs green. Commit it as a separate refactor commit.
3. `git stash pop`, then continue the cycle on top.

To change a commit that's already on the branch, use fixing-up-earlier-commits.

## Stop and ask when

- A slice turns out to need splitting or reordering
- A design question comes up that the plan didn't settle
- A refactor is bigger than a small, mechanical extraction

## Never

- Write the code first and add specs or split into commits afterwards
- Commit behaviour that isn't in the system spec yet
- Make a prep commit of unused logic "for the next slice"
- Mix a refactor into a behaviour commit
