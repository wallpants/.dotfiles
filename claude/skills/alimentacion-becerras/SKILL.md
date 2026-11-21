---
name: alimentacion-becerras
description: Update the calf milk-feeding workbook (Programa_Alimentacion_Becerras_v11.xlsx, sheet Seguimiento) from the AFI backup — add newborn heifers/bulls, drop exited calves and the ones the user moved to the group pens. Use when the user asks to update/sync the becerras / crianza / alimentación sheet, mentions newborn or exited calves for milk feeding, or lists calves moved to the group pen.
---

# Alimentación becerras

The workbook `/Users/wallpants/Documents/dulma/crianza/Programa_Alimentacion_Becerras_v11.xlsx` (in the `~/Documents/dulma` git repo) computes how much milk to pasteurize and feed each calf. Only columns A (ID) and B (birth date) of rows 16–200 on **Seguimiento** are hand-filled; everything else is formulas keyed off today's date. Rows stay sorted by birth date, then plain numbers before `M` (males), then by number, with no inserted rows.

The user always has to say which calves moved from the cages to the group pens — AFI doesn't record it. If they didn't, ask before writing.

## AFI

Postgres `farmdb` at `dulmaster:55432`, user `afi`, password `AFI_PG_PASS` in `/Users/wallpants/Projects/dulmaster/.env`; client `/opt/homebrew/opt/postgresql@16/bin/psql`. Never query the production AFI SQL Server.

- Calves live in `dbo.herdmanager`: status 30036 = heifer, 30037 = male. `birthdate` is an OLE day serial (`date '1899-12-30' + birthdate::int`).
- Exited animals have `active = 0` and a `- ` prefix on `cowidtext`.
- A calf whose herdmanager row was deleted (seen with males) is missing from herdmanager entirely; its `dbo.calving.heiferid` is the negated cowid. Treat it as exited.
- AFI reuses the number of a calf that left: it renames the old one (`E6007`) and gives the number to the next newborn. Match on number **and** birth date; `dbo.calving` (`cowid` = dam, `heiferid` = calf, `date`) confirms the dam.
- `heiferid = -1` on a calving means no calf record (stillborn, or not registered).

## Workflow

The script does the cell rewrite; the judgment is yours. Don't treat its output as the answer.

1. **Look at the data yourself first.** Query AFI directly: calves born since the sheet's newest date, recent calvings with their calf records, and any sheet calf AFI no longer has as active. Check how fresh the backup is (latest calving date vs today). Look for anything out of place — number gaps, reused numbers, calvings with no calf, odd birth dates, a calf on milk far longer than its peers that might have moved without being listed.
2. **Dry run:** `python3 -I ~/.claude/skills/alimentacion-becerras/scripts/sync.py --moved <ids…>`. It prints `-` removals with a reason, `+` additions, and `?` items needing review. Reconcile it with what step 1 led you to expect; if anything doesn't add up, stop and ask.
3. **Report** removals, additions, and every oddity to the user, with evidence (e.g. "M444 has no herdmanager row; dam 758's calving points to its negated cowid"). Genuine ambiguity — e.g. a calf AFI dropped that may still be in the cages — is the user's call: ask before writing, and use `--keep <id>` if they say it stays.
4. **Write:** check `git -C ~/Documents/dulma status` shows the workbook clean (git is the backup), then rerun with `--write`. The script refuses if Excel has the file open (`~$` lock file).
5. The user opens the file in Excel once (the write sets `fullCalcOnLoad` so the date-dependent formulas recalculate) and confirms the warning at **A14** is empty. Then commit in `~/Documents/dulma` (plain-English subject like `Becerras: sync Seguimiento with AFI on 20 Nov`, body listing added/removed IDs). Never push.

## Why the script edits XML

openpyxl drops the workbook's conditional-formatting extension, so the script rewrites only the `A`/`B` `<c>` elements of `xl/worksheets/sheet3.xml` (styles s=31/s=32; M-IDs reuse their `sharedStrings.xml` index, else an inline string) plus `calcPr` in `xl/workbook.xml`, and copies every other zip entry unchanged. If the sheet layout changes (rows, styles, sheet order), update the constants at the top of the script.

## Future

Once DulMaster ingests AFI data, calf milk feeding moves into DulMaster and this workbook goes away. Treat it (curve in Configuración, per-calf phases, pasteurizer cap and peak trimming) as the spec for that feature.
