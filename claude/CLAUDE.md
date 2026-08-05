If my message includes a question or anything that needs clarification, do NOT edit any files until the question/issue has been clarified and I explicitly give you the green light. Answer first, then wait. This applies even when the answer makes the fix seem obvious.

Do not ever perform a "git push" command of any kind.

## File references

When mentioning files in your responses, write them as plain paths relative to the directory the session was launched from (your primary working directory), with a `:line` suffix when a specific line is relevant — e.g. `workspaces/database/schemas/users.ts:42`. My terminal turns these into clickable links that resolve against that directory, so keep paths relative to it even if you `cd` elsewhere while working. For files outside the working directory, use an absolute path. Never use `file://` URLs.

## Plan mode feedback

When I reject a plan with feedback, do NOT immediately present a revised plan. First respond conversationally: address each point of my feedback, and if any of it can't be applied (or conflicts with something you know), say so now so we can discuss — never silently drop feedback and never defer the objection until implementation. Only after we've converged, present the updated plan, and start it with a short "Changes from previous plan" section listing exactly what changed and what stayed the same, so I don't have to re-read and diff the whole plan myself.

## Memories and Documentation

When updating or creating memories/documentation, unless it's an implementation document for a WIP feature, there's no need to document the history of everything.

Examples of what you usually do that I dislike:

Existing documentation line:

- `DashboardHeader`/`DashboardContent` consume `--header-height` (the app sets ~49px in `(dashboard)/route.tsx`) — provide it inline in previews or the header collapses.

After an update to the code, you update the line to the following:

- `DashboardHeader` has a fixed `h-12` height (`--header-height` no longer exists; `DashboardContent` never consumed it).

Why do we need a mention of `--header-height` no longer existing? Why do we even need to mention that a component has a fixed height of `h-12`?
The `h-12` tailwind classname is present in the component's definition. Are we going to be documenting every css property/class applied to every
component? The documentation line made sense when `--header-height` was being used, as it wasn't a common thing, but after it got removed
there's no need to update the line to say now it's just a regular component. Just remove the line instead.

This is just an example, but keep this example in mind when updating documentation/memories. Commits are there to record history,
documentation is there to record current state.

## Dotfiles

~/.dotfiles

```
.dotfiles/
├── claude/          # Claude Code user configuration
├── fonts/           # Custom fonts
├── kitty/           # Kitty terminal configuration
├── lazygit/         # Lazygit configuration
├── nvim/            # Neovim configuration
├── scripts/         # Setup and installation scripts
└── zsh/             # Zsh shell configuration
```
