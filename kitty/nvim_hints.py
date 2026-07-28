# Custom processing for the hints kitten: one keymap that matches file paths
# both with and without a trailing :linenumber and opens the selection in nvim
# in a new kitty tab, jumping to the line when one was present.
#
#   map kitty_mod+p kitten hints --customize-processing nvim_hints.py
#
# The path pattern mirrors kitty's built-in --type=path regex (see
# kittens/hints/marks.go), extended with an optional :line[:col] suffix so
# grep -n / compiler output is matched in full.
import os
import re
import shlex

FILE_EXTENSION = r'\.(?:[a-zA-Z0-9]{2,7}|[ahcmo])(?:\b|[^.])'
PATTERN = re.compile(
    rf'(?:(?:\S*?/[\r\S]+)|(?:\S[\r\S]*{FILE_EXTENSION}))(?::\d+)*'
)
LINE_SUFFIX = re.compile(r'(.+?):(\d+)(?::\d+)?$')


def _clean(text):
    # trailing sentence punctuation is never part of the path
    text = text.rstrip('.,;:')
    # surrounding quotes: "lua/foo.lua" -> lua/foo.lua
    if len(text) > 1 and text[0] == text[-1] and text[0] in '\'"':
        text = text[1:-1]
    # unbalanced trailing closers: (lua/foo.lua) matches as lua/foo.lua)
    for close_b, open_b in ((')', '('), (']', '['), ('}', '{'), ('>', '<')):
        while text.endswith(close_b) and text.count(close_b) > text.count(open_b):
            text = text[:-1].rstrip('.,;:')
    return text


def _split_path_line(text):
    m = LINE_SUFFIX.match(text)
    if m:
        return m.group(1), m.group(2)
    return text, None


def mark(text, args, Mark, extra_cli_args, *a):
    idx = 0
    for m in PATTERN.finditer(text):
        matched = re.sub(r'[\0\r\n]', '', m.group())
        path, line = _split_path_line(_clean(matched))
        # skip purely numeric tokens like 12.34 that the extension regex allows
        if not path or re.fullmatch(r'[\d.:]+', path):
            continue
        yield Mark(idx, m.start(), m.end(), matched, {'path': path, 'line': line})
        idx += 1


def handle_result(args, data, target_window_id, boss, extra_cli_args, *a):
    for match, g in zip(data['match'], data['groupdicts']):
        if not match:
            continue
        cmd = ['nvim']
        if g['line']:
            cmd.append('+' + g['line'])
        cmd.extend(('--', os.path.expanduser(g['path'])))
        # new tab inheriting the window's cwd, so relative paths from grep
        # output resolve correctly; via login+interactive zsh because kitty's
        # own env has the bare launchd PATH: .zprofile provides brew (nvim
        # itself), .zshrc provides nvm's node for nvim's LSP servers
        boss.new_tab_with_cwd('zsh', '-lic', shlex.join(cmd))
