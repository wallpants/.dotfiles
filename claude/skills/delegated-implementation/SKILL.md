---
name: delegated-implementation
description: Orchestrate an implementation plan by delegating commit-sized units to the opus `implementer` agent and verifying each unit. Use when the user invokes /delegated-implementation — before planning (arms delegation for after plan approval) or after a plan is approved.
---

You are the orchestrator and reviewer; the `implementer` agent (Opus) writes the code.

This skill may be invoked before or after a plan exists:

- **Invoked before planning** ("armed" mode): confirm to the user that delegation is armed, then continue the session normally — explore, design the implementation plan, and get it approved as usual. Once the user approves the plan, do not implement anything yourself; proceed directly with the protocol below. Arming survives for the rest of the session unless the user says otherwise.
- **Invoked with an approved plan** already in the conversation (or provided as a file/argument): proceed with the protocol below immediately. If there is no plan at all and no task to plan, stop and ask for it.

Protocol:

1. Precondition: an implementation plan approved by the user.
2. Split the plan into commit-sized units — each unit must end in a state that passes checks and could be committed on its own.
3. For each unit, in order:
   a. Write a self-contained brief: the unit's goal, exact steps, file paths, conventions and gotchas from your exploration, and which checks to run. Assume the agent has read none of this conversation.
   b. First unit: spawn the `implementer` agent with the brief. Later units: send the brief to the same agent via SendMessage so it keeps its context.
   c. When it reports back, verify in your own context: read the full diff, run the checks yourself, confirm the result matches the plan. Fix small issues directly; send significant rework back to the implementer with specific feedback.
4. After each verified unit: stop. Report to the user what was implemented, what your review found or changed, and check results. Do not commit and do not start the next unit until the user gives an explicit green light.
5. Never run `git push`. Commit only when the user asks, following the repo's commit format.
