#!/bin/bash
while [[ $# -gt 0 ]]
do
key="$1"
case $key in
   -u|--user)
   USR="$2"
   shift
   shift
   ;;
   -p|--pass)
   PASS="$2"
   shift
   shift
   ;;
   -ip|--ip)
   IP="$2"
   shift
   shift
   ;;
   -port|--port)
   PORT="$2"
   shift
   shift
   ;;
esac
done
echo "Transferring the repository of Cassandra, Spark with the deployment configuration on the machine"
sshpass -p $PASS scp -P $PORT $PWD/repositories/cassandra.tar.gz $USR@$IP:/opt
sshpass -p $PASS scp -P $PORT $PWD/repositories/spark.tar.gz $USR@$IP:/opt
sshpass -p $PASS scp -P $PORT $PWD/repositories/jdk.tar.gz $USR@$IP:/opt
sshpass -p $PASS scp -P $PORT $PWD/deploying-service-slave-host.sh $USR@$IP:/opt;
sshpass -p $PASS scp -P $PORT $PWD/cassandra-performance.sh $USR@$IP:/opt;
echo "Transfer autoload files"
sshpass -p $PASS scp -P $PORT $PWD/autostart-service/spark-slave.service $USR@$IP:/etc/systemd/system
sshpass -p $PASS scp -P $PORT $PWD/autostart-service/cassandra.service $USR@$IP:/etc/systemd/system
echo "Deploy Cassandra, Spark on a remote machine"
sshpass -p $PASS ssh $USR@$IP -p $PORT '/opt/deploying-service-slave-host.sh'
sshpass -p $PASS ssh $USR@$IP -p $PORT '/opt/cassandra-performance.sh'