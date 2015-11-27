class linuxptp::install inherits linuxptp {
  package { $package_name:
    ensure => present,
  }
}
