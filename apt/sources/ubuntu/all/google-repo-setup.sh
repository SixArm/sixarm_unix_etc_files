#!/bin/bash
#
# Copyright 2007 Google Inc. All Rights Reserved.

KEYNAME=linux_signing_key.pub
PUBKEYURL="https://dl-ssl.google.com/linux/$KEYNAME"
REPOURL="http://dl.google.com/linux"
DEBREPO="$REPOURL/deb"
RPMREPO="$REPOURL/rpm"
ARCH=$(uname -m)
DRYRUN=0

export PATH=/bin:/usr/bin:/usr/local/bin:/sbin:/usr/sbin:/usr/local/sbin

usage () {
  echo "Usage: $(basename $0) [-h] [-n]"
  echo "-n  Don't make any chanages, just show what would happen."
  echo "-h  Show this help message."
}

writetempfile () {
  if [ $DRYRUN -eq 0 ]; then
    TEMPFILE=$(mktemp -q)
    if [ $? -ne 0 ]; then
      echo "ERROR: couldn't create temp file."
      exit 1
    fi
    TEMPFILES="$TEMPFILES \"$TEMPFILE\""
    FN="$TEMPFILE"
  else
    FN=/dev/stdout
    # So we have something to print during dry run.
    TEMPFILE="dry-run"
  fi

  while [ $# -gt 0 ]; do
    echo "$1" >> "$FN"
    shift
  done
}

# Start with 2 because sudo/su use 0/1 internally for return values.
ROOTEXITBASE=2
ROOTEXITLAST=$ROOTEXITBASE
ROOTCOMMANDS=""
declare -a HANDLERS
queuecmd () {
  local OPTNAME
  local OPTIND

  while getopts ":e:" OPTNAME
  do
    case $OPTNAME in
      e )
        HANDLERS[$ROOTEXITLAST]="$OPTARG"
      ;;
    esac
  done
  shift $(($OPTIND - 1))

  CMD=$1
  shift

  local ARGS=""
  while [ $# -gt 0 ]; do
    ARGS="$ARGS\"$1\" "
    shift
  done

  if [ $DRYRUN -eq 0 ]; then
    if [ "${HANDLERS[$ROOTEXITLAST]}" ]; then
      ROOTCOMMANDS="$ROOTCOMMANDS $CMD $ARGS || RETVAL=\$((RETVAL+$((2**ROOTEXITLAST++)))) ;"
    else
      ROOTCOMMANDS="$ROOTCOMMANDS $CMD $ARGS;"
    fi
  else
    echo "DRY-RUN: $CMD $ARGS"
  fi
}

handlerooterror () {
  EXITCODE=$1
  while [ $((ROOTEXITLAST--)) -ge $ROOTEXITBASE ]; do
    if [ $((2**$ROOTEXITLAST & $EXITCODE)) -ne 0 ]; then
      if [ "${HANDLERS[$ROOTEXITLAST]}" ]; then
        ${HANDLERS[$ROOTEXITLAST]}
      else
        echo
        echo "ERROR: Unhandled exit code from root shell: $1."
      fi
    fi
  done
}

see_webdocs () {
  echo "Please see http://www.google.com/linuxrepositories/index.html"
  echo "for information on configuring your system manually."
}

repoconfig_error () {
  echo
  echo "ERROR: Couldn't configure repository settings in '$1'."
  see_webdocs
  echo
}

keyadd_error () {
  echo
  echo "ERROR: The package signing key could not be installed."
  see_webdocs
  echo
}

repoapp_error () {
  echo
  echo "ERROR: Couldn't configure repository using $1."
  see_webdocs
  echo
}

configRPM () {
  queuecmd echo "Installing Google package signing key for RPM..."
  queuecmd -e keyadd_error rpm --import $KEYFILE
}


#=========
# MAIN
#=========
while getopts ":nh" OPTNAME
do
  case $OPTNAME in
    n )
      DRYRUN=1
      echo "--------------------------------------------------------------"
      echo "Performing dry run. No changes will be made to your system."
      echo "--------------------------------------------------------------"
      echo
      ;;
    h )
      usage
      exit 0
      ;;
    \: )
      echo "'-$OPTARG' needs an argument."
      usage
      exit 1
      ;;
    * )
      echo "ERROR: invalid command-line option: $OPTARG"
      echo
      usage
      exit 1
      ;;
  esac
done
shift $(($OPTIND - 1))

# Try to detect the package manager based on distro rules. We could try to
# detect the package management programs directly, but that might be confusing
# if a system has more than one installed (e.g. an APT-based system might have
# rpm installed to be LSB-compliant).
if [ ! "$PACKAGEMANAGER" ]; then
if [ -f /etc/lsb-release ]; then
  eval $(sed -e '/DISTRIB_ID/!d' /etc/lsb-release)
  case $DISTRIB_ID in
  *buntu)
    PACKAGEMANAGER=apt
    ;;
  esac
fi
fi

if [ ! "$PACKAGEMANAGER" ]; then
if [ -f /etc/debian_release ] || [ -f /etc/debian_version ]; then
  PACKAGEMANAGER=apt
fi
fi

if [ ! "$PACKAGEMANAGER" ]; then
if [ -f /etc/fedora-release ]; then
  PACKAGEMANAGER=yum
fi
fi

if [ ! "$PACKAGEMANAGER" ]; then
if [ -f /etc/SuSE-release ]; then
  PACKAGEMANAGER=yast
fi
fi

if [ ! "$PACKAGEMANAGER" ]; then
if [ -f /etc/mandriva-release ]; then
  PACKAGEMANAGER=urpmi
fi
fi

if [ ! "$PACKAGEMANAGER" ]; then
if [ -f /etc/redhat-release ] || [ -f /etc/redhat_version ]; then
  PACKAGEMANAGER=rpm
fi
fi

if [ ! "$PACKAGEMANAGER" ]; then
  echo "ERROR: Unsupported or unknown package management system."
  see_webdocs
  exit 1
else
  echo "Configuring for '$PACKAGEMANAGER' package manager."
fi
echo

FETCHCMD=""
if [ ! "$FETCHCMD" ]; then
  FETCHPROG=$(which curl 2>/dev/null)
  if [ "$FETCHPROG" ]; then
    FETCHCMD="$FETCHPROG -s $PUBKEYURL"
  fi
fi
if [ ! "$FETCHCMD" ]; then
  FETCHPROG=$(which wget 2>/dev/null)
  if [ "$FETCHPROG" ]; then
    FETCHCMD="$FETCHPROG -q -O - $PUBKEYURL"
  fi
fi
if [ ! "$FETCHCMD" ]; then
  FETCHPROG=$(which w3m 2>/dev/null)
  if [ "$FETCHPROG" ]; then
    FETCHCMD="$FETCHPROG -dump_source $PUBKEYURL"
  fi
fi
if [ ! "$FETCHCMD" ]; then
  FETCHPROG=$(which links 2>/dev/null)
  if [ "$FETCHPROG" ]; then
    FETCHCMD="$FETCHPROG -source $PUBKEYURL"
  fi
fi
if [ ! "$FETCHCMD" ]; then
  FETCHPROG=$(which lynx 2>/dev/null)
  if [ "$FETCHPROG" ]; then
    FETCHCMD="$FETCHPROG -source $PUBKEYURL"
  fi
fi

if [ ! "$FETCHCMD" ]; then
  echo "ERROR: Couldn't find a program to use to download signing key."
  echo "ERROR: Please install wget, curl, w3m, links, or lynx."
  exit 1
else
  echo "Using '$FETCHPROG' to download key."
fi
echo

if [ $DRYRUN -eq 0 ]; then
  $FETCHCMD > $KEYNAME
  if [ $? -eq 0 ]; then
    chmod a+r $KEYNAME
    KEYFILE="$(pwd)/$KEYNAME"
  else
    echo "ERROR: Failed to download Google key from $PUBKEYURL."
    exit 1
  fi
else
  # So we have something to print during dry run.
  KEYFILE="dry-run"
fi
echo "Key file is '$KEYFILE'."
echo

case $PACKAGEMANAGER in
  apt)
    APTKEYPROG=$(which apt-key 2>/dev/null)
    # If they don't have apt-key, it's not secure APT, so they can't check
    # package sigs.
    if [ ! "$APTKEYPROG" ]; then
      echo "WARNING: You don't appear to be running a signature-aware version of APT."
      echo "WARNING: The Google package signing key won't be installed,"
      echo "WARNING: and package downloads won't be validated."
      echo
    else
      queuecmd echo "Installing Google package signing key..."
      queuecmd -e keyadd_error $APTKEYPROG add "$KEYFILE"
    fi

    queuecmd echo "Adding Google repository to APT sources..."
    DEBLINE="deb $DEBREPO/ stable non-free main"

    eval `apt-config shell APTBASEDIR "Dir" APTDIRETC "Dir::Etc" APTSOURCELIST "Dir::Etc::sourcelist" APTSOURCELISTD "Dir::Etc::sourceparts"`
    # Try to keep our customizations separate.
    if [ "$APTSOURCELISTD" ]; then
      LISTFILE="$APTBASEDIR$APTDIRETC$APTSOURCELISTD/google.list"
      writetempfile \
        "# Google software repository" \
        "$DEBLINE"
      queuecmd -e "repoconfig_error $LISTFILE" cp -f "$TEMPFILE" "$LISTFILE"
      queuecmd chmod a+r "$LISTFILE"

    # Otherwise use the global sources.list.
    else
      LISTFILE="$APTBASEDIR$APTDIRETC$APTSOURCELIST"
      # Don't add it if it's already there.
      grep -q -s "^$DEBLINE" "$LISTFILE"
      if [ $? -gt 0 ]; then
        writetempfile "" \
          "# Google software repository" \
          "$DEBLINE"
        queuecmd -e "repoconfig_error $LISTFILE" sh -c "cat '$TEMPFILE' >> '$LISTFILE'"
      fi
    fi
    queuecmd echo "added to '$LISTFILE'"
    echo

    # Refresh the index files to make sure our apps show up immediately.
    queuecmd echo "Syncing repository index..."
    queuecmd apt-get -qq update
    ;;

  yum)
    configRPM
    if [ -d "/etc/yum.repos.d" ]; then
      queuecmd echo "Adding Google repository to YUM configs..."
      # On x86_64 distro, hardcode the arch of the repository.
      if [ "$ARCH" = "x86_64" ]; then
        YUMARCH="i386"
      else
        YUMARCH="\$basearch"
      fi
      REPOFILE=/etc/yum.repos.d/google.repo
      writetempfile \
        "[google]" \
        "name=Google - $YUMARCH" \
        "baseurl=$RPMREPO/stable/$YUMARCH" \
        "enabled=1" \
        "gpgcheck=1"
      queuecmd -e "repoconfig_error $REPOFILE" cp -f "$TEMPFILE" "$REPOFILE"
      queuecmd chmod a+r "$REPOFILE"
      queuecmd echo "created '$REPOFILE'"
    else
      echo "WARNING: YUM repository configs not found."
      echo "WARNING: Google repository will not be added."
    fi
    echo
    ;;

  yast)
    # Don't need to do rpm key install separately since yast should find
    # repomd.xml.asc file automatically.
    queuecmd echo "Adding Google repository to YaST2 configs..."
    queuecmd -e "repoapp_error zypper" \
      zypper sa -t YUM $RPMREPO/stable/i386 google
    echo
    ;;

  urpmi)
    # Don't need to do rpm key install separately since urpmi should find pubkey
    # file automatically.
    queuecmd echo "Adding Google repository to urpmi configs..."
    queuecmd -e "repoapp_error urpmi.addmedia" \
      urpmi.addmedia google $RPMREPO/stable/i386 with hdlist.cz
    echo
    ;;

  rpm)
    echo "WARNING: Unable to configure this system to use Google's APT or YUM
    repositories."
    echo
    configRPM
    ;;
esac

SHELLCMD="RETVAL=0 ; $ROOTCOMMANDS exit \$RETVAL"

# If this isn't a dry run, and we're not root yet, become root to run the
# queued commands.
if [ "$ROOTCOMMANDS" ] && [ `id -u` != '0' ]; then
  echo "WARNING: You are not running as root, but repository configuration"
  echo "WARNING: requires root privileges."
  echo
  echo "Attempting to become root..."

  # Try sudo. Some systems don't have users configured in /etc/sudoers by
  # default. Mandriva doesn't even install sudo by default.
  SUDOPRG=$(which sudo 2>/dev/null)
  if [ "$SUDOPRG" ]; then
    echo "Trying 'sudo'. Enter your password when prompted."
    $SUDOPRG -k
    $SUDOPRG sh -c "$SHELLCMD"
    res=$?
  else
    res=1
  fi
  if [ $res -eq 1 ]; then
    echo
    echo "WARNING: Failed to invoke 'sudo'."
    # Try su. This won't work on systems that don't have a root password by
    # default (e.g. Ubuntu), but those should have sudo configured by default.
    echo "Trying 'su'. Enter root's password when prompted."
    su root -c "$SHELLCMD"
    res=$?
    if [ $res -eq 1 ]; then
      echo
      echo "ERROR: Could not gain root privileges."
      echo "ERROR: Please re-run from a root login."
      exit 1
    fi
  fi

  # Check if root shell exited with one of our errors.
  if [ $res -ge $ROOTEXITBASE ]; then
    handlerooterror $res
    exit $res
  fi
elif [ "$ROOTCOMMANDS" ]; then
  sh -c "$SHELLCMD"
fi

# Cleanup.
if [ "$TEMPFILES" ]; then
  eval "rm $TEMPFILES"
fi
echo
echo "Done."

