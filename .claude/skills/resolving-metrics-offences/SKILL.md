---
name: resolving-metrics-offences
description: Use when RuboCop reports a Metrics offence (AbcSize, MethodLength, ClassLength, CyclomaticComplexity, PerceivedComplexity, BlockNesting, ParameterLists), usually after a change pushes existing code over the limit
---

# Resolving metrics offences

A metrics offence usually means the code has taken on another responsibility. Moving lines into a private method hides the offence but leaves the extra responsibility where it is. Look for an object to extract instead, and do it in a refactor commit before the change.

## Steps

1. Name the responsibility that made the code grow, e.g. "works out which guests are eligible" or "builds the account from the form". If you can't name one, extracting a private method is fine. Skip to step 5.
2. Stash the change: `git stash push --include-untracked`
3. Extract that responsibility into its own object: a service object in `app/services`, or a form, query or model method if that fits better. Design its interface for this job; don't copy a neighbouring service's shape.
4. Move or add unit specs for the new object, run the existing specs, and make sure they're green. Commit it as a refactor commit with no behaviour change.
5. `git stash pop` and make the change, now in the new object where it belongs.

If you're in the middle of building-features-outside-in, this is its "refactoring mid-cycle" step.

## Stop and ask when

- The extraction touches many callers or changes a public interface
- You can't tell which responsibility to extract

## Never

- Add `rubocop:disable`, raise a `Max`, or add to `.rubocop_todo.yml` without asking
- Extract a private method just to get under the limit when a responsibility can be named
- Mix the extraction and the behaviour change in one commit
