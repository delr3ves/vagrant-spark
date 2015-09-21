#!/usr/bin/env bash

. /etc/profile

set +x

export HDFS_USER=hdfs
export YARN_USER=yarn
export HISTORY_SERVER_USER=mapred

for slave in $(cat $HADOOP_CONF_DIR/slaves); do
  ssh $slave "su - $HDFS_USER -c \"$HADOOP_PREFIX/sbin/hadoop-daemon.sh --config $HADOOP_CONF_DIR --script hdfs start datanode\"";
  ssh $slave "su - $YARN_USER -c \"$HADOOP_YARN_HOME/sbin/yarn-daemon.sh --config $HADOOP_CONF_DIR start nodemanager\""
done
