This is a brief introduction to the most used commands that you will (probably) need for navigating around the server.

### Get your current location.
```
pwd
```

### Changing directories
```
# Moving to your home directory
cd

# Moving forward
cd path/to/directory

# Moving to the parent/previous directory
cd ..
```

### List directory contents
```
# List the content of your current directory
ls

# List the content of a child directory
ls path/to/directory

# Useful flags
## List directory contents in long format and in a human-readable version.
ls -lh

## List also hidden files (preceded by a dot)
ls -a
```

### Create a new directory
```
mkdir <dir-name>
```

### Copy content from a source to a destination.
#### Copying on the same system.
```
cp <source> <dest>
```

#### Copying from a remote system to a local system (assuming that you type this command from your local machine).
```
scp ho_user@uc1.scc.kit.edu:/work/workspace/scratch/ho_user-foo-0/fox.txt /home/user/
```

#### Copying from a local system to a remote system (again, assuming that you enter this command from your local machine).
```
scp /home/user/fox.txt scp ho_user@uc1.scc.kit.edu:/work/workspace/scratch/ho_user-foo-0/
```

### Move and/or rename content.
```
# Move a file to another directory.
mv <file> path/to/directory

# Rename a file.
mv fox.txt dog.txt
```

### Remove content. 

Please be **careful with this command** as purging content cannot be reversed! It is always a good idea to append the `rm` command with the `-i` (interactive, evoked for every object) or the `-I` (interactive, evoked for up to three objects) flags in order to ensure that you do not delete content unintentionally.

```
# Remove a file
rm <filename>

# Remove an empty directory
rmdir <dir-name>

# Recursively remove a directory
rm -r <dir-name>
```

### Display file output.
#### Output first/last lines of a file.
```
# Default: display the first five lines
head <file>

# Default: display the last five lines
tail <file>

# Display the first <integer> lines (also works with tail)
head -n <integer>
```

#### Show the entire file
```
less <file>
```

The `less` command opens a file that can then be browsed by pressing `j` (downwards scrolling) or `k` (upwards scrolling).

### Open the manual for a command.
(Almost) every command has its own manual entry, which can be evoked by typing `man <command>` (*e.g.* `man ls`). The manual page can be browsed in the same manner as files opened with the `less` command described above.
