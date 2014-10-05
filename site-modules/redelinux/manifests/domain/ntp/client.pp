class redelinux::ntp::client(
  $servers)
{
  class { ntp:
    servers => $servers,
    restrict => [
      '-4 default ignore',
      '-6 default ignore',
      '127.0.0.1',
      '::1'
    ],
    disable_monitor => true
  }
  contain ntp
}
