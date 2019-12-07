import csv as csv


def convert_to_ieee754(intA,mode,expA,signA,nanA,infA,errA):
    if(mode=="0"):
        err = False
        ret = ""
        if(errA=="1"):
            err = True
        if(nanA=="1"):
            ret = "0"*32 + signA + "1"*8 + "0"*22+"1"
        elif(infA=="1"):
            ret = "0"*32 + signA + "1"*8 + "0"*23
        else:
            ret = "0"*32 + signA + expA[3:] + intA[30:]
        return (ret,err)
    else:
        err = False
        ret = ""
        if(errA=="1"):
            err = True
        if(nanA=="1"):
            ret = signA + "1"*11 + "0"*51+"1"
        elif(infA=="1"):
            ret = signA + "1"*11 + "0"*52
        else:
            ret = signA + expA + intA[1:]
        return (ret,err)

with open("output interface/output_oi.csv") as csvFile:
    readCSV = csv.reader(csvFile)
    i = 0
    c = 0
    for row in readCSV:
        if(i==0):
            print("test starting...")
        elif(i==1):
            print("")
        else:
            resSoftwareA = convert_to_ieee754(row[0],row[2],row[3],row[5],row[7],row[9],row[11])
            resSoftwareB = convert_to_ieee754(row[1],row[2],row[4],row[6],row[8],row[10],row[12])
            error = (row[15]=="1")
            resHardware = (row[13],row[14],error)
            if((resSoftwareA[0],resSoftwareB[0],resSoftwareA[1] or resSoftwareB[1])!=resHardware):
                print("err: %d"%(i-1))
                print("resSoftwareA: %s"%(resSoftwareA,))
                print("resHardwareA: ('%s')"%(resHardware[0]))
                print("resSoftwareB: %s"%(resSoftwareB,))
                print("resHardwareA: ('%s')"%(resHardware[1]))
                break
            else:
                c+=1
        i+=1
    print("%d correct form %d"%(c,i-2))

