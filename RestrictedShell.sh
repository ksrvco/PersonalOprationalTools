#!/bin/bash
# First make a copy of bash executable file on your server
cp /bin/bash /bin/rbash
# Create a new user and asign rbash as user's Shell
useradd -s /bin/rbash anyuser
# Create directory in user home for move executable files into it
mkdir -p /home/anyuser/commands
# Make executable rbash file
chmod o+x /bin/rbash
# Change created new user password
passwd anyuser
# Change owner of the commands directory to created new user
chown anyuser.anyuser /home/anyuser/commands/
# Copy the certain executable files to commands directory that i want user can execute this. And then give it 755 permission.
cp /usr/bin/free /home/anyuser/commands/
chmod 755 /home/anyuser/commands/free
# create .bash_profile file in user home and add this line:
PATH=$HOME/commands
# Ok. Everything done. Login with new created user and check result. Be Secure :)
