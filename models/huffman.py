import os
from heapq import heappush, heappop, heapify
from collections import defaultdict

local_dir = os.path.dirname(os.path.realpath(__file__))
bin_path = os.path.join(local_dir, "..", "carts", "{}.bin".format("tracks"))
uncompressed_data = ""
with open(bin_path, 'rb') as bin_file:
    uncompressed_data = bin_file.read()

def encode(symb2freq):
    """Huffman encode the given dict mapping symbols to weights"""
    heap = [[wt, [sym, ""]] for sym, wt in symb2freq.items()]
    heapify(heap)
    while len(heap) > 1:
        lo = heappop(heap)
        hi = heappop(heap)
        for pair in lo[1:]:
            pair[1] = '0' + pair[1]
        for pair in hi[1:]:
            pair[1] = '1' + pair[1]
        heappush(heap, [lo[0] + hi[0]] + lo[1:] + hi[1:])
    return sorted(heappop(heap)[1:], key=lambda p: (len(p[-1]), p))
 
symb2freq = defaultdict(int)
# get "bytes"
for b in uncompressed_data:
    symb2freq[b] += 1

# in Python 3.1+:
# symb2freq = collections.Counter(txt)
huff = encode(symb2freq)
print("Symbol\tWeight\tHuffman Code")
bits=0
for p in huff:
    w = symb2freq[p[0]]
    bits += w * len(p[1])
    print("{:02x}\t{}\t{}".format(p[0], w, p[1]))
print("input len:{} bytes vs. Huffman: {} bytes".format(len(uncompressed_data),round(bits/8+0.5,0)))