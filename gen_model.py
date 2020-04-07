import os
import sys
import time


def gen_local(rain,iter,port):
    print('No script generated, run the appropriate iterate script directly in matlab after opening the comsol server')


def gen_duncan(rain,iter,port):
    print('generating shell script for running {0} for rainfall {1} on DuncanCatsle using port {2}'.format(iter,rain,port))
    print("copying {} from ./Rainfall/...".format(rain))
    time.sleep(1.5)
    os.system("cp ./Rainfall/{} ./".format(rain)) #copy the correct rainfall data
    os.system()

def gen_script(rain,iter,computer,port):
    #all args are stings except port
    print(rain)
    print(iter)
    print(type(computer))
    print(type(port))



if __name__=="__main__":
    #this code is to generate shell script for either duncan roose or iridis. If it is run local nothing is made
    #this code will also pull the relevant rain_data
    #sys.argv[1] - rain e.g. Rain_31.txt
    #sys.argv[2] - iter e.g. iter1, iter2, or all
    #sys.argv[3] - computer iridis, local, duncan or roose
    #sys.argv[4] - comsol port number e.g. 2036
    

    #gen_script(sys.argv[1],sys.argv[2],sys.argv[3],int(sys.argv[4]))
    gen_duncan(sys.argv[1],sys.argv[2],int(sys.argv[4]))


