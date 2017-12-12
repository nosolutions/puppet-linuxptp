#= Define linuxptp::phc2sys
#
#Creates the configuration for a single instance of phc2sys.
class linuxptp::phc2sys(
  $summary_updates = 0,
  $uds_name        = 'ptp4l',
  $message_tag     = '',
) {
  include ::linuxptp

  validate_numeric($summary_updates)

}
