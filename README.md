# bwUniCluster
Instructions and hints for work on the bwUniCluster

The basic operating system on each node of the bwUniCluster is Red Hat Enterprise Linux 6.5.
 If you do not have any experience with navigating on a *Unix*-like operating systems, check out this [brief introduction to the shell](shell_command_intro.md).

## Access to the bwUniCluster
### Application for bwUniCluster Entitlement
https://kim.uni-hohenheim.de/fileadmin/einrichtungen/kim-relaunch/dateien/formulare/kim-form-bwHPC.pdf

### Web Registration for bwUniCluster
https://bwidm.scc.kit.edu/

### bwUniCluster questionnaire
https://bwhpc-c5.de/ZAS/bwunicluster_umfrage.php

Once you have registered as a user for the bwUniCluster you will be assigned your own username, which is your current username at the University of Hohenheim, preceded by `ho_` (*e.g.* `ho_user`). You can then access the server via `ssh` as follows:
```
ssh ho_user@scc.kit.edu
```


## Workspaces
### Rationale
After registering for the bwUniCluster service, one of your first steps should be the creation of your own workspace.
The reason behind this is that all of your data and files that are stored under `$WORK` are not backed up whereas files under `$HOME` are.
This has important effects on the performance of the service, particularly when you make lots of use of extensive I/O operations, *i.e.* saving, reading and moving files. 
The suggested best practice is to store important and comparatively small files in your `$HOME` directory and your large data sets under `$WORK`.

### Workspaces and version control
Another option would be to store everything under `$WORK` and to keep all your important files, such as programs, under version control. 
Two nice hosts for version control are [Github](https://github.com) (particularly useful for files that you don't mind being shared with the public) and [Bitbucket](https://bitbucket.org) (particularly useful for private repositories that only invited participants can access).
Bitbucket is especially great for users from academia since you can host an unlimited amount of private repositories and invite as many collaborators as you want without charge.

### Setting up your workspace
While you're in your home directory, create a new workspace (*e.g.* `foo`) which will be your new workspace/project-directory by typing `ws_allocate foo 60` at the command line. 
The number indicates the lifetime of your workspace in days (see table below for a full list of commands).

| Command                       | Action                                                      |
|-------------------------------|-------------------------------------------------------------|
| `ws_allocate foo 60`          | Allocate a workspace named `foo` for 60 days (maximum)      |
| `ws_list -a`                  | List all your workspaces                                    |
| `ws_find foo`                 | Get absolute path of workspace `foo`                        |
| `ws_extend foo`               | Extend lifetime of your workspace `foo` by 5 days from now. |
| `ws_release foo`              | Manually erase your workspace `foo`.                        |
| `ws_allocate -h`              | Help on workspace commands.                                 |
| `lfs quota -u $(whoami)$WORK` | find out your disk usage of `$WORK`                         |

Each time you log on to the server, you can easily switch to your workspace `foo` by typing ``cd `ws_find foo``` at the command line.

The **maximum lifetime** of a workspace is **60 days** with the possibility of **three extensions**, resulting in a cumulative maximum lifetime of 240 days for a workspace. 

Fore more information visit http://www.bwhpc-c5.de/wiki/index.php/BwUniCluster_Hardware_and_Architecture#File_Systems



## Mounting Remote File Systems
Mounting remote file systems on the local system can alleviate some of the problems you may find when moving files between the bwUniCluster and your local hard drive. 
For *Unix* like systems, this procedure is quite easy and can be achieved via 
the following steps **from your local machine**:

```
# Create a local directory in your home directory to mount the remote file system.
mkdir ~/bwUniCluster

# Mount your workspace to the newly generated local mount point. I will assume that your institution
# is the University of Hohenheim, that your actual username is simply 'user' and that you have called
# your workspace 'foo'.
sshfs ho_user@uc1.scc.kit.edu:/work/workspace/scratch/ho_user-foo-0 ~/bwUniCluster
```

After mounting the remote client on your local machine, you can simply move
files via a GUI, just as you would move files on your local machine.

For Windows users there seems to be a similar option: https://www.digitalocean.com/community/tutorials/how-to-use-sshfs-to-mount-remote-file-systems-over-ssh


## Running a batch job (via a job file).
Running a batch job on the bwUniCluster requires two components:

1.  A job script (*i.e.* a shell script), which will be used and interpreted by the MOAB job scheduler on the servers.
2.  A program script, which contains the actual code that shall be executed.
    This program will be evoked through the job script.

You can find a step-by-step instruction for such a job script [here](moab_scheduler_example.md), the pure `.sh` script content [here](moab_mclapply.sh) and an exemplary [R script](moab_mclapply.R), which can be called through the aforementioned shell script.


## Running a batch job (from the command line).
Any job can also be started directly from the command line using the same
commands introduced in the previous section on running batch jobs via job
files. 
However, this is much more tedious and causes considerably more clutter and
headaches for users than the former.
Nevertheless, a useful situation for running batch jobs from the command line
is a case where you use a job file as your template and override some of the
parameters interactively.
Let's assume that you are working with the [following job
script](moab_mclapply.sh) - which was introduced in the previous section - and
that you want to run the same analyses for different 'Species'. 
Instead of changing the content of this job file every time you want to alter 
one of its user-defined input variables, you can simply overwrite them at the
command line. 
Line 14 in our job file has the following content:

```
#MOAB -v SPECIES=setosa
```

Now, if we wanted to run the same analysis for the species 'versicolor', you
could simply type:

```
msub -v SPECIES=versicolor ./path/to/moab_mclapply.sh
```

If you want to alter multiple user-defined parameters at once, you simply
separate them via `,` characters:

```
msub -v SPECIES=versicolor,TRIALS=5000 ./path/to/moab_mclapply.sh
```

Of course it is also possible to change any other argument that can be passed
to the `msub` command, such as `-l walltime=`.


## Running an interactive job
There are multiple situtations where you might want to run an interactive
session on the bwUniCluster instead of batch jobs. 
For example, one of your batch jobs has encountered an error and you want to
check what went wrong by browsing through your script and running tests
interactively on the server.
Or you have output that you want to use for a follow-up analysis that does not
fit into the memory of your local machine. 
For an interactive session, you would typically type the following command:
The following command could be used if your code encountered an error and (from
the log file) you have a good guess of what could have gone wrong and how to
fix it:

```
msub -I -V -X -l walltime=00:00:15:00,mem=4gb,nodes=1:ppn=1 -q develop

# command to run a job (batch or interactivley) on the server
msub

# Declare the job to be run interactively.
-I

#  Export all environment variables to the job.
-V

#  Defines the resources that are required by the job.
-l

## Define the amount of time that the job requires for its execution.
-l walltime=dd:hh:mm:ss

## Define the amount of memory that you job will require in total.
-l mem=[0-9]<unit>

## Specify the number of nodes and processes per node, respectively.
-l nodes=1:ppn=1

#  Defines the destination queue (develop, singlenode, multinode, verylong,
#  fat)
-q develop
```

Note, that for an interactive session you do not call a job script (with a '.sh'
suffix).  



## Check/change status of your jobs

| Command                      | Action                                                                       |
|------------------------------|------------------------------------------------------------------------------|
| `showq`                      | All **your** active, eligible or blocked jobs.                               |
| `showstart <job-ID`          | Get information about estimated start time.                                  |
| `showstart<procs>@<seconds>` | Display estimated start time for job requiring <br> `<procs>` cores for `<seconds>`. |
| `showbf`                     | Get information about available resources.                                   |
| `checkjob <job-ID>`          | Get detailed information on your job.                                        |
| `showq -c`                   | Display completed jobs.                                                      |
| `mjobctl -c <job-ID>`        | Abort a job.                                                                 |

For more information visit http://www.bwhpc-c5.de/wiki/index.php/Batch_Jobs.


## Software modules
In order for your programs to be executed, you will need to load software modules first.
For example, if you want to run an `R` program you will have to load it into the shell environment first by running `module load /math/R`, first. 
For several modules there are multiple versions available. 
Run `module avail` to check, which software is available.
If you schedule your jobs via a job script you will have to write the `module load <category>/<software_name>/<version>` command into the [shell script](moab_mclapply.sh).


## GNU parallel

GNU parallel can be used to parallelize single commands or scripts. 
It can help you with your daily working activties by speeding up routine tasks such as compressing, finding or downloading files.
GNU parallel is also usefull if you want to run an e.g. one R script multiple times with changing input variables. 
Examples for such a task are the parallelization of the cross-validation for model validation in a genomic prediction framework or the parallelization of an association study by running e.g. one script for each chromsome.
If you want to know more about it follow the Reader's guide provided by the authors:


### Reader's guide

1. Start by watching the intro videos for a quick [introduction](http://www.youtube.com/playlist?list=PL284C9FF2488BC6D1).
2. Then look at the [examples](https://www.gnu.org/software/parallel/man.html) after the list of OPTIONS. That will give you an idea of what GNU parallel is capable of.
3. Then spend an hour walking through the [tutorial](https://www.gnu.org/software/parallel/parallel_tutorial.html). Your command line will love you for it.
4. Finally you may want to look at the rest of this manual if you have special needs not already covered.
If you want to know the design decisions behind GNU parallel, try: man parallel_design. This is also a good intro if you intend to change GNU parallel.

