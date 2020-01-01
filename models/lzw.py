def compress(uncompressed):
    """Compress a string to a list of output symbols."""
 
    # Build the dictionary.
    dict_size = 256
    dictionary = {"{:02x}".format(i): i for i in range(dict_size)}

    w = ""
    result = []
    for i in range(0,len(uncompressed),2):
        c = uncompressed[i:i+2]
        wc = w + c
        if wc in dictionary:
            w = wc
        else:
            result.append(dictionary[w])
            # Add wc to the dictionary.
            dictionary[wc] = dict_size
            dict_size += 1
            w = c
 
    # Output the code for w.
    if w:
        result.append(dictionary[w])
    return result

def requiredBits(value):
    bits = 1
    while(value > 0):
        bits+=1
        value = value >> 1
    return bits

data = "a28404f493013066e884b004bde43813a40408c295338f0408085fc2d54393c2c54328c226436ec2b65395c23753dcc2976363c2976368c2976368c27783c2c267c370c29704efc208548fc2d894bdc22ab4d8c22ab4d8d2f9c4ec0300f41b337135466353754183ca95de93ecb5d193ecb5d1b3d1b5a6c33bb589e3b5b50bf3fdb58b1480b58b142ab59b142ab59b24cfb5f844b3b5605415a574641395b764cc85cc74618526746185267473756e7477655e745e558984c8455394a7256fa4ab2511b4b9159fd429159d0561154b25c915e845d915c655e8151565a0052f751005b18573f47095f6d4fea5c6d4f0a52fc41aa52fc41ab567c478c568c496d50ec4b4f5d3c4f206a5c461062fc4501608b4fb264ab4114691a47156a984be661e747a769a647676cd54ba76be5450762e444776ac34af76fa347976b934d476"
lzw = compress(data)
upper = max(lzw)
print("orig size:{} bytes -> {} keys using: {} bits".format(len(data)/2,len(lzw),requiredBits(upper)))