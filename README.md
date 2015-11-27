# linuxptp

#### Table of Contents

1. [Module Description](#module-description)
2. [Setup](#setup)
    * [What linuxptp affects](#what-linuxptp-affects)
    * [Setup requirements](#setup-requirements)
    * [Beginning with linuxptp](#beginning-with-linuxptp)
3. [Usage](#usage)
4. [Limitations](#limitations)
5. [Development](#development)

## Module Description

The linuxptp module manages the Linux PTP Project software (http://linuxptp.sourceforge.net/),
an implementation of the Precision Time Protocol.

## Setup

### What linuxptp affects

* Installs the linuxptp package
* Can configure one or multiple ptp4l instances
* Can manage the ptp4l and phc2sys services, but best run with Supervisor

### Setup Requirements

The linuxptp package can be found in a number of repositories, CentOS 6 has version 1.4.
Personally I recommend at least version 1.6.

### Beginning with linuxptp

The linuxptp package contains three binaries, ptp4l, phc2sys and timemaster. This module
manages ptp4l and phc2sys only. ptp4l can be run as a PTP Ordinary or Boundary Clock, and
phc2sys is used to synchronise one clock with another in a system.

The linuxptp software needs to heavily configured for your environment. A good starting point
is the [project page](http://linuxptp.sourceforge.net/), then the man pages, and you'll need
a reasonable understanding of PTP as well.

The module is designed to be friendly for running multiple ptp4l and phc2sys instances
on the one box using a program like Supervisor. It does this by adding extra config and run
directories so the instances don't step on each other.

You can use the normal services however you will need to take care of getting the right
configuration file and arguments to the right daemons. In Red Hat land this is the
/etc/sysconfig/ptp4l and /etc/sysconfig/phc2sys files, which this module does not manage.

I personally run the software instances with [ajcrowe-supervisord](https://github.com/ajcrowe/puppet-supervisord),
I have an example of this on a [blog post](http://catach.blogspot.co.uk/2015/11/solving-mifid-ii-clock-synchronisation_28.html).

## Usage

Stop the standard linuxptp services, create a configuration file for a ptp4l instance, and run two supervisord programs,
one for ptp4l and one to synchronise the eth0 clock to eth1:

~~~ puppet
class { 'linuxptp':
  ptp4l_service_ensure   => 'stopped',
  ptp4l_service_enable   => false,
  phc2sys_service_ensure => 'stopped',
  phc2sys_service_enable => false,
}
linuxptp::ptp4l { 'master-clock':
  interfaces => [ 'eth0', 'eth1' ],
}
supervisord::program { 'master-clock':
  command => '/usr/sbin/ptp4l -f /etc/ptp4l/master-clock.conf',
}
supervisord::program { 'clock-sync':
  command => '/usr/sbin/phc2sys -s eth0 -c eth1 -w -z /var/run/ptp4l/master-clock',
}
~~~

### Logging

By default the module uses [rodjek-logrotate](https://github.com/rodjek/puppet-logrotate.git) to rotate
log files under /var/log/linuxptp. You can disable this like so:

~~~ puppet
class { 'linuxptp':
  manage_logrotate_rule => false,
}
~~~

Both ptp4l and phc2sys will take the -q (suppress syslog) and -m (write to stdout).
You can then use supervisord's logging facilities to send output to the common log
directory:

~~~ puppet
supervisord::program { 'clock-sync':
  command => '/usr/sbin/phc2sys -q -m -s eth0 -c eth1 -w -z /var/run/ptp4l/master-clock',
  stdout_logfile          => '/var/log/linuxptp/clock-sync.log',
  redirect_stderr         => true,
  stdout_logfile_maxbytes => 0,
  stdout_logfile_backups  => 0,
}
~~~

## Limitations

The module is tested against CentOS 6. It should work in most other flavours, and I'm
happy to accept pull requests for other distros.

## Development

We will accept pull requests from GitHub.
