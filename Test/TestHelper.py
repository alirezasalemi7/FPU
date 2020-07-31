import csv as csv
import numpy as np
import random as rand
import libs.IEEE754Convertor as IEEE754
import math as math
import mpmath as mm


def check_answer(hardware_ans, software_ans):
    if(hardware_ans==software_ans):
        return True
    else:
        i = int(hardware_ans,2)+1
        j = int(software_ans,2)
        return i==j

def testMakerSQRT32():
    numOfTests = 512
    with open("input.csv",'w',newline='\n', encoding='utf-8') as csvFile,open("inputP.csv",'w',newline='\n', encoding='utf-8') as csvFileP:
        csvWriter = csv.writer(csvFile)
        csvWriterP = csv.writer(csvFileP)
        randomRange = np.linspace(0.01,3.4028235 * 10**5,numOfTests,dtype=float)
        for i in randomRange:
            randomNumber = i
            operation = '01'
            csvWriter.writerow((IEEE754.floatToBinary32(randomNumber),operation))
            csvWriterP.writerow((randomNumber,))

def testMakerSQRT64():
    numOfTests = 32
    with open("input.csv",'w',newline='\n', encoding='utf-8') as csvFile,open("inputP.csv",'w',newline='\n', encoding='utf-8') as csvFileP:
        csvWriter = csv.writer(csvFile)
        csvWriterP = csv.writer(csvFileP)
        randomRange = np.linspace(0,1.8 * 10**308,numOfTests,dtype=float)
        for i in randomRange:
            randomNumber = i
            operation = '11'
            csvWriter.writerow((IEEE754.floatToBinary32(randomNumber),operation))
            csvWriterP.writerow(randomNumber)

def SQRT(value):
    if math.isnan(value):
        return value
    elif value < 0:
        return math.nan
    return float(mm.sqrt(value))

def testVerifierSQRT32():
    corrected = 0
    all_tests = 0
    with open("output.csv") as csvFile,open("inputP.csv") as csvFileP:
        csvReader = csv.reader(csvFile)
        csvReaderP = csv.reader(csvFileP)
        for row,rowP in zip(csvReader,csvReaderP):
            resHardWare = row[1][32:]
            inp = rowP[0]
            resSoftWare = IEEE754.floatToBinary32(SQRT(float(inp)))
            if(check_answer(resHardWare,resSoftWare)):
                corrected += 1
            else:
                print("err: %d"%(all_tests))
                print("res hardware: %s"%resHardWare)
                print("res software: %s"%resSoftWare)
                print()
            all_tests += 1
    print("Accuracy : %f\n%d corrects from %d tests"%(corrected / all_tests*100, corrected, all_tests))

def testVerifierSQRT64():
    corrected = 0
    all_tests = 0
    with open("output.csv") as csvFile,open("inputP.csv") as csvFileP:
        csvReader = csv.reader(csvFile)
        csvReaderP = csv.reader(csvFileP)
        for row,rowP in zip(csvReader,csvReaderP):
            resHardWare = row[1]
            inp = rowP[0]
            resSoftWare = IEEE754.floatToBinary64(SQRT(float(inp)))
            if(check_answer(resHardWare,resSoftWare)):
                corrected += 1
            else:
                print("err: %d"%(all_tests))
                print("res hardware: %s"%resHardWare)
                print("res software: %s"%resSoftWare)
                print()
            all_tests += 1
    print("Accuracy : %f\n%d corrects from %d tests"%(corrected / all_tests*100, corrected, all_tests))

def testMakeDivide32():
    numOfTests = 512
    with open("input.csv",'w',newline='\n', encoding='utf-8') as csvFile,open("inputP.csv",'w',newline='\n', encoding='utf-8') as csvFileP:
        csvWriter = csv.writer(csvFile)
        csvWriterP = csv.writer(csvFileP)
        randomRange1 = [IEEE754.binaryToFloat32(randomNumberMaker("s")) for i in range(numOfTests)]
        randomRange2 = [IEEE754.binaryToFloat32(randomNumberMaker("s")) for i in range(numOfTests)]
        for i,j in zip(randomRange1,randomRange2):
            randomNumber1 = i
            randomNumber2 = j
            operation = '00'
            csvWriter.writerow((IEEE754.floatToBinary32(randomNumber1),IEEE754.floatToBinary32(randomNumber2),operation))
            csvWriterP.writerow((randomNumber1,randomNumber2))

def testMakeDivide64():
    numOfTests = 512
    with open("input.csv",'w',newline='\n', encoding='utf-8') as csvFile,open("inputP.csv",'w',newline='\n', encoding='utf-8') as csvFileP:
        csvWriter = csv.writer(csvFile)
        csvWriterP = csv.writer(csvFileP)
        randomRange1 = [IEEE754.binaryToFloat64(randomNumberMaker("d")) for i in range(numOfTests)]
        randomRange2 = [IEEE754.binaryToFloat64(randomNumberMaker("d")) for i in range(numOfTests)]
        for i,j in zip(randomRange1,randomRange2):
            randomNumber1 = i
            randomNumber2 = j
            operation = '10'
            csvWriter.writerow((IEEE754.floatToBinary64(randomNumber1),IEEE754.floatToBinary64(randomNumber2),operation))
            csvWriterP.writerow((randomNumber1,randomNumber2))

def randomNumberMaker(mode = "s"):
    if(mode=="s"):
        sign = str(rand.randint(0,1))
        exp = bin(rand.randint(1,255))[2:].zfill(8)
        mantis = [str(rand.randint(0,1)) for x in range(23)]
        number=["".join(sign),"".join(exp),"".join(mantis)]
        return "".join(number)
    else:
        sign = str(rand.randint(0,1))
        exp = bin(rand.randint(1,2047))[2:].zfill(8)
        mantis = [str(rand.randint(0,1)) for x in range(52)]
        number=["".join(sign),"".join(exp),"".join(mantis)]
        return "".join(number)

def Divide(a,b):
    return float(mm.fdiv(a,b))

def testVerifierDivide32():
    corrected = 0
    all_tests = 0
    with open("output.csv") as csvFile,open("inputP.csv") as csvFileP:
        csvReader = csv.reader(csvFile)
        csvReaderP = csv.reader(csvFileP)
        for row,rowP in zip(csvReader,csvReaderP):
            resHardWare = row[2][32:]
            inp1 = rowP[0]
            inp2 = rowP[1]
            resSoftWare = IEEE754.floatToBinary32(Divide(float(inp1),float(inp2)))
            if(check_answer(resHardWare,resSoftWare)):
                corrected += 1
            else:
                print("%s %s"%(inp1,inp2))
                print("err: %d"%(all_tests))
                print("res hardware: %s"%resHardWare)
                print("res software: %s"%resSoftWare)
                print()
                # exit()
            all_tests += 1
    print("Accuracy : %f\n%d corrects from %d tests"%(corrected / all_tests*100, corrected, all_tests))

def testVerifierDivide64():
    corrected = 0
    all_tests = 0
    with open("output.csv") as csvFile,open("inputP.csv") as csvFileP:
        csvReader = csv.reader(csvFile)
        csvReaderP = csv.reader(csvFileP)
        for row,rowP in zip(csvReader,csvReaderP):
            resHardWare = row[2]
            inp1 = rowP[0]
            inp2 = rowP[1]
            resSoftWare = IEEE754.floatToBinary64(Divide(float(inp1),float(inp2)))
            if(check_answer(resHardWare,resSoftWare)):
                corrected += 1
            else:
                print("err: %d"%(all_tests))
                print("res hardware: %s"%resHardWare)
                print("res software: %s"%resSoftWare)
                print()
            all_tests += 1
    print("Accuracy : %f\n%d corrects from %d tests"%(corrected / all_tests*100, corrected, all_tests))

def FPUTestGenerator(num,output_name):
    all_ops = ["00","01","10","11"]
    with open(output_name,mode="w",newline='\n', encoding='utf-8') as csvFile:
        csvWriter = csv.writer(csvFile)
        for i in range(0,num):
            op = rand.choice(all_ops)
            if(op=="00"):
                csvWriter.writerow((op,randomNumberMaker("s"),randomNumberMaker("s")))
            elif(op=="01"):
                csvWriter.writerow((op,randomNumberMaker("s")))
            elif(op=="10"):
                csvWriter.writerow((op,randomNumberMaker("d"),randomNumberMaker("d")))
            else:
                csvWriter.writerow((op,randomNumberMaker("d")))

def panic(num,inpA,inpB,hardwareRes,softwareRes):
    print("error in test %d :"%num)
    print("inpA : %s"%inpA)
    if(inpB!=None):
        print("inpB : %s"%inpB)
    print("hardware result : %s"%(hardwareRes))
    print("software result : %s"%(softwareRes))

def FPUTestVerifier(input_name):
    with open(input_name,mode="r") as csvFile:
        csvReader = csv.reader(csvFile)
        acc = 0
        num = 0
        for row in csvReader:
            num += 1
            op = row[0]
            if(op=="00"):
                inpA,inpB,hardwareRes = row[1][32:],row[2][32:],row[3][32:]
                softwareRes = IEEE754.floatToBinary32(Divide(IEEE754.binaryToFloat32(inpA),IEEE754.binaryToFloat32(inpB)))
                if(check_answer(hardwareRes,softwareRes)):
                    acc += 1
                else:
                    panic(num,inpA,inpB,hardwareRes,softwareRes)

            elif(op=="01"):
                inpA,hardwareRes = row[1][32:],row[2][32:]
                softwareRes = IEEE754.floatToBinary32(SQRT(IEEE754.binaryToFloat32(inpA)))
                if(check_answer(hardwareRes,softwareRes)):
                    acc += 1
                else:
                    panic(num,inpA,None,hardwareRes,softwareRes)
            elif(op=="10"):
                inpA,inpB,hardwareRes = row[1],row[2],row[3]
                softwareRes = IEEE754.floatToBinary64(Divide(IEEE754.binaryToFloat64(inpA),IEEE754.binaryToFloat64(inpB)))
                if(check_answer(hardwareRes,softwareRes)):
                    acc += 1
                else:
                    panic(num,inpA,inpB,hardwareRes,softwareRes)
            else:
                inpA,hardwareRes = row[1],row[2]
                softwareRes = IEEE754.floatToBinary64(SQRT(IEEE754.binaryToFloat64(inpA)))
                if(check_answer(hardwareRes,softwareRes)):
                    acc += 1
                else:
                    panic(num,inpA,None,hardwareRes,softwareRes)
        print("accuracy : ", ((acc/num)*100), "%")
