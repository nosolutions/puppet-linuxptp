class linuxptp::service inherits linuxptp {
  service { $ptp4l_service_name:
    ensure     => $ptp4l_service_ensure,
    enable     => $ptp4l_service_enable,
    hasstatus  => true,
    hasrestart => true,
    require    => Package[$linuxptp::package_name]
  }

  service { $phc2sys_service_name:
    ensure     => $phc2sys_service_ensure,
    enable     => $phc2sys_service_enable,
    hasstatus  => true,
    hasrestart => true,
    require    => Package[$linuxptp::package_name]
  }
}
