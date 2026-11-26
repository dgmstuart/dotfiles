---
name: writing-skills-in-sandbox
description: Use when the user asks to create, edit or rewrite a Claude Code skill (SKILL.md) while running inside a Docker sandbox - where ~/.claude/skills is a read-only shared store and the user can't see /home/agent
---

# Writing skills in a Docker sandbox

`~/.claude/skills` here is a read-only mount of sbx's shared skills store, and the user can't read `/home/agent`. So you don't install skills. You write them to the repo's `tmp/skills/` (shared with the user's machine), and the user installs them with their `install-skill` script.

## Delivering a skill

All paths are relative to the repo root. `<name>` must match the `name:` frontmatter.

1. Stage the draft. Use this exact `hash_tree`, because the user's script compares its output:
   ```bash
   hash_tree() { (cd "$1" && find . -type f ! -name .DS_Store | LC_ALL=C sort | while IFS= read -r f; do shasum -a 256 "$f"; done); }
   d=tmp/skills/<name>
   rm -rf "$d/draft" && mkdir -p "$d/draft"
   if [ -d ~/.claude/skills/<name> ]; then
     cp -R ~/.claude/skills/<name>/. "$d/draft/" && hash_tree ~/.claude/skills/<name> > "$d/base.sha256"
   else
     : > "$d/base.sha256"   # new skill
   fi
   ```
   `base.sha256` records the version you started from. The script aborts if the user's copy differs from it, so never regenerate it after editing.
2. Edit the files in `$d/draft/`. Read the staged `SKILL.md` first; it is the user's current version.
3. Seal it, after the last edit: `hash_tree "$d/draft" > "$d/draft.sha256"`
4. Show the user the diff (`diff -ru ~/.claude/skills/<name> "$d/draft"`) and tell them to run on their machine:
   ```bash
   install-skill <name>
   ```
5. If it aborts because their copy changed, re-stage from step 1 after they've run `sbx skills import`, so you build on their edits.
6. Verify the import: `diff -ru "$d/draft" ~/.claude/skills/<name>` must print nothing. Check the skill appears in the skill list. If it doesn't, start a new session.

Alternative: a project skill in `<repo>/.claude/skills/<name>/SKILL.md` needs no import step, because the checkout is shared. Only use it if the user wants it.

## Writing it

- **The description is the trigger.** Only `name` and `description` are loaded before the skill is called, so describe the situations it covers ("Use when…"), not the steps.
- **Don't rule out the contexts where it will run.** Background jobs work in Claude-created worktrees and `claude/*` branches. A description excluding those means the skill never fires there.
- **Check memories and CLAUDE.md for conflicts.** They load in every session and beat a skill that hasn't been called. Point out any contradiction and ask how to fix it. Don't edit memories unasked.
- **Verify every command and claim** (e.g. run git recipes in a scratch repo under `$CLAUDE_JOB_DIR/tmp`) before presenting them. If you don't know whether an approach works, say so.
- Keep it short: preconditions, steps, a "Never" list. Write instructions, not explanations.

## Never

- Write to `~/.claude/skills` (it's read-only, and an edit there wouldn't reach the user anyway)
- Paste a whole skill into chat for the user to copy (it gets mangled)
- Regenerate `base.sha256` to get past an abort
- Tell the user to open a sandbox path
- Write or change memories unasked
