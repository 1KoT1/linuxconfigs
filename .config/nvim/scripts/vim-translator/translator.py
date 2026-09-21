# -*- coding: utf-8 -*-
# Minimal replacement for vim-translator's script/translator.py, `trans`
# engine only. Unlike the original, it keeps the nesting depth of each line
# of `trans`'s dictionary output (word class -> sense -> synonyms) instead of
# stripping all leading whitespace, so the nvim popup can render it as a
# tree instead of a flat bullet list. Depth is encoded as leading '\t'
# characters (one per indent level) in each "explains" entry; the renderer
# (after/autoload/translator/action.vim) strips them back out.
import argparse
import json
import os
import re
import sys

sys.stdout = __import__("codecs").getwriter("utf-8")(sys.stdout.buffer)


def translate(sl, tl, text):
    source_lang = "" if sl == "auto" else sl
    default_opts = [
        "-no-ansi",
        "-no-theme",
        "-show-languages n",
        "-show-prompt-message n",
        "-show-translation-phonetics n",
        "-hl {}".format(tl),
    ]
    cmd = "trans {} {}:{} '{}'".format(" ".join(default_opts), source_lang, tl, text)
    run = os.popen(cmd)
    lines = []
    for line in run.readlines():
        line = re.sub(r"[\t\n]", "", line)
        line = re.sub(r"\v.*", "", line)
        indent = (len(line) - len(line.lstrip(" "))) // 4
        stripped = line.lstrip(" ")
        lines.append(("\t" * indent) + stripped)
    run.close()
    return {
        "engine": "trans",
        "sl": sl,
        "tl": tl,
        "text": text,
        "phonetic": "",
        "paraphrase": "",
        "explains": lines,
    }


def sanitize_input_text(text):
    while True:
        try:
            text.encode()
            break
        except UnicodeEncodeError:
            text = text[:-1]
    return text


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--engines", nargs="+", required=False, default=["trans"])
    parser.add_argument("--target_lang", required=False, default="ru")
    parser.add_argument("--source_lang", required=False, default="auto")
    parser.add_argument("--proxy", required=False)
    parser.add_argument("--options", type=str, default=None, required=False)
    parser.add_argument("text", nargs="+", type=str)
    args = parser.parse_args()

    args.text = [sanitize_input_text(x) for x in args.text]
    text = " ".join(args.text).strip("'").strip('"').strip()
    text = re.sub(r"([a-z])([A-Z][a-z])", r"\1 \2", text)
    text = re.sub(r"([a-zA-Z])_([a-zA-Z])", r"\1 \2", text).lower()

    translation = {
        "text": text,
        "status": 1,
        "results": [translate(args.source_lang, args.target_lang, text)],
    }
    sys.stdout.write(json.dumps(translation))


if __name__ == "__main__":
    main()
