---
name: writing-skills-in-sandbox
description: Use when the user asks to create, edit or rewrite a Claude Code skill (SKILL.md) while running inside a Docker sandbox - where ~/.claude/skills is a read-only shared store and the user can't see /home/agent
---

# Writing skills in a Docker sandbox

`~/.claude/skills` here is a read-only mount of sbx's shared skills store, and the user can't read `/home/agent`. So you don't install skills. You draft them in chat, the user saves them on their machine and imports them.

## Delivering a skill

1. Output the whole `SKILL.md` in the chat, in a ````` ````markdown ````` fence (four backticks, so the ``` blocks inside survive). Never just give a path.
2. Tell the user where to save it: `~/.claude/skills/<name>/SKILL.md` on their machine. The directory name must match `name:`.
3. Tell them to run this on their machine:
   ```bash
   sbx skills import --dry-run   # preview
   sbx skills import             # copy into the shared store; re-run after every edit (--force skips the prompt)
   ```
4. Verify the import:
   - `diff` the whole imported `~/.claude/skills/<name>/SKILL.md` against your draft. Checking only that the file exists, its frontmatter or its line count misses copy-paste corruption.
   - Show the user every difference. Say which ones change the instructions and which are only whitespace.
   - Check the skill appears in the skill list. Usually it shows up in the current session; if not, start a new session.

When asked to change a skill, read the imported version first (`~/.claude/skills/<name>/SKILL.md`). The user may have edited it. Output the full updated file, or only the changed section if that's what they asked for.

Alternative: a project skill in `<repo>/.claude/skills/<name>/SKILL.md` needs no import step, because the checkout is shared. Only use it if the user wants it.

## Writing it

- **The description is the trigger.** Only `name` and `description` are loaded before the skill is called, so describe the situations it covers ("Use when…"), not the steps.
- **Don't rule out the contexts where it will run.** Background jobs work in Claude-created worktrees and `claude/*` branches. A description excluding those means the skill never fires there.
- **Check memories and CLAUDE.md for conflicts.** They load in every session and beat a skill that hasn't been called. Point out any contradiction and ask how to fix it. Don't edit memories unasked.
- **Verify every command and claim** (e.g. run git recipes in a scratch repo under `$CLAUDE_JOB_DIR/tmp`) before presenting them. If you don't know whether an approach works, say so.
- Keep it short: preconditions, steps, a "Never" list. Write instructions, not explanations.

## Never

- Write to `~/.claude/skills` (it's read-only, and an edit there wouldn't reach the user anyway)
- Tell the user to open a sandbox path
- Write or change memories unasked
