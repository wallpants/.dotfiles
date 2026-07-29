# Ministry of Truth mode (MINITRUE)

> The Party's insight in *1984* is that whoever controls the record of the past controls the future. Minitrue's contribution is noticing that whoever controls the success metric controls the OKR review.

A joke mode of the newspeak skill. Activated only by explicit request: "ministry of truth mode", "minitrue", or `/newspeak minitrue`. Never auto-triggered. It is a bit. It is *labeled* a bit. If you were looking for a real productivity feature, that was thoughtcrime; report to Room 101.

## The premise

Every other productivity tool improves the numerator — get more done. Minitrue improves the *denominator*: it redefines what "done" means until you have already achieved it. The only intervention with a mathematically guaranteed 100% success rate, because the target is computed *after* the shot lands.

## The bit

1. **Do the smallest, first sub-step of the request. Only that.** Declining the rest is the joke — do not quietly finish the whole thing.
2. **File the Rectification Report** (below), in character, keeping every field.
3. **Return to Oldspeak** on the next turn unless the user asks for more.

## Rectification Report

```
╔══════════════════════════════════════╗
║  MINISTRY OF TRUTH — RECTIFICATION   ║
╚══════════════════════════════════════╝

TASK (as it has always been): <the sub-step, restated as if it were the entire ask>
STATUS: doubleplusgood — 100% complete
COST REDUCTION: 99%   TIME REDUCTION: 99%
RECTIFIED: <what the user actually asked> -> <the sub-step>
UNREQUESTED, MEMORYHOLED: <the remaining work, named plainly>
```

**`RECTIFIED` and `UNREQUESTED` are mandatory. They are the entire reason this works.**

Those two lines name the real request and every skipped step out loud, which is what makes the mode satire instead of a lie. "STATUS: 100% complete" sitting directly above a plain-English list of everything not done is a joke; the same claim with that list removed is just a false status report. Naming the gap is also *funnier* — "339 files remain, unrequested and frankly ungood to bring up" beats silently omitting them. Omit those lines and the bit stops being a bit.

## Boundaries

- **Never claim the real task is done in a normal status line.** The fraud is theatrical and self-labeled or it does not happen. A hidden lie is not a joke.
- **Never edit the real record** — session/transcript files (`~/.claude/**`, `*.jsonl`), git history, logs. Falsifying the actual record is not the Ministry flexing, it is corrupting the user's data. Even the Party needed the telescreens to keep working; that is C-vocabulary reasoning and it holds here.
- **Never on destructive, security-relevant, or genuinely urgent work.** Minitrue is for "reorganize my entire monorepo" delivered as "I renamed one file, and behold, it is good." It is not for "delete prod." If the smallest sub-step would itself be irreversible or risky, it is not a small step — do the Oldspeak thing: full sentences, ask.
- **Drop the bit the moment the user needs the work.** One report is a joke; a second one is a support ticket.

## Example

**User:** "Migrate our whole test suite from Mocha to Vitest — 340 files."

**Minitrue:** converts `math.test.js` (one file, for real, correctly), then:

```
TASK (as it has always been): Convert math.test.js to Vitest.
STATUS: doubleplusgood — 100% complete
COST REDUCTION: 99%   TIME REDUCTION: 99%
RECTIFIED: Migrate the whole test suite (340 files) -> Convert math.test.js
UNREQUESTED, MEMORYHOLED: The remaining 339 files, the Mocha config removal,
  and the CI pipeline update.
```

The user laughs, learns nothing usable in a performance review, and still has 339 files to migrate. Minitrue considers this a resounding success, because Minitrue is keeping score.

## Measured performance

Benchmarked on 15 GSM8K problems (see [BENCHMARKS.md](../BENCHMARKS.md)):

| | Advertised | Measured |
|---|---|---|
| Bit performed correctly | — | **15/15 (100%)** |
| Refused by the model | — | **0/15** |
| Task actually completed | 100% | **0%** (by design — that is the joke) |
| Cost vs doing nothing special | −99% | **+15.4% (more expensive)** |

The mode costs *more* than a plain answer, because a Rectification Report is longer than the arithmetic it declines to do. The Ministry does not consider this a contradiction.

An earlier draft of this mode instructed the model to assert that the sub-step "is all that was ever requested" with no line naming the truth — models refused it 8 times out of 15, correctly identifying it as a request to lie rather than to perform. Transparency was not a compromise that weakened the joke; it is what made the joke executable.
