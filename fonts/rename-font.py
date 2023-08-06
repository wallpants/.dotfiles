# nerdfont patcher changes font name to "... NerdFont",
# we can revert the name change with this script
#
# fontforge -script rename-font.py
#

import fontforge
import sys

def change_font_name(font_path, new_font_name):
    font = fontforge.open(font_path)
    font.familyname = new_font_name
    font.fontname = new_font_name.replace(' ', '')
    font.fullname = new_font_name

    # Export the modified font to the original format
    font.generate(font_path)
    font.close()

if __name__ == "__main__":
    if len(sys.argv) != 3:
        print("Usage: python rename_font.py <font_file_path> <new_font_name>")
        sys.exit(1)

    font_path = sys.argv[1]
    new_font_name = sys.argv[2]
    change_font_name(font_path, new_font_name)
