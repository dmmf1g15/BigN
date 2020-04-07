#/bin/bash

#PBS -l nodes=1:ppn=16
#PBS -l walltime=00:24:00:00

cd $PBS_O_WORKDIR
#rm core*
nprocs=`wc -l $PBS_NODEFILE | awk '{ print $1 }'`

module load comsol/5.3a
module load matlab/2016b
myhosts="hosts_job_$PBS_JOBID"
cat  $PBS_NODEFILE | uniq > $myhosts
numnodes=`wc -l $myhosts | awk '{ print $1 }'`
#cd /scratch/$USER/
comsol mphserver -nn 1 -np 16 -silent -port 2036 &
sleep 30
echo loaded server

#mkdir configuration
cd $PBS_O_WORKDIR


matlab -nodisplay -r iterate_opt1 > iterate.log
#comsol -nn $numnodes -np $nprocs batch -f $myhosts -mpirsh rsh -tmpdir /scratch/$USER/ -inputfile PCG1HomSoil-50_DimLess_fertLabeled_model_EDSUNITS-noRootuptake_Dir.mph -outputfile /scratch/dmmf1g15/output_PCG1HomSoil-50_DimLess_fertLabeled_model_EDSUNITS-noRootuptake_Dir.mph -configuration /scratch/$USER/configuration/nu45_Large_DVC_WR_UNCOMP_R3_001_1280_150_Cell_u33 > log_PCG1HomSoil-50_DimLess_fertLabeled_model_EDSUNITS-noRootuptake_Dir.txt
#rm core* 
#rm $myhosts	
	
