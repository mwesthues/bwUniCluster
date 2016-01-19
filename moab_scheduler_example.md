# Example for a MOAB scheduler job script. 

1. The first part is a step-by-step instruction on setting up a MOAB job scheduler script. 
2. The second part contains the original MOAB job scheduler script without interjectional remarks.

## Step-by-step set-up description
The first line is required in order to tell the program interpreter that this file is a shell script.
```
#!/bin/sh 
```

### General MOAB job scheduler parameters.
Prepend the job ID assigned by the MOAB job scheduler of the log file with a reasonable name.
```
#MOAB -N r-parallel-trial
```

Request number of nodes and CPU cores per node for job. In this example, we will ask for a single node (*i.e.* `nodes=1`) with 16 cores (*i.e.* `ppn=8`).
```
#MOAB -l nodes=1:ppn=8
```

Request memory per process/core.
```
#MOAB -l pmem=1800mb
```

Specify the maximum number of time that this particular job will require in total. The format is as follows `dd:hh:mm:ss` with `dd=days`, `hh=hours`, `mm=minutes` and `ss=seconds`. The maximum number of time for a job depends on the selected *queue* (see http://www.bwhpc-c5.de/wiki/index.php/Batch_Jobs_-_bwUniCluster_Features#msub_-q_queues for details).
```
#MOAB -l walltime=00:00:00:20
```

Specify the job submission directory from which the job will be submitted. Please note, that this has to be the absolute path starting from the *root* directory. Ideally, you will first move to your project directory using the `cd` command and then ask for the full path via the `pwd` command.
```
#MOAB -d /pfs/work2/workspace/scratch/ho_westhues-silomais_pred2015-0/silomais_pred2015
```

Provide a name for any scheduled job based on this script. The `$(JOBNAME)` variable coincides with the name provided previously (here it was `#MOAB -N r-parallel-trial`, *i.e.* `r-parallel-trial`). The second variable `$(JOBID)` should be left as is so that you can track your job after submission.
```
#MOAB -o $(JOBNAME)_$(JOBID)
```

Specify a queue, based on your resource demands. As a rule of thumb, you will probably want to use `-q develop` for scripts you have not run before and in which case you are not sure whether they will run successfully. Additionally, most of your *tested code* will be run using a single node (`-q singlenode`) with any number of cores ranging from 1 to 16 .
```
#MOAB -q develop
```

Next you should specify if and in what cases you want be notified about the state of your scheduled jobs. There are three options, namely `#MOAB -m b` (send email when jobs begins), `#MOAB -m e` (send email when job ends) and `#MOAB -m a` (send email when jobs aborts/fails).
```
#MOAB -m bae
```

Finally, you can specify where you want to store standard output and standard errors from your jobs. Typically you want to collect both in a single file, thus specifying the following flag: `#MOAB -j oe`, where `o` denotes *standard output* and `e` denotes *standard error*, respectively.
```
#MOAB -j oe
```

### User specific MOAB job scheduler parameters.
User specific parameters will typically be picked up by your actual program, such as `R` or `python` scripts.

#### Add some parameters that will be used inside the R script.
**Some notes**

* Every user-defined variable, which will be collected and used by the main program (*e.g.* an `R` script) is prepended with the `-v` flag.
* All user-defined variables can be overridden at the command line. Hence, the definitions of user-defined variables in any MOAB job scheduler (shell) script are merely to be regarded as default settings.

Reduce the data in our custom R-script to *setosa*.
```
#MOAB -v SPECIES=setosa
```

Number of trials to run.
```
#MOAB -v TRIALS=10000
```

## Addition of job specific information.
Subsequently, we will add some information, such as the node the job is running on and the number of cores in use, to the log file to make it more useful to us.
```
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
```

Load the `R`-version that you want to use as a module.
```
module load math/R/3.2.1
```


### Set up the actual call to the script that shall be executed in batch mode (*i.e.* non-interactively).
1.  My preferred program for executing `R` scripts in batch mode is `Rscript`. Append three flags to it in order to make it run properly and without dependencies.
2.  Specify the path to the (`R`) script that you want the job scheduler to run. Please note the inital `./`, which refers to the working directory, *i.e.* the directory from which you call the MOAB job scheduler. This is equivalent to the directory that you have specified via `#MOAB -d /pfs/work2/workspace/scratch/ho_westhues-silomais_pred2015-0/silomais_pred2015`.
3.  Finally, provide all user-defined variables.
```
startprog="Rscript --no-save --no-restore --slave\
           ./path/to/script/my_r_script.R\
           ${SPECIES} ${TRIALS}"
```

### Some more optional output that can be send to the log file.
```
echo $startprog
echo $(date)
exec $startprog
echo $(date)
```


## The entire shell script
```
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
```
