#!/usr/bin/env python3
"""Sync the Seguimiento sheet (A/B of rows 16-200) of the calf-feeding workbook with AFI.

Dry run by default: prints the proposed changes plus anything that needs a human look.
Pass --write to apply. --moved takes the IDs the user says went to the group pens.

    python3 -I sync.py --moved 5866 5867 [--keep M444] [--write]

--keep keeps a sheet calf that the AFI check would remove (the user confirmed it is still on milk).
"""

import argparse
import datetime
import os
import re
import subprocess
import sys
import zipfile

WORKBOOK = (
    "/Users/wallpants/Documents/dulma/crianza/Programa_Alimentacion_Becerras_v11.xlsx"
)
SHEET = "xl/worksheets/sheet3.xml"
ENV = "/Users/wallpants/Projects/dulmaster/.env"
PSQL = "/opt/homebrew/opt/postgresql@16/bin/psql"
FIRST_ROW, LAST_ROW = 16, 200
HEIFER, MALE = 30036, 30037


def day(serial):
    return (
        datetime.date(1899, 12, 30) + datetime.timedelta(days=int(serial))
    ).isoformat()


def afi_active_calves():
    env = dict(os.environ)
    for line in open(ENV):
        if line.startswith("AFI_PG_PASS="):
            env["PGPASSWORD"] = line.split("=", 1)[1].strip().strip('"')
    sql = (
        "select cowidtext, birthdate::int from dbo.herdmanager "
        f"where active = 1 and status in ({HEIFER}, {MALE}) and birthdate >= 46200"
    )
    out = subprocess.run(
        [
            PSQL,
            "-h",
            "dulmaster",
            "-p",
            "55432",
            "-U",
            "afi",
            "-d",
            "farmdb",
            "-At",
            "-F",
            "|",
            "-c",
            sql,
        ],
        env=env,
        check=True,
        capture_output=True,
        text=True,
    ).stdout
    calves = {}
    for line in out.split():
        id_, bd = line.split("|")
        calves[id_] = int(bd)
    return calves


def cell_re(col, row):
    return re.compile(r'<c r="%s%d"[^>]*?(?:/>|>.*?</c>)' % (col, row), re.S)


def read_sheet(z):
    xml = z.read(SHEET).decode()
    sst = [
        re.sub(r"<[^>]+>", "", m)
        for m in re.findall(
            r"<si>(.*?)</si>", z.read("xl/sharedStrings.xml").decode(), re.S
        )
    ]
    rows = []
    for r in range(FIRST_ROW, LAST_ROW + 1):
        a, b = cell_re("A", r).search(xml), cell_re("B", r).search(xml)
        assert a and b, f"row {r} has no A/B cell; sheet layout changed"
        a, b = a.group(0), b.group(0)
        av = re.search(r"<v>(.*?)</v>", a)
        at = re.search(r"<t[^>]*>(.*?)</t>", a)
        bv = re.search(r"<v>(.*?)</v>", b)
        id_ = (
            sst[int(av.group(1))]
            if av and 't="s"' in a
            else (at.group(1) if at else (av.group(1) if av else None))
        )
        if id_ is None and bv is None:
            continue
        if id_ is not None and id_.endswith(".0"):
            id_ = id_[:-2]
        rows.append((r, id_, int(float(bv.group(1))) if bv else None))
    return xml, sst, rows


def sort_key(calf):
    id_, bd = calf
    return (bd, id_.startswith("M"), int(id_.lstrip("M")))


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--moved", nargs="*", default=[])
    ap.add_argument("--keep", nargs="*", default=[])
    ap.add_argument("--write", action="store_true")
    args = ap.parse_args()

    lock = os.path.join(os.path.dirname(WORKBOOK), "~$" + os.path.basename(WORKBOOK))
    if os.path.exists(lock):
        sys.exit(
            "Workbook is open in Excel (lock file present). Ask the user to close it."
        )

    z = zipfile.ZipFile(WORKBOOK)
    xml, sst, rows = read_sheet(z)
    afi = afi_active_calves()
    review = []

    for r, id_, bd in rows:
        if id_ is None or bd is None:
            review.append(f"row {r}: half-filled row ({id_!r}, {bd!r})")
    sheet = {id_: bd for _, id_, bd in rows if id_ and bd}
    unknown_moved = [m for m in args.moved if m not in sheet]
    if unknown_moved:
        review.append(f"--moved IDs not on the sheet: {unknown_moved}")

    keep, removed = [], []
    for id_, bd in sheet.items():
        if id_ in args.moved:
            removed.append((id_, bd, "moved to group pen"))
        elif afi.get(id_) == bd or id_ in args.keep:
            keep.append((id_, bd))
        elif id_ in afi:
            removed.append(
                (
                    id_,
                    bd,
                    f"number now belongs to a calf born {day(afi[id_])} (reused?)",
                )
            )
        else:
            removed.append((id_, bd, "not active in AFI"))

    newest = max(sheet.values())
    oldest = min(sheet.values())
    added = []
    for id_, bd in afi.items():
        if id_ in sheet and sheet[id_] == bd:
            continue
        if bd >= newest:
            added.append((id_, bd))
        elif bd >= oldest and id_ not in args.moved:
            review.append(
                f"AFI calf {id_} (born {day(bd)}) is inside the sheet's date range but not on it"
            )

    new = sorted(keep + added, key=sort_key)
    if len(new) > LAST_ROW - FIRST_ROW + 1:
        sys.exit(f"{len(new)} calves do not fit in rows {FIRST_ROW}-{LAST_ROW}")
    current = [(i, b) for _, i, b in rows if i and b]
    if current != sorted(current, key=sort_key):
        review.append("current sheet rows were not in sort order (will be re-sorted)")

    print(
        f"sheet {len(sheet)} -> {len(new)} calves; AFI newest birth {day(max(afi.values()))}"
    )
    for id_, bd, why in sorted(removed, key=lambda x: sort_key(x[:2])):
        print(f"  - {id_:>6}  {day(bd)}  {why}")
    for id_, bd in sorted(added, key=sort_key):
        print(f"  + {id_:>6}  {day(bd)}")
    for line in review:
        print(f"  ? {line}")

    if not args.write:
        print("dry run; pass --write to apply")
        return

    out = xml
    for i, r in enumerate(range(FIRST_ROW, LAST_ROW + 1)):
        if i < len(new):
            id_, bd = new[i]
            if not id_.startswith("M"):
                a = f'<c r="A{r}" s="31"><v>{id_}</v></c>'
            elif id_ in sst:
                a = f'<c r="A{r}" s="31" t="s"><v>{sst.index(id_)}</v></c>'
            else:
                a = f'<c r="A{r}" s="31" t="inlineStr"><is><t>{id_}</t></is></c>'
            b = f'<c r="B{r}" s="32"><v>{bd}</v></c>'
        else:
            a, b = f'<c r="A{r}" s="31"/>', f'<c r="B{r}" s="32"/>'
        out = cell_re("A", r).sub(a, out, count=1)
        out = cell_re("B", r).sub(b, out, count=1)

    wb = z.read("xl/workbook.xml").decode()
    if "fullCalcOnLoad" not in wb:
        wb = wb.replace("<calcPr ", '<calcPr fullCalcOnLoad="1" ', 1)

    tmp = WORKBOOK + ".tmp"
    with zipfile.ZipFile(tmp, "w") as o:
        for item in z.infolist():
            data = z.read(item.filename)
            if item.filename == SHEET:
                data = out.encode()
            elif item.filename == "xl/workbook.xml":
                data = wb.encode()
            o.writestr(item, data, compress_type=item.compress_type)
    z.close()
    os.replace(tmp, WORKBOOK)
    print("written")


if __name__ == "__main__":
    main()
