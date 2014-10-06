class redelinux::domain::network
{
  Util::Cfg_file {
    source_prefix => 'network'
  }

  # Fix debian's weird hosts file
  host { $::hostname, $::fqdn:
    ensure => present,
  }

  host { 'localhost':
    ensure       => present,
    ip           => '127.0.0.1',
    host_aliases => [],
  }

  # Fix Debian's stupid habit of not sending hostname on DHCP requests
  if $::operatingsystem == 'Debian' && $::lsbmajrelease < 7
  {
    util::cfg_file { 'dhclient_hostname_hook':
      path   => '/etc/dhcp/dhclient-enter-hooks.d/hostname',
      notify => Service['networking'],
    }

    service { 'networking': }
  }
}
