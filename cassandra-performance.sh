#TCP activity timeout values
sudo sysctl -w \
net.ipv4.tcp_keepalive_time=60 \
net.ipv4.tcp_keepalive_probes=3 \
net.ipv4.tcp_keepalive_intvl=10;
#Values ​​for handling thousands of simultaneous connections
sudo sysctl -w \
net.core.rmem_max=16777216 \
net.core.wmem_max=16777216 \
net.core.rmem_default=16777216 \
net.core.wmem_default=16777216 \
net.core.optmem_max=40960 \
net.ipv4.tcp_rmem='4096 87380 16777216' \
net.ipv4.tcp_wmem='4096 65536 16777216';
#Set user resource limits
SearchTerm="pam_limits.so"
FileToSearch=/etc/pam.d/su
if grep $SearchTerm $FileToSearch; then
   echo "$SearchTerm there is such a line"
else
   echo "$SearchTerm not found, added setting to the end of the file"
   echo "session         required        pam_limits.so" >> $FileToSearch
   echo -e 'root - memlock unlimited\nroot - nofile 1048576\nroot - nproc 32768\nroot - as unlimited' >> /etc/security/limits.conf
fi
sudo sysctl -p
#Persist updated settings
SearchTerm="vm.max_map_count"
FileToSearch=/etc/sysctl.conf
if grep $SearchTerm $FileToSearch; then
   echo "$SearchTerm there is such a line"
else
   echo "$SearchTerm not found, added setting to the end of the file"
cat <<EOF > $FileToSearch
vm.max_map_count=1048575
net.ipv4.tcp_keepalive_time=60
net.ipv4.tcp_keepalive_probes=3
net.ipv4.tcp_keepalive_intvl=10
net.core.rmem_max=16777216
net.core.wmem_max=16777216
net.core.rmem_default=16777216
net.core.wmem_default=16777216
net.core.optmem_max=40960
net.ipv4.tcp_rmem=4096 87380 16777216
net.ipv4.tcp_wmem=4096 65536 16777216
EOF
fi
sudo sysctl -p /etc/sysctl.conf
#Disable CPU frequency scaling
for CPUFREQ in /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor
do
    [ -f $CPUFREQ ] || continue
    echo -n performance > $CPUFREQ
done
#Disable zone_reclaim_mode on NUMA systems
echo 0 > /proc/sys/vm/zone_reclaim_mode
#Disable swap
sudo swapoff --all