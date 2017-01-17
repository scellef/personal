function git-grab {
  cd "$*" ; git pull ; cd -
}

function git-stat {
  cd "$*" ; git status -s ; cd - > /dev/null
}

function tcp {
  cat < /dev/tcp/"$1"/"$2"
}

function udp {
  cat < /dev/udp/"$1"/"$2"
}

function sslv {
  hostname="$1"
  port="$2"
  if [ -z $port ] ; then
    port="443"
  fi
  openssl s_client -connect $hostname:$port -showcerts < /dev/null 2> /dev/null |
  openssl x509 -subject -issuer -dates -noout
}

function sslvv {
  hostname="$1"
  port="$2"
  if [ -z $port ] ; then
    port="443"
  fi
  openssl s_client -connect $1:$2 -showcerts < /dev/null 2> /dev/null |
  openssl x509 -noout -text
}

function man {
  env \
  LESS_TERMCAP_mb=$(printf "\e[1;35m") \
  LESS_TERMCAP_md=$(printf "\e[1;36m") \
  LESS_TERMCAP_me=$(printf "\e[0m") \
  LESS_TERMCAP_se=$(printf "\e[0m") \
  LESS_TERMCAP_so=$(printf "\e[1;47;30m") \
  LESS_TERMCAP_ue=$(printf "\e[0m") \
  LESS_TERMCAP_us=$(printf "\e[1;33m") \
  man "$@"
}

function grepe {
  # Print entire file to stdout with regex highlighted
  grep -E "$1|$" $2
}

function batt {
  if [ -d /sys/class/power_supply/BAT0/ ] ; then
    . /sys/class/power_supply/BAT0/uevent 2> /dev/null
    echo $(bc <<< "scale=2 ; 100 * $POWER_SUPPLY_CHARGE_NOW / $POWER_SUPPLY_CHARGE_FULL")% remaining
  else
    echo 'WARNING: Could not detect battery... Are you on a laptop?'
  fi
}

function randomstring {
  [ $1 -gt 0 ] 2> /dev/null && length=$1 || length='24'
  cat /dev/urandom | tr -cd '[:alnum:]' | head -c $length ; echo
}


# In case there local aliases I'd rather not publish to Github
if [ -f ~/.bash_functions.local ] ; then
  . ~/.bash_functions.local
fi

# vim: filetype=sh:ts=2:sw=2:expandtab
