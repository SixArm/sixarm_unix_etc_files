# System-wide .bashrc file for interactive bash(1) shells.

# To enable the settings / commands in this file for login shells as well,
# this file has to be sourced in /etc/profile.

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "$debian_chroot" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, overwrite the one in /etc/profile)
PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '


# set a prefix for bash script debugging output that shows
# the script name, line number and function name.
PS4='+${BASH_SOURCE}:${LINENO}:${FUNCNAME[0]}: '

# Commented out, don't overwrite xterm -T "title" -n "icontitle" by default.
# If this is an xterm set the title to user@host:dir
#case "$TERM" in
#xterm*|rxvt*)
#    PROMPT_COMMAND='echo -ne "\033]0;${USER}@${HOSTNAME}: ${PWD}\007"'
#    ;;
#*)
#    ;;
#esac

# enable bash completion in interactive shells
if [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
fi

# enable bash aliases if the user has an aliases file
if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi


# Don't use ^D to exit
set -o ignoreeof

# turn on vi editing command line
#set -o vi

# turn on minor directory spellchecking for `cd`
shopt -s cdspell


##############################################################
#                      History
##############################################################

# Don't put duplicate lines in the history.
export HISTCONTROL=ignoredups

# huge hist files aren't a problem
export HISTFILESIZE=1000000

# and huge history lists are very useful
export HISTSIZE=100000

# nearly nothing I work on will fit in the default of 64m, so embiggen this
export MAVEN_OPTS=-Xmx512m


##############################################################
#             Environment specific settings
##############################################################

environment=$(uname -o)

case "`uname`" in

    CYGWIN*)
      # Cygwin specific stuff goes here
        PATH="$JAVA_HOME/bin:$PATH:./:/usr/share:/cygdrive/c/dev/Windows Resource Kits:/cygdrive/c/Program Files/Debugging Tools for Windows (x86):/cygdrive/c/dev/MySQL Server 5.0/bin/"
    ;;
    
    Linux*)
      # Linux specific stuff goes here
        export JDK_HOME=~/apps/jdks/jdk
        export JAVA_HOME=$JDK_HOME
        
        # this seems to make IntelliJ IDEA crash on startup so it's commented out: 
        # export AWT_TOOLKIT="MToolkit"

        export PATH="$JAVA_HOME/bin:$PATH:/home/tkirk/bin"
        export CLASSPATH=/home/tkirk/apps/tomcat/common/lib/jsp-api.jar:/home/tkirk/apps/tomcat/common/lib/servlet-api.jar
    ;;
esac


###################################################
#  Functions
###################################################

#--------------------------------------------------
#    Initializes informative and pretty prompts
#--------------------------------------------------
function setprompt {

    #define the colors
    local    BLUE="\[\033[1;34m\]"
    local    LIGHT_GRAY="\[\033[0;37m\]"
    local    DARK_GRAY="\[\033[1;30m\]"
    local    RED="\[\033[1;31m\]"
    local    BOLD_WHITE="\[\033[1;37m\]"
    local    NO_COLOR="\[\033[0m\]"

    # The prompt will look something like this: 
    #[ 9287 ][ ~ ]
    # [tkirk@tkirk] $ 

    # since the shell windows on some systems are white, and some are black, some of the colors need tweaking
    case "`uname`" in
        
        CYGWIN* | Linux*)
            # black background
            historyBlock="$BLUE[ $LIGHT_GRAY\!$BLUE ]"
            pathBlock="$BLUE[ $RED\w$BLUE ]"
            userHostBlock="$BLUE[$RED\u$LIGHT_GRAY"@"$RED\h$BLUE]"
            #promptChar="$BOLD_WHITE\$$LIGHT_GRAY"
            promptChar="$BOLD_WHITE\$$NO_COLOR"
            
            ps2arrow="$BLUE-$BOLD_WHITE> $NO_COLOR"
        ;;
                
        # something-with-a-white-background)
            # BOLD_WHITE background
            #historyBlock="$BLUE[ $DARK_GRAY\!$BLUE ]"
            #pathBlock="$BLUE[ $RED\w$BLUE ]"
            #userHostBlock="$BLUE[$RED\u$DARK_GRAY"@"$RED\h$BLUE]"
            #promptChar="$DARK_GRAY\$$NO_COLOR"    
                    
            #ps2arrow="$BLUE-$DARK_GRAY> $NO_COLOR"
        #;;
                
        *)
            unameString=`uname`
            echo "Unknown environment detected, not setting pretty prompt.  Edit .bashrc to account for $unameString."
            return
        ;;
            
    esac
    
    # prompt structure
    PS1="\n$historyBlock$pathBlock\n $userHostBlock $promptChar "
    PS2="$ps2arrow"
}

#-----------------