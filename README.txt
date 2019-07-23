#Run the installation scripts on the remote server
install-to-master-host.sh --> deploying-service-master-host.sh
install-to-slave-host.sh --> deploying-service-slave-host.sh
#Works with parameters
./install-to-master-host.sh -u root -p Qwerty123# -ip 192.168.4.71 -port 8888
./install-to-slave-host.sh -u root -p Qwerty123# -ip 192.168.4.72 -port 8888