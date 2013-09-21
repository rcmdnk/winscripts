#!/bin/sh
mkdir -p ~/tmp
ps -u ${USER}|grep ssh|grep -v agent|grep -v sshd |grep -v grep> ~/tmp/.tmptunnel
while read LINE;do
  echo $LINE
  TTY=`echo ${LINE}|awk '{print $5}'`
  echo $TTY
  if [ ${TTY} = '?' ];then
    PID=`echo ${LINE}|awk '{print $1}'`
    echo $PID
    kill -kill ${PID}
  fi
done < ~/tmp/.tmptunnel
rm -f ~/tmp/.tmptunnel

