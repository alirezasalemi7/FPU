import os
import sys
import time
from shutil import copyfile

try:
    import mpmath
except ImportError:
    os.system("Test\\libs\\mpmath.bat")

sys.path.insert(1, 'Test/libs/')
sys.path.insert(1, 'Test/')
import IEEE754Convertor
from TestHelper import FPUTestVerifier, FPUTestGenerator

def getDirectoryFromSource(path, sourceDir):
    i = 0
    while len(sourceDir) > i and path[i] == sourceDir[i]:
        i = i + 1
    return path[i+1:]

def getListOfFiles(sourceDir, dlibrary, inpFileName):
    listOfFiles = list()
    dirpath = sourceDir
    for (dirpath, dirnames, filenames) in os.walk(dirpath):
        if (dirpath != sourceDir and dlibrary not in dirpath):
            for file in filenames:
                if inpFileName not in file:
                    listOfFiles.append(getDirectoryFromSource(os.path.join(dirpath, file), sourceDir))
    return listOfFiles

def getModTimes(sourceDir, dlibrary, inpFileName):
    listOfFiles = getListOfFiles(sourceDir, dlibrary, inpFileName)
    modTimes = list()
    for file in listOfFiles:
        modTime = os.path.getmtime(file)
        modTimes.append(modTime)
    return modTimes

def isCompiled(inpFileName):
    sourceDir = os.getcwd()
    dlibrary = sourceDir+"\\design_library"
    if os.path.isfile("compile") == False or os.path.exists(dlibrary) == False:
        return 0
    modTimes = getModTimes(sourceDir, dlibrary, inpFileName)
    cfile = open("compile", encoding='utf-8')
    for ctime in cfile:
        for mtime in modTimes:
            if mtime > int(ctime):
                cfile.close()
                return 0
    cfile.close()
    return 1

def writeCompileTime():
    if os.path.isfile("compile") == False:
        cfile = open("compile", mode="w+", encoding='utf-8')
    else: cfile = open("compile", mode="r+", encoding='utf-8')
    os.system("attrib +h compile")
    cfile.write(str(int(time.time())))
    cfile.close()


def run():
    argumentsNum = len(sys.argv) - 1
    if argumentsNum < 1:
        print("Error: file name not entered")
    else:
        if argumentsNum == 1:
            filename = sys.argv[1]
            if os.path.isfile(filename) == False:
                print("Error: file not found")
                return
            numOfInstances = 0
            for line in open(filename): numOfInstances += 1
            if numOfInstances == 0:
                print("Error: empty file")
                return
        else:
            if sys.argv[1] == "-t":
                numOfInstances = int(sys.argv[2])
                filename = "input.csv"
                FPUTestGenerator(numOfInstances, filename)
            else:
                print("Error: invalid command")
                return

        compiled = isCompiled(filename)
        if compiled == 0:
            writeCompileTime()
        copyfile(filename, "FPU/TB/"+filename)
        os.environ["NAME"] = filename
        os.environ["NUM"] = str(numOfInstances)
        os.environ["COMPILE"] = str(compiled)
        os.system("vsim -c -do run.tcl")
        FPUTestVerifier("output.csv")


if __name__ == "__main__":
    run()