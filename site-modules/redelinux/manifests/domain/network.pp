class redelinux::domain::network
{
  Cfg_file {
    source_prefix => 'network'
  }

  host { 'localhost':
    ensure       => present,
    ip           => '127.0.0.1',
    host_aliases => [$::hostname, $::fqdn]
  }

  # Fix Debian's stupid habit of not sending hostname on DHCP requests
  if $::operatingsystem == 'Debian' && $::lsbmajrelease < 7
  {
    cfg_file { '/etc/dhcp/dhclient-enter-hooks.d/hostname':
      ensure => present,
      notify => Service['networking']
    }

    service { 'networking': }
  }
}
