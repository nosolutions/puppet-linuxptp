#= Define linuxptp::ptp4l
#
#Creates the configuration for a single instance of ptp4l. The running of this
#instance is best done with supervisord.
define linuxptp::ptp4l(
  $interfaces,
  $network_transport = 'UDPv4',
  $slave_only        = 0,
  $hybrid_e2e        = 0,
) {
  include ::linuxptp

  validate_array($interfaces)
  validate_numeric($slave_only, 1, 0)
  validate_numeric($hybrid_e2e, 1, 0)
  validate_re($network_transport, ['UDPv4', 'UDPv6', 'L2'], "Parameter 'network_transport' must be one of 'UDPv4', 'UDPv6' or 'L2'")

  file { "${::linuxptp::ptp4l_confdir}/${name}.conf":
    ensure  => file,
    content => template("${module_name}/ptp4l.conf.erb"),
  }
}
