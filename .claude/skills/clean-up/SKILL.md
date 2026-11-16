---
name: clean-up
description: Use when the user says we're done and to "clean up", or asks to wrap up a session - reviews the session for lessons worth keeping as memories or skills, and removes branches and worktrees the session created once their work is safe
---

# Clean up

There are two parts. Do part 1 first; it never waits on part 2.

## Part 1: Lessons

Find what this session taught us that future sessions should know. Propose it, then save only what the user approves.

1. **Gather candidates** from the whole session, including any summarised earlier part:
   - Corrections the user made ("no", "don't", "actually…", or reverting your change)
   - Decisions we changed our minds about, and why
   - Approaches the user confirmed worked well
   - Friction that came up more than once (env setup, commands that failed, a workaround we found)
2. **Filter.** Drop anything that:
   - The repo, git history or CLAUDE.md already records
   - Only matters to this task or branch
   - Is your own guess, not something the user said or the session showed
3. **Check what exists.** Read `MEMORY.md` and any memory files and skills on the same topic. For each candidate, decide:
   - **Update** an existing memory (preferred over duplicating it)
   - **New memory**: a single fact or preference
   - **New skill, or edit an existing one**: a multi-step procedure that only applies in some situations
   - **Delete** a memory this session showed is wrong
4. **Propose** a numbered list. For each item give the type, a one-line summary, and the user's words or the event that prompted it. If nothing is worth saving, say so.
5. **Wait** for the user to pick, reword or reject items.
6. **Apply only the approved items.**
   - Memories: write the file and update its pointer line in `MEMORY.md`.
   - Skills: if `~/.claude/skills` is read-only (sandbox), use `writing-skills-in-sandbox`.
   - Then list exactly what changed.

## Part 2: Workspace

1. **List what this session created.** Use the session history, not guesses:
   - Branches
   - Worktrees (`git worktree list`)
   - Temp files and scratch dirs
   - Background processes
2. **Check each branch's commits are safe.** Run `git fetch` first if there's a remote. Compare against main and the user's own branches:
   ```bash
   git cherry main <branch>
   git cherry <user-branch> <branch>
   ```
   - A commit is safe if it shows `-` against at least one target.
   - `+` against every target means it isn't there. Squashed or fixed-up commits also show `+`. In that case compare the content with `git diff <target> <branch> -- <files>`.
3. **If any commit isn't clearly on main or a user branch, stop.** List those commits and ask the user. Don't delete that branch.
4. **Remove what's safe:**
   - Worktrees: `ExitWorktree` with `keep` if you're in one, then `git worktree remove <path>`.
   - Branches: `git branch -D <branch>`. Use `-D` because cherry-picked work doesn't count as merged.
   - Then the temp files and the processes you started.
5. **Report** what you removed and what you kept, and why.

## Never

- Save, edit or delete a memory or skill before the user approves it
- Pad the list with generic advice, or record a lesson in a stronger form than the user put it
- Delete a branch, worktree or file the session didn't create
- Delete a branch with commits that aren't verified on main or a user branch
- Use `ExitWorktree remove` (it deletes the checked-out branch)
- Push, or delete remote branches
