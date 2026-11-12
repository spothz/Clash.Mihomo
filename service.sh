until [ $(getprop init.svc.bootanim) = "stopped" ] ; do
    sleep 5
done

service_path=`realpath $0`
module_dir=`dirname ${service_path}`
data_dir="/data/clash"
scripts_dir="${data_dir}/scripts"
Clash_data_dir="/data/clash"
Clash_run_path="${Clash_data_dir}/run"
Clash_pid_file="${Clash_run_path}/clash.pid"
busybox_path=$(cat "/data/adb/modules/Clash.Mihomo/busybox")

if [ -f ${Clash_pid_file} ] ; then
    rm -rf ${Clash_pid_file}
fi
rm -rf ${Clash_run_path}/run.logs
nohup ${busybox_path} crond -c ${Clash_run_path} > /dev/null 2>&1 &

# Watch Magisk's module enable/disable flag and manage Mihomo according to Wi-Fi.
inotifyd ${scripts_dir}/clash.inotify ${module_dir} >> /dev/null &
if [ ! -f "${module_dir}/disable" ]; then
    nohup ${scripts_dir}/clash.wifi "${module_dir}" > /dev/null 2>&1 &
fi
