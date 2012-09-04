#!/usr/bin/env bash

current_path=`cd "$(dirname "$0")"; pwd`
. $current_path/function.sh

pid=$current_path/tmp/unicorn-teamkn.pid

cd $current_path

case "$1" in
  start)
        assert_process_from_pid_file_not_exist $pid
        echo "start"
        unicorn_rails -c config/unicorn.rb -E production -D
        command_status  
  ;;
  stop)
    echo "stop"
    kill `cat $pid`
    command_status  
  ;;
  usr2_stop)
    echo "usr2_stop"
    kill -USR2 `cat $pid`
    command_status
  ;;
  restart)
    echo "restart"
    cd $current_path
    $0 "$1" stop
    sleep 1
    $0 "$1" start
  ;;
  *)
  echo "tip:(start|stop|restart|usr2_stop)"
  exit 5
  ;;
esac
exit 0

