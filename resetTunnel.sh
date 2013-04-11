#!/bin/sh
mkdir -p ~/tmp
ps -u ${USER}|grep /usr/bin/ssh > ~/tmp/.tmptunnel
while read LINE;do
  TTY=`echo ${LINE}|awk '{print $5}'`
  if [ ${TTY} = '?' ];then
    PID=`echo ${LINE}|awk '{print $1}'`
    kill -kill ${PID}
  fi
done < ~/tmp/.tmptunnel
rm -f ~/tmp/.tmptunnel

