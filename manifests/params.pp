class linuxptp::params {
  $package_name = 'linuxptp'
  $ptp4l_confdir = '/etc/ptp4l'
  $ptp4l_rundir = '/var/run/ptp4l'
  $logdir = '/var/log/linuxptp'
  $ptp4l_service_name = 'ptp4l'
  $ptp4l_service_ensure = 'running'
  $ptp4l_service_enable = true
  $phc2sys_service_name = 'phc2sys'
  $phc2sys_service_ensure = 'running'
  $phc2sys_service_enable = true
}
