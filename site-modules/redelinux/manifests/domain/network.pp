class redelinux::network
{
  include redelinux::params

  Redelinux::Util::Cfg_file {
    source_prefix => "network"
  }

  # Fix debian's weird hosts file
  host { $::hostname:
    ensure => absent,
  }

  host { 'localhost':
    ensure       => present,
    ip           => '127.0.0.1',
    host_aliases => [],
  }

  # Fix Debian's stupid habit of not sending hostname on DHCP requests
  if $redelinux::params::debian_pre_wheezy
  {
    util::cfg_file { 'dhclient_hostname_hook':
      path   => '/etc/dhcp/dhclient-enter-hooks.d/hostname',
      notify => Service['networking'],
    }

    service { 'networking': }
  }
}
