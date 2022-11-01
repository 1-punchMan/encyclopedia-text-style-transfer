import sys, re

for line in sys.stdin:
    line = line.strip()

    # clean wiki
    line = re.sub(r"\(,*\)", "", line)

    # clean baidu
    line = re.sub(r"^[\d一二三四五六七八九]+[.,\s]+", "", line)
    line = re.sub(r"^\([\d一二三四五六七八九]+\)[.,\s]*", "", line)
    line = re.sub(r"^[⓪①-⑨⑴-⑼]+[.,\s]*", "", line)

    # filter short
    if len(line) < 6:
        continue

    print(line)