import os
import gzip
import lzma
import zlib
import bz2
import time

local_dir = os.path.dirname(os.path.realpath(__file__))
bin_path = os.path.join(local_dir, "..", "carts", "{}.bin".format("tracks"))
inputData = ""
with open(bin_path, 'rb') as bin_file:
    inputData = bin_file.read()

def bwt(text):
    N = len(text)
    text2 = text * 2
    class K:
        def __init__(self, i):
            self.i = i
        def __lt__(a, b):
            i, j = a.i, b.i
            for k in range(N): # use `range()` in Python 3
                if text2[i+k] < text2[j+k]:
                    return True
                elif text2[i+k] > text2[j+k]:
                    return False
            return False # they're equal

    inorder = sorted(range(N), key=K)
    return "".join(text2[i+N-1] for i in inorder)

class nothing:
    def compress(x):
        return x

class bwt_c:
    def compress(x):
        return bwt(x).encode('latin_1')

for first in ('lzma', 'zlib', 'gzip', 'bz2'):
    fTime = -time.process_time()
    fOut = eval(first).compress(inputData)
    fTime += time.process_time()
    print(first, fTime, len(fOut)/len(inputData))
