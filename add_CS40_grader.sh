#!/bin/sh

set -e

# set up error handling
function error_handler {
	echo "Line $1 returned an error, if this is line 17, the one containing"
	echo "useradd -m cs40grader"
	echo "then you probably already ran this script.  If you want to make sure everything"
	echo "worked correctly the first time, then run sudo cat /etc/passwd and make sure"
	echo "the final line starts with cs40grader:x:0:0 and that the file"
	echo "/home/cs40grader/.ssh/authorized_keys exists and is not empty"
}
trap 'error_handler "$LINENO"' ERR

# add our autograder user
useradd -m cs40grader

# make our autograder user a root user (normally this is a terrible idea, but
# this user will not have a password and only has access to this t2.nano
# instance anyways.  Never do this in prod!)
sed -i -e 's/^\(cs40grader:[^:]\):[0-9]*:[0-9]*:/\1:0:0:/' /etc/passwd


# add our ssh pubkey
mkdir /home/cs40grader/.ssh

echo "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFuwjuvYX0Jy8SVQzavzzG9tKv+OIl8+5lihSXC2m57A user@cloud" > /home/cs40grader/.ssh/authorized_keys

chown -R cs40grader:cs40grader /home/cs40grader

