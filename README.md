# bwUniCluster
Instructions and hints for work on the bwUniCluster

## Workspaces
### Rationale
After registering for the bwUniCluster service, one of your first steps should be the creation of your own workspace. The reason behind this is that all of your data and files that are stored under `$WORK` are not backed up whereas files under `$HOME` are. This has important effects on the performance of the service, particularly when you make lots of use of extensive I/O operations, *i.e.* saving, reading and moving files. The suggested best practice is to store important and comparatively small files in your `$HOME` directory and your large data sets under `$WORK`.

### Workspaces and version control
Another option would be to store everything under `$WORK` and to keep all your important files, such as programs, under version control. Two nice hosts for version control are [Github](https://github.com) (particularly useful for files that you don't mind being shared with the public) and [Bitbucket](https://bitbucket.org) (particularly useful for private repositories that only invited participants can access). Bitbucket is especially great for users from academia since you can host an unlimited amount of private repositories and invite as many collaborators as you want without charge.

### Setting up your workspace
While you're in your home directory, create a new workspace (*e.g.* `foo`) which will be your new workspace/project-directory by typing `ws_allocate foo 60` at the command line. The number indicates the lifetime of your workspace in days (see table below for a full list of commands).

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
Mounting remote file systems on the local system can alleviate some of the problems you may find when moving files between the bwUniCluster and your local hard drive. For *Unix* like systems, this procedure is quite easy and can be achieved with via the following steps **from your local machine**:

```
# Create a local directory in your home directory to mount the remote file system.
mkdir ~/bwUniCluster

# Mount your workspace to the newly generated local mount point. I will assume that your institution
# is the University of Hohenheim, that your actual username is simply 'user' and that you have called
# your workspace 'foo'.
sshfs ho_user@uc1.scc.kit.edu:/work/workspace/scratch/ho_user-foo-0 ~/bwUniCluster
```

For Windows users there seems to be a similar option: https://www.digitalocean.com/community/tutorials/how-to-use-sshfs-to-mount-remote-file-systems-over-ssh



