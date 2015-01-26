#! /bin/sh
#
#       /etc/rc.d/init.d/logstash
#
#       Starts Logstash as a daemon
#
# chkconfig: 2345 20 80
# description: Starts Logstash as a daemon
# pidfile: /var/run/logstash-agent.pid

### BEGIN INIT INFO
# Provides: logstash
# Required-Start: $local_fs $remote_fs
# Required-Stop: $local_fs $remote_fs
# Default-Start: 2 3 4 5
# Default-Stop: S 0 1 6
# Short-Description: Logstash
# Description: Starts Logstash as a daemon.
# Modified originally from https://gist.github.com/2228905#file_logstash.sh

### END INIT INFO

# Location of logstash files
LOCATION={{ installation_path }}

if [ ! -d $LOCATION ];then
        exit
fi

PATH=${JAVA_HOME}/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
DESC="Logstash Web Daemon"
LOGSTASH_BIN={{ installation_path }}/logstash-{{ logstash_version }}/bin/logstash-web
SCRIPTNAME=/etc/init.d/logstash-web
PIDFILE=/var/run/logstash-web.pid
base=logstash

# Exit if the package is not installed
if [ ! -x "$JAVA_HOME/bin/java" ]; then
{
  echo "Couldn't find java executable. Please, setup your JAVA_HOME"
  exit 99
}
fi

. /etc/init.d/functions

#
# Function that starts the daemon/service
#
do_start()
{
  cd $LOCATION && \
  (su - {{ service_user }} -c "export JAVA_HOME=$JAVA_HOME && $LOGSTASH_BIN &>/dev/null &") \
  && success || failure
}

set_pidfile()
{
  sleep 5s # wait for 5 sec till the proccess gets started
  pgrep -f "java.*?logstash.*?web" > $PIDFILE
}

#
# Function that stops the daemon/service
#
do_stop()
{
  pid=`cat $PIDFILE`
                       if checkpid $pid 2>&1; then
                           # TERM first, then KILL if not dead
                           kill -TERM $pid >/dev/null 2>&1
                           usleep 100000
                           if checkpid $pid && sleep 1 &&
                              checkpid $pid && sleep $delay &&
                              checkpid $pid ; then
                                kill -KILL $pid >/dev/null 2>&1
                                usleep 100000
                           fi
                        fi
                        checkpid $pid
                        RC=$?
                        [ "$RC" -eq 0 ] && failure $"$base shutdown" || success $"$base shutdown"

}

case "$1" in
  start)
    echo -n "Starting $DESC: "
    do_start
    touch /var/lock/subsys/web-{{ logstash_version }}
    set_pidfile
    ;;
  stop)
    echo -n "Stopping $DESC: "
    do_stop
    rm /var/lock/subsys/web-{{ logstash_version }}
    rm $PIDFILE
    ;;
  restart|reload)
    echo -n "Restarting $DESC: "
    do_stop
    do_start
    touch /var/lock/subsys/web-{{ logstash_version }}
    set_pidfile
    ;;
  status)
    status -p $PIDFILE
    ;;
  *)
    echo "Usage: $SCRIPTNAME {start|stop|status|restart}" >&2
    exit 3
    ;;
esac

echo
exit 0