#!/usr/bin/env sh

## @since20231221
## @author hisa
## gamesite block or not

function blockornot(){

  DOW="`date +%a`" #day of week
  DOT="`date +%H`" #day of hour

  if [ $DOW = "Sat" ] || [ $DOW = "Sun" ] && [ $(( DOT )) -ge 7 ] && [ $(( DOT )) -lt 21 ]; then # from 7 to 21 o'clock on Saturday and Sunday

   echo "gameOK process start"
#gameOK process
   file=/etc/unbound/tmp/gamesite
# sedで置換してファイルを上書き
   while read line || [ -n "${line}" ]; do
#      echo "${line}"
      sed -i -e "/${line}/s/^/#/" /etc/unbound/block/selfadd-ad.conf
#      echo "$(cat /etc/unbound/block/selfadd-ad.conf)"
   done < "${file}"

    echo "gameok process finished"

#no process
  elif [ $DOW = "Mon" ] || [ $DOW = "Tue" ] || [ $DOW = "Wed" ] || [ $DOW = "Thu" ] || [ $DOW = "Fri" ]; then # weekday
       echo "no process"

  else

#gameNG process
   file=/etc/unbound/tmp/gamesite
# sedで置換してファイルを上書き
   while read line || [ -n "${line}" ]; do
#      echo "${line}"
      sed -i -e "/${line}/s/^#//" /etc/unbound/block/selfadd-ad.conf
#      echo "$(cat /etc/unbound/block/selfadd-ad.conf)"
   done < "${file}"

    echo "gameng process finished"

  fi
}

function restart_unbund(){
  [ -e /etc/init.d/unbound ] &&
  /etc/init.d/unbound restart
}

function restart_dnsmasq(){
  [ -e /etc/init.d/dnsmasq ] &&
  /etc/init.d/dnsmasq restart 2>&1 > /dev/null
}

function main(){
  blockornot &&
  restart_unbund &&
  restart_dnsmasq
}

main