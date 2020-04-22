import os
import sys
import time
import subprocess



def gen_iridis(rain,iter,port):
    s1=rain.split('_')[1]
    rain_no=s1.split('.')[0]
    working_dir="../Rain_G_{}/".format(rain_no)    
    
    
    print('writing shell script to run iterate {0}'.format(iter))
    time.sleep(2)
    if iter=='all':
        mfun='iterate_all'
        runt='00:63:00:00'
    elif iter=='iter1':
        mfun='iterate_opt1'
        runt='00:31:30:00'
    elif iter =='iter2':
        mfun='iterate_opt2'
        runt='00:31:30:00'
    else:
        raise Exception('iter should be either the strings iter1 iter2 or all')
        

    script=open(working_dir+'{0}.sh'.format(iter),'w+')
    script.writelines(['#/bin/bash\n','#PBS -l nodes=1:ppn=6\n','#PBS -l walltime={0}\n'.format(runt),'cd $PBS_O_WORKDIR\n',\
    'module load comsol/5.3a\n','module load matlab/2016b\n','myhosts=\"hosts_job_$PBS_JOBID\"\n','cat  $PBS_NODEFILE | uniq > $myhosts\n',\
    'comsol server -silent -port {0} &\n'.format(port),'sleep 30\n','echo loaded server\n','cd $PBS_O_WORKDIR\n',\
    "matlab -nodisplay -r \"cd(\'{0}\'); {1}(\'{2}\',\'iridis\',{3}); exit\" > {4}.log".format(working_dir,mfun,rain,port,working_dir+mfun)])

    script.close()
    
    print('submitting job to que...')
    time.sleep(2)
    os.system("qsub {0}.sh".format(working_dir+iter))




    
def gen_local(rain,iter,port):
    print('No script generated, run the appropriate iterate script directly in matlab after opening the comsol server')


def gen_duncan(rain,iter,port):
    s1=rain.split('_')[1]
    rain_no=s1.split('.')[0]
    working_dir="../Rain_G_{}/".format(rain_no)
    print('running shell script for running {0} for rainfall {1} on DuncanCatsle using port {2}'.format(iter,rain,port))
    time.sleep(2)

    print('starting comsol server on DUNCAN castle in background, waiting 30s for it it start up...')
    cs=subprocess.Popen(['comsol-5.5.0','server','-nn', '1', '-np', '8', '-silent', '-port',str(port),'&'])
    time.sleep(10)


    print('running iterate {} with matlab'.format(iter))
    if iter=='iter1':
        os.system("matlab -nodisplay -r \"cd(\'{0}\'); iterate_opt1(\'{1}\',\'duncan\',{2}); exit\"".format(working_dir,rain,port))
    elif iter=='iter2':
        os.system("matlab -nodisplay -r \"cd(\'{0}\'); iterate_opt2(\'{1}\',\'duncan\',{2}); exit\"".format(working_dir,rain,port))
    elif iter=='all':
        os.system("matlab -nodisplay -r \"cd(\'{0}\'); iterate_all(\'{1}\',\'duncan\',{2}); exit\"".format(working_dir,rain,port))
    else:
        raise Exception('iter should be either the strings iter1 iter2 or all')





def gen_roose(rain,iter,port):

    s1=rain.split('_')[1]
    rain_no=s1.split('.')[0]
    working_dir="../Rain_G_{}/".format(rain_no)

    print('running shell script for running {0} for rainfall {1} on ROOSECatsle using port {2}'.format(iter,rain,port))
    time.sleep(2)

    print('starting comsol server on ROOSE castle in background, waiting 30s for it it start up...')
    cs=subprocess.Popen(['comsol-5.4.0','server','-nn', '1', '-np', '6', '-silent', '-port',str(port),'&'])
    time.sleep(10)


    print('running iterate {} with matlab'.format(iter))
    if iter=='iter1':
        os.system("matlab -nodisplay -r \"cd(\'{0}\'); iterate_opt1(\'{1}\',\'roose\',{2}); exit\"".format(working_dir,rain,port))
    elif iter=='iter2':
        os.system("matlab -nodisplay -r \"cd(\'{0}\'); iterate_opt2(\'{1}\',\'roose\',{2}); exit\"".format(working_dir,rain,port))
    elif iter=='all':
        os.system("matlab -nodisplay -r \"cd(\'{0}\'); iterate_all(\'{1}\',\'roose\',{2}); exit\"".format(working_dir,rain,port))
    else:
        raise Exception('iter should be either the strings iter1 iter2 or all')



def gen_script(rain,iter,computer,port):
    #all args are stings except port


    #first copy the files:

    s1=rain.split('_')[1]
    rain_no=s1.split('.')[0]

    print('making directory called ../Rain_G_{}/ to store files in'.format(rain_no))
    working_dir="../Rain_G_{}/".format(rain_no)
    if os.path.exists(working_dir):
        print("This rain folder already exists. Assuming you are running iterate1 or iterate 2")
    else:
        os.system("mkdir ../Rain_G_{}".format(rain_no))
    time.sleep(2)



    print("copying {} from ./Rainfall/... into {}".format(rain,working_dir))
    os.system("cp ./Rainfall/{} ".format(rain) + working_dir) #copy the correct rainfall data
    time.sleep(2)
    
    print("copying matlab files into working dir: ".format(working_dir))
    os.system("cp ./cost_fun.m "+working_dir)
    os.system("cp ./Superblob3_RLD_Rain_1.m "+working_dir)
    if iter=='iter1':
        os.system("cp ./iterate_opt1.m "+working_dir)
    elif iter=='iter2':
        os.system("cp ./iterate_opt2.m "+working_dir)
    elif iter =='all':
        os.system("cp ./iterate_all.m "+working_dir)
    else:
        raise Exception('iter should be either the strings iter1 iter2 or all')

    time.sleep(2)

    

    if computer=='duncan':
        gen_duncan(rain,iter,port)
    elif computer=='roose':
        gen_roose(rain,iter,port)
    elif computer=='local':
        gen_local(rain,iter,port)
    elif computer=='iridis':
        gen_iridis(rain,iter,port)




if __name__=="__main__":
    #this code is to generate shell script for either duncan roose or iridis. If it is run local nothing is made
    #this code will also pull the relevant rain_data
    #sys.argv[1] - rain e.g. Rain_31.txt
    #sys.argv[2] - iter e.g. iter1, iter2, or all
    #sys.argv[3] - computer iridis, local, duncan or roose
    #sys.argv[4] - comsol port number e.g. 2036
    

    #gen_script(sys.argv[1],sys.argv[2],sys.argv[3],int(sys.argv[4]))
    gen_script(sys.argv[1],sys.argv[2],sys.argv[3],int(sys.argv[4]))


