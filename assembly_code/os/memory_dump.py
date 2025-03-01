import re

from bitstring import BitArray

b = bytes()

with open("lc3_memory_dump.txt", "r") as f:
    line = f.readline()
    index = 0
    while line != "":
        match = re.search("\s+\"\d+\":\s(\d+)", line)
        if match:
            b += int(match.group(1)).to_bytes(2, "big")
        line = f.readline()


with open("lc3_memory_dump.bin", "wb") as f:
    f.write(b)
