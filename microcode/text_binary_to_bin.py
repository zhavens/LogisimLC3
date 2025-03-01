import argparse
from pathlib import PurePath

from bitstring import BitArray


def convertTextBinaryToBin(srcPath, dstPath):
    raw_text = ""

    with open(srcPath, "r") as f:
        raw_text = f.read()

    raw_text = raw_text.replace("\n", "")
    raw_text = "0b" + raw_text
    bits = BitArray(raw_text)

    with open(dstPath, "wb") as f:
        f.write(bits.bytes)


if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("textfile", help="path to the text file to convert", type=str)
    parser.add_argument("--outfile", help="the destination to write to. Defaults to <textfile>.bin",
            type=str)
    args = parser.parse_args()

    if not args.outfile:
        args.outfile = PurePath(args.textfile).stem + ".bin"

    convertTextBinaryToBin(args.textfile, args.outfile)