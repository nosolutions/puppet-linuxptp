class linuxptp::config(
  $manage_logrotate_rule = $linuxptp::manage_logrotate_rule
) inherits linuxptp {
  file { $ptp4l_confdir:
    ensure => directory,
  }

  file { $ptp4l_rundir:
    ensure => directory,
  }

  file { $logdir:
    ensure => directory,
  }

  if ($manage_logrotate_rule) {
    logrotate::rule { 'linuxptp':
      path         => '/var/log/linuxptp/*.log',
      compress     => true,
      copytruncate => true,
      missingok    => true,
      rotate_every => 'day',
      rotate       => 7,
    }
  }
}
