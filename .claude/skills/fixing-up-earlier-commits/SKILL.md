---
name: fixing-up-earlier-commits
description: Use when a change belongs in an earlier commit of an existing branch (including the user's own branch), or when asked to autosquash fixup!/squash! commits - especially when `git rebase -i` seems unavailable because there is no interactive terminal
---

# Fixing up earlier commits

`git rebase -i` works without a terminal: the todo-list editor is the only interactive part, and `GIT_SEQUENCE_EDITOR` replaces it with a command. Always add `</dev/null` and set `GIT_EDITOR=true` so nothing waits for input.

Never rebase in the user's checkout. Build a rewritten copy of their branch in your own worktree, then apply it to their branch in a single step at the end, or hand it over. The session can be moved to the background at any moment, and this way the user's checkout is never left mid-rebase.

## Setup

1. Record the user's branch:
   ```bash
   BRANCH=<user's branch>; ORIG=$(git rev-parse $BRANCH)
   USER_CHECKOUT=<path that has $BRANCH checked out, from `git worktree list`; empty if none>
   ```
2. Work in your own worktree (EnterWorktree, or `git worktree add .claude/worktrees/<topic>`). Check it's clean and not mid-rebase (see Checks), then:
   ```bash
   git switch -C claude/<topic> $ORIG
   ```

## Adding a fixup

Write the change against the code as it is at the target commit. Don't commit at the tip and move it back: that replays a diff onto code it wasn't written against.

1. Find the commit that introduced the problem (`git log -S`, `git blame`): `TARGET=<sha>`.
2. `ANCHOR=$TARGET`, or, if `fixup!`/`squash!` commits for TARGET already sit directly after it, the last of those.
3. Stop the rebase at ANCHOR (it is always the first todo line):
   ```bash
   GIT_SEQUENCE_EDITOR="sed -i '1s/^pick/edit/'" git rebase -i --no-autosquash $ANCHOR^ </dev/null
   ```
4. Make the change, then commit it, choosing the type:
   - **`fixup!` (preferred):** correcting a mistake, or where TARGET's message still describes the commit. `git commit --fixup=$TARGET`
   - **`squash!`:** only when there's genuinely new information that belongs in TARGET's message. `git commito add to the message>"`.Pass `-m`, because without it git opens an editor.
5. `GIT_EDITOR=true git reba
6. Verify: `git log --oneline` shows the new commit directly after TARGET (or its
existing fixups), and `git de fix.

On a conflict in step 5, asst:
- If it's trivial to resolve in a way that clearly integrates the original intent of
the code with the new change
- If there's any ambiguity, ask the user how the conflict should be resolved, showing
up to 50 lines of the diff.

After resolving, `git add` t. To give up, run `git rebase
--abort`.

## Autosquash: only when the user explicitly asks

Otherwise, `fixup!`/`squash!` commits stay as separate commits.

1. Check that every `fixup!`/`squash!` sits directly after its target, because
autosquash silently moves ananything, fix the placement
or ask:
   ```bash
   git log --reverse --format=%s $BASE..HEAD | awk '/^(fixup|squash)! /{t=$0;
sub(/^(fixup|squash)! /,"",tCED: " $0; next} {last=$0}'
   ```
   `BASE` is the branch's reFor a stacked branch, ask if
it's unclear.
2. `GIT_SEQUENCE_EDITOR=: GI-autosquash $BASE </dev/null`
3. Verify: `git diff $ORIG HEAD` is empty and no `fixup!`/`squash!` subjects remain.
Each `squash!` commit's `-m`et's message.

## Applying to the user's br

Apply it yourself only if al
- This is a foreground session (you have not been told you are running as a background
job).
- `git rev-parse $BRANCH` still equals `$ORIG`.
- If `USER_CHECKOUT` is set,run them with `git -C
"$USER_CHECKOUT"`).

Then:
```bash
git -C "$USER_CHECKOUT" reset --keep claude/<topic>   # if $BRANCH is checked out
git branch -f $BRANCH claudef it isn't checked out
anywhere
```

Otherwise, leave `claude/<to
- why you didn't apply it (backgrounded, branch moved, or checkout dirty or
mid-rebase)
- `git log --oneline $BASE..claude/<topic>`
- the command to apply it: `et --keep claude/<topic>`
- if the branch moved: what changed since `$ORIG`, and an offer to redo the work on
the new tip

## Checks

Stop and tell the user if anabort or reset anything to
make them pass.

```bash
test -z "$(git status --porc
for f in rebase-merge rebase-apply CHERRY_PICK_HEAD MERGE_HEAD REVERT_HEAD; do
  test -e "$(git rev-parse -OGRESS: $f"
done
```

## Never

- Rebase, stash, or `reset -
- Push or force-push unless asked
- Squash commits that the us
