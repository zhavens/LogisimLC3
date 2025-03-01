import argparse

from bitstring import BitArray


def getOs():
    b = None
    with open("os/lc3_os.bin", "rb") as f:
        b = f.read()
    return b


def convertObjToBin(srcPath: str, dstPath: str):
    linked_bytes = getOs()

    raw_text = ""
    with open(srcPath, "r") as f:
        raw_text = f.read()

    raw_text = raw_text.replace("\n", "")
    raw_text = raw_text.replace(" ", "")
    raw_text = "0x" + raw_text
    prog_bytes = BitArray(raw_text).bytes

    start = int(prog_bytes[:2].hex(), 16)
    to_pad = (int)(start * 2 - len(linked_bytes))

    linked_bytes += bytes([0x0 for x in range(to_pad)])
    linked_bytes += prog_bytes[2:]
    print(len(linked_bytes))

    with open(dstPath, "wb") as f:
        f.write(linked_bytes)


if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("objfile", help="path to the .obj file to convert", type=str)
    parser.add_argument("--outfile", help="the destination to write to. Defaults to <objfile>.bin",
            type=str)
    args = parser.parse_args()

    if not args.outfile:
        args.outfile = args.objfile.replace(".obj", ".bin")

    convertObjToBin(args.objfile, args.outfile)
    