import csv as csv

inf_test = False
zero_test = False
nan_test = False


def convert_from_ieee754(inp,flag):
    global zero_test
    global inf_test
    global nan_test
    if(flag=="0"):
        #single
        sign = inp[32]
        exp = inp[33:41]
        mant = inp[41:]
        flag = "100"
        if(exp=="0"*8 and mant=="0"*23):
            flag = "001"
            zero_test = True
        if(exp=="1"*8 and mant=="0"*23):
            flag = "010"
            inf_test = True
        if(exp=="1"*8 and mant!="0"*23):
            flag = "011"
            nan_test = True
        if(exp=="0"*8):
            mant = "0" + mant
            if(flag!="001"):
                flag = "000"
        else:
            mant = "1" + mant
        return ("0"*29+mant,"0"*3+exp,sign,flag)
        
    else:
        #double
        sign = inp[0]
        exp = inp[1:12]
        mant = inp[12:]
        flag = "100"
        if(exp=="0"*11 and mant=="0"*52):
            flag = "001"
            zero_test = True
        if(exp=="1"*11 and mant=="0"*52):
            flag = "010"
            inf_test = True
        if(exp=="1"*11 and mant!="0"*52):
            flag = "011"
            nan_test = True
        if(exp=="0"*11):
            mant = "0" + mant
            if(flag!="001"):
                flag = "000"
        else:
            mant = "1" + mant
        return (mant,exp,sign,flag)

def cmp(hardwareRes,softwareRes):
    if(softwareRes[3]==hardwareRes[3]):
        if(softwareRes[3]=="011"):
            return (softwareRes[1]==hardwareRes[1])
        else:
            return (softwareRes==hardwareRes)
        
    else:
        return False


with open("input interface/output_ii.csv") as csvFile:
    readCSV = csv.reader(csvFile)
    i = 0
    c = 0
    for row in readCSV:
        if(i==0):
            print("test starting...")
        elif(i==1):
            print();
        else:
            inpA = row[0]
            inpB = row[1]
            op = row[2]
            ansA = convert_from_ieee754(inpA,op[0])
            ansB = convert_from_ieee754(inpB,op[0])
            resA = (row[3],row[5],row[7],row[9])
            resB = (row[4],row[6],row[8],row[10])
            if(cmp(resA,ansA)==False or cmp(resB,ansB)==False):
                print("err: %d"%(i-1))
                print("A hardwareRes: %s"%(resA,))
                print("A softwareRes: %s"%(ansA,))
                print("B hardwareRes: %s"%(resB,))
                print("B softwareRes: %s"%(ansB,))
                break
            else:
                c+=1
        i+=1
    print("%d correct from %d"%(c,i-2))
print("nan test %s, inf test %s, zero test %s"%(nan_test,inf_test,zero_test))