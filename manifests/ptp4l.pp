#= Define linuxptp::ptp4l
#
#Creates the configuration for a single instance of ptp4l. The running of this
#instance is best done with supervisord.
define linuxptp::ptp4l(
  $interfaces,
  $network_transport       = 'UDPv4',
  $slave_only              = 0,
  $hybrid_e2e              = 0,
  $clock_servo             = 'pi',
  $udp_ttl                 = 1,
  $logAnnounceInterval     = 1,
  $logSyncInterval         = 0,
  $logMinDelayReqInterval  = 0,
  $logMinPdelayReqInterval = 0,
  $delay_mechanism         = "E2E",
  $time_stamping           = "hardware",
) {
  include ::linuxptp

  validate_array($interfaces)
  validate_numeric($slave_only, 1, 0)
  validate_numeric($hybrid_e2e, 1, 0)
  validate_re($network_transport, ['UDPv4', 'UDPv6', 'L2'], "Parameter 'network_transport' must be one of 'UDPv4', 'UDPv6' or 'L2'")
  validate_re($clock_servo, ['pi', 'linreg', 'ntpshm', 'nullf'], "Parameter 'clock_servo' must be one of 'pi', 'linreg', 'ntpshm' or 'nullf'")
  validate_re($delay_mechanism, ['E2E', 'P2P'], "Parameter 'delay_mechanism' must be one of 'E2E' or 'P2P'")
  validate_re($time_stamping, ['hardware', 'software'], "Parameter 'time_stamping' must be one of 'hardware' or 'software'")
  validate_numeric($udp_ttl, 1024, 1)
  validate_numeric($logAnnounceInterval, 16, -8)
  validate_numeric($logSyncInterval, 16, -8)
  validate_numeric($logMinDelayReqInterval, 16, -8)
  validate_numeric($logMinPdelayReqInterval, 16, -8)

  file { "${::linuxptp::ptp4l_confdir}/${name}.conf":
    ensure  => file,
    content => template("${module_name}/ptp4l.conf.erb"),
  }
}
