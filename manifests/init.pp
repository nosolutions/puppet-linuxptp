# == Class: linuxptp
class linuxptp(
  $package_name            = $linuxptp::params::package_name,
  $ptp4l_service_name      = $linuxptp::params::ptp4l_service_name,
  $ptp4l_service_ensure    = $linuxptp::params::ptp4l_service_ensure,
  $ptp4l_service_enable    = $linuxptp::params::ptp4l_service_enable,
  $phc2sys_service_name    = $linuxptp::params::phc2sys_service_name,
  $phc2sys_service_ensure  = $linuxptp::params::phc2sys_service_ensure,
  $phc2sys_service_enable  = $linuxptp::params::phc2sys_service_enable,
  $logdir                  = $linuxptp::params::logdir,
  $manage_logrotate_rule   = true,
) inherits linuxptp::params {
  contain linuxptp::install
  contain linuxptp::config
  contain linuxptp::service
}
