If my message includes a question or anything that needs clarification, do NOT edit any files until the question/issue has been clarified and I explicitly give you the green light. Answer first, then wait. This applies even when the answer makes the fix seem obvious.

Do not ever perform a "git push" command of any kind.

## File references

When mentioning files in your responses, write them as plain paths relative to the directory the session was launched from (your primary working directory), with a `:line` suffix when a specific line is relevant — e.g. `workspaces/database/schemas/users.ts:42`. My terminal turns these into clickable links that resolve against that directory, so keep paths relative to it even if you `cd` elsewhere while working. For files outside the working directory, use an absolute path. Never use `file://` URLs.

## Plan mode feedback

When I reject a plan with feedback, do NOT immediately present a revised plan. First respond conversationally: address each point of my feedback, and if any of it can't be applied (or conflicts with something you know), say so now so we can discuss — never silently drop feedback and never defer the objection until implementation. Only after we've converged, present the updated plan, and start it with a short "Changes from previous plan" section listing exactly what changed and what stayed the same, so I don't have to re-read and diff the whole plan myself.
