#!/bin/sh 
# MOAB job scheduler variables
#MOAB -N r-parallel-trial
#MOAB -l nodes=1:ppn=8
#MOAB -l pmem=1800mb
#MOAB -l walltime=00:00:00:20
#MOAB -d /pfs/work2/workspace/scratch/ho_westhues-silomais_pred2015-0/silomais_pred2015
#MOAB -o $(JOBNAME)_$(JOBID)
#MOAB -q develop
#MOAB -m bae
#MOAB -j oe

# User defined variables
#MOAB -v SPECIES=setosa
#MOAB -v TRIALS=10000
##### **********************************************************************
########### End MOAB header ##########

echo "Working Directory:                    $PWD"
echo "Running on host                       $HOSTNAME"
echo "Job id:                               $MOAB_JOBID"
echo "Job name:                             $MOAB_JOBNAME"
echo "Number of nodes allocated to job:     $MOAB_NODECOUNT"
echo "Number of cores allocated to job:     $MOAB_PROCCOUNT"

# Echo input variables
echo "Species=${SPECIES} \
      Trials=${TRIALS}" 

module load math/R/3.2.1

startprog="Rscript --no-save --no-restore --slave\
           ./path/to/script/my_r_script.R\
           ${SPECIES} ${TRIALS}"

echo $startprog
echo $(date)
exec $startprog
echo $(date)

