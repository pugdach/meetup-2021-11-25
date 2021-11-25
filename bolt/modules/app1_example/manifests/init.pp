# @summary A short summary of the purpose of this class
#
# A description of what this class does
#
# @example
#   include app1
class app1_example {
  package { 'ntp':
    ensure => present,
  }
  file { '/etc/ntp.conf':
    ensure => file,
    mode   => '0644',
    source => 'puppet:///modules/app1/ntp.cfg',
  }
  service { 'ntpd':
    ensure => running,
    enable => true,
  }
}

