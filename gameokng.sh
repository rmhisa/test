#!/usr/bin/env sh

## @since20231221
## @author hisa
## gamesite block or not

function blockornot(){

  DOW="`date +%a`" #day of week
  DOT="`date +%H`" #day of hour

  if [ $DOW = "Sat" ] || [ $DOW = "Sun" ] && [ $((DOT)) -ge 7 ] && [ $((DOT)) -lt 21 ]; then # from 7 to 21 o'clock on Saturday and Sunday


#gameOK process
# gamesiteの内容とself-ad.confを比較し、一致する行番号を取得
   lines=$(grep -n -f /etc/unbound/tmp/gamesite /etc/unbound/block/selfadd-ad.conf | sed -e 's/:.*//g')
 # sedで置換してファイルを上書き
   for line in "${lines}"; do
     sed -e "s/^/#/" "$line" /etc/unbound/block/selfadd-ad.conf -i /etc/unbound/block/selfadd-ad.conf
done

    echo "gameng process finished"

  fi
}


  elif [ $DOW = "Mon" ] || [ $DOW = "Tue" ] || [ $DOW = "Wed" ] || [ $DOW = "Thu" ] || [ $DOW = "Fri" ]; then # weekday
       echo "no process"

  else

#gameNG process
# gamesiteの内容とself-ad.confを比較し、一致する行番号を取得
   lines=$(grep -n -f /etc/unbound/tmp/gamesite /etc/unbound/block/selfadd-ad.conf | sed -e 's/:.*//g')
 # sedで置換してファイルを上書き
   for line in "${lines}"; do
     sed -e "s/^#//" "$line" /etc/unbound/block/selfadd-ad.conf -i /etc/unbound/block/selfadd-ad.conf
done

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