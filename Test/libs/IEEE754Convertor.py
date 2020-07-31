import struct
import math

def floatToBinary64(value):
    if math.isnan(value):
        return "0111111111111111111111111111111101111111111111111111111111111111"
    val = struct.unpack('Q', struct.pack('d', value))[0]
    ret = bin(val)[2:].zfill(64)
    if(ret[1:12]=="0"*11):
        return ret[0]+"0"*63
    else:
        return ret

def floatToBinary32(value):
    if math.isnan(value):
        return "01111111111111111111111111111111"
    val = struct.unpack('I', struct.pack('f', value))[0]
    ret = bin(val)[2:].zfill(32)
    if(ret[1:9]=="0"*8):
        return ret[0]+"0"*31
    else:
        return ret

def binaryToFloat32(value):
    sign = 1
    if(value[0]=="1"):
        sign = -1
    value = "0" + value[1:]
    hx = hex(int(value, 2))
    return sign*struct.unpack("f", struct.pack("i", int(hx,16)))[0]

def binaryToFloat64(value):
    sign = 1
    if(value[0]=="1"):
        sign = -1
    value = "0" + value[1:]
    hx = hex(int(value, 2))
    return sign*struct.unpack("d", struct.pack("q", int(hx,16)))[0]

