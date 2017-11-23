#= Define linuxptp::phc2sys
#
#Creates the configuration for a single instance of phc2sys.
class linuxptp::phc2sys(
  $summary_updates         = 0,
  $uds_name                = 'ptp4l'
) {
  include ::linuxptp

  validate_numeric($summary_updates)

  file { "/etc/sysconfig/phc2sys":
    ensure  => file,
    content => template("${module_name}/phc2sys.erb"),
    notify  => [
      Service[$linuxptp::phc2sys_service_name],
    ],
    require => Package[$linuxptp::package_name]
  }

}
