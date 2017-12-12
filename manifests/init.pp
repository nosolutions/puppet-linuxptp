# == Class: linuxptp
class linuxptp(
  $single_instance             = true,
  $conf_file                   = '/etc/ptp4l.conf',
  $interfaces                  = undef,
  $network_transport           = 'UDPv4',
  $slave_only                  = 0,
  $hybrid_e2e                  = 0,
  $clock_servo                 = 'pi',
  $udp_ttl                     = 1,
  $log_announce_interval       = 1,
  $log_sync_interval           = 0,
  $log_min_delay_req_interval  = 0,
  $log_min_pdelay_req_interval = 0,
  $delay_mechanism             = 'E2E',
  $time_stamping               = 'hardware',
  $summary_interval            = 0,
  $summary_updates             = 0,
  $package_name                = 'linuxptp',
  $ptp4l_confdir               = '/etc/ptp4l',
  $ptp4l_rundir                = '/var/run/ptp4l',
  $ptp4l_service_name          = 'ptp4l',
  $ptp4l_service_ensure        = 'running',
  $ptp4l_service_enable        = true,
  $phc2sys_service_name        = 'phc2sys',
  $phc2sys_service_ensure      = 'running',
  $phc2sys_service_enable      = true,
  $logdir                      = '/var/log/linuxptp',
  $manage_sysconfig            = true,
  $manage_logrotate_rule       = true,
  $message_tag                 = '',
) {
  package { $package_name:
    ensure => present,
  }

  if ($single_instance) {
    if ($manage_sysconfig) {
      file { '/etc/sysconfig/ptp4l':
        ensure  => file,
        content => template("${module_name}/ptp4l.erb"),
        notify  => [
          Service[$ptp4l_service_name],
          Service[$phc2sys_service_name],
        ],
      }

      file { '/etc/sysconfig/phc2sys':
        ensure  => file,
        content => template("${module_name}/phc2sys.erb"),
        notify  => Service[$phc2sys_service_name],
        require => Package[$package_name],
      }
    }
    linuxptp::ptp4l { 'default':
      single_instance             => $single_instance,
      filename                    => $conf_file,
      interfaces                  => $interfaces,
      network_transport           => $network_transport,
      slave_only                  => $slave_only,
      hybrid_e2e                  => $hybrid_e2e,
      clock_servo                 => $clock_servo,
      udp_ttl                     => $udp_ttl,
      log_announce_interval       => $log_announce_interval,
      log_sync_interval           => $log_sync_interval,
      log_min_delay_req_interval  => $log_min_delay_req_interval,
      log_min_pdelay_req_interval => $log_min_pdelay_req_interval,
      delay_mechanism             => $delay_mechanism,
      time_stamping               => $time_stamping,
      summary_interval            => $summary_interval,
      message_tag                 => $message_tag,
      require                     => Package[$package_name],
    }

    service { $ptp4l_service_name:
      ensure     => $ptp4l_service_ensure,
      enable     => $ptp4l_service_enable,
      hasstatus  => true,
      hasrestart => true,
      require    => Linuxptp::Ptp4l['default'],
    }

    service { $phc2sys_service_name:
      ensure     => $phc2sys_service_ensure,
      enable     => $phc2sys_service_enable,
      hasstatus  => true,
      hasrestart => true,
      require    => Linuxptp::Ptp4l['default'],
    }
  } else {
    file { [ $ptp4l_confdir, $ptp4l_rundir, $logdir ]:
      ensure => directory,
    }

    if ($manage_logrotate_rule) {
      logrotate::rule { 'linuxptp':
        path         => "${logdir}/*.log",
        compress     => true,
        copytruncate => true,
        missingok    => true,
        rotate_every => 'day',
        rotate       => 7,
      }
    }

    service { [$ptp4l_service_name, $phc2sys_service_name ]:
      ensure     => stopped,
      enable     => false,
      hasstatus  => true,
      hasrestart => true,
    }
  }
}
