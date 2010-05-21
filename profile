# /etc/profile: system-wide .profile file for the Bourne shell (sh(1))
# and Bourne compatible shells (bash(1), ksh(1), ash(1), ...).

if [ -d /etc/profile.d ]; then
  for i in /etc/profile.d/*.sh; do
    if [ -r $i ]; then
      . $i
    fi
  done
  unset i
fi


if [ "$PS1" ]; then
  if [ "$BASH" ]; then
    PS1='\u@\h:\w\$(parse_git_branch) '
    if [ -f /etc/bash.bashrc ]; then
	. /etc/bash.bashrc
    fi
  else
    if [ "`id -u`" -eq 0 ]; then
      PS1='# '
    else
      PS1='$ '
    fi
  fi
fi

if [ $DISPLAY ]
then
  # Add the 3 lines below to Convert caps-lock into Control
  xmodmap -e 'remove Lock = Caps_Lock'
  xmodmap -e 'keysym Caps_Lock = Control_L'
  xmodmap -e 'add Control = Control_L'

  # Add the 3 lines below to use the Right-Control as Caps-Lock
  xmodmap -e 'remove Control = Control_R'
  xmodmap -e 'keysym Control_R = Caps_Lock'
  xmodmap -e 'add Lock = Caps_Lock'

  # Remap Windows Left key and Windows Right key to F keys
  #xmodmap -e 'keysym Super_L = F15'
  #xmodmap -e 'keysym Super_R = F16'
fi


umask 022

