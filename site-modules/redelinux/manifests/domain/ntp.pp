class redelinux::domain::ntp::client
{
  package { 'ntp':
    ensure => installed
  }
}
