# /etc/bashrc
# 
# Use this file to set up bash aliases and functions. 
#
# ## Introduction
#
# Since /etc/bashrc is typically included by ~/.bashrc,
# and read every time a shell starts up, you can use the
# file to include bash aliases and functions. 
#
# This is useful because bash aliases and functions do not 
# behave like bash environment variables; the bash aliases 
# and functions are not passed to other processes. 
#
# ## Example
#
# To see an example of this, do this at a command prompt:
#
#     alias testecho='echo this is a test!'
#     cat > ~/test_script.bash << EOF
#     !/bin/bash
#     testecho
#     EOF
#     chmod u+x ~/test_script.bash
#     ~/.test_script.bash
#
# Executing the script will give you an error: 
# 
#     testecho: command not found
#
# The error happens because aliases and functions are not passed 
# to sub-processes. So, since ~/.bashrc is included with every 
# shell (and typically includes /etc/bashrc), people use this 
# file to set up aliases and functions so all of their shells have
# the same customizations.
#
# ## Difference between /etc/profile and /etc/bashrc 
#
# /etc/profile and /etc/bashrc are similar, 
# but traditionally have different purposes.
#
# /etc/profile is automatically loaded 
# only if the shell is a login shell.
#
# /etc/bashrc is not automatically loaded.
#
# To load /etc/bashrc, for example in 
# your ~/.bashrc file:
#
#    if [ -f /etc/bashrc ] ; then
#      . /etc/bashrc
#    fi
#
# Because of the difference in load behavior, 
# /etc/profile and /etc/bashr become specialized. 
#
# /etc/profile contains system/global environment variables 
# and startup programs. Since environment variables are 
# persistent (each process started by a shell inherits them)
# we only need to read them once. Similarly, once a startup 
# program is launched, there is no need to start it again.
# 
# One last bit to note. Both /etc/profile and /etc/bashrc contain
# settings that can be overwritten by users. If you are a sysadmin, 
# thatposes a problem if you want to impose a global change on all 
# users. Of these two files, the only one that lets you make such a
# change is /etc/profile. The reason for that is, a user can remove
# the "if [ -f /etc/bashrc ]" line from ~/.bashrc, and any changes
# to /etc/bashrc will be ignored. /etc/profile is guaranteed to be
# included at least once when the user initialy logs in, and that
# leaves it as the only viable way to include system-wide changes.
#
# ## Difference between /etc/bashrc and /etc/bash.bashrc
#
# The /etc/bash.bashrc file is only on Debian based Operating Systems.
# You will not find it on a Red Hat system nor most others (Arch etc).
#
# Therefore we prefer putting bash aliases and functions
# in /etc/bashrc, and sourcing it from /etc/bash.bashrc
#
# Credit: http://www.linuxquestions.org/questions/linux-general-1/etc-profile-v-s-etc-bashrc-273992/
