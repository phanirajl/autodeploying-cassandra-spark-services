#!/bin/bash
echo -n "Enter ip master host: "
read MIP
cd /opt && tar -xvf /opt/cassandra.tar.gz && tar -xvf spark.tar.gz && tar -xvf jdk.tar.gz;

chown -R root:root /opt/cassandra && chown -R root:root /opt/spark && chown root:root /etc/systemd/system/spark-slave.service && chown root:root /etc/systemd/system/cassandra.service && chown -R root:root /opt/jdk;

IP=`ip a s | grep enp | grep "inet" | cut -d "/" -f 1 | cut -c 10-`
sed -i 's/- seeds: "127.0.0.1"/- seeds: "'$MIP'"/' /opt/cassandra/conf/cassandra.yaml;
sed -i 's/listen_address: 127.0.0.1/listen_address: '$IP'/' /opt/cassandra/conf/cassandra.yaml;
sed -i 's/broadcast_rpc_address: 127.0.0.1/broadcast_rpc_address: '$IP'/' /opt/cassandra/conf/cassandra.yaml
grep -lr -e '127.0.0.1' /etc/systemd/system/spark-slave.service | xargs sed -i 's/127.0.0.1/'$MIP'/g';

update-alternatives --install /usr/bin/java java /opt/jdk/bin/java 100;
update-alternatives --install /usr/bin/javac javac /opt/jdk/bin/javac 100;

systemctl daemon-reload;
systemctl enable cassandra.service && systemctl start cassandra.service;
systemctl enable spark-slave.service && systemctl start spark-slave.service;

rm -rf /opt/cassandra.tar.gz && rm -rf /opt/spark.tar.gz && rm -rf /opt/jdk.tar.gz && rm -rf /opt/deploying-service-slave-host.sh;
echo "Unfolded cassandra, spark, substituted ip addresses and deleted unnecessary configs"