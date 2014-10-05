class redelinux::ntp::server(
  $servers,
  $subnet_ip,
  $subnet_mask)
{
  class { ntp:
    servers => $servers,
    restrict => [
      '-4 default ignore',
      '-6 default ignore',
      "${subnet_ip} mask ${subnet_mask} nomodify nopeer notrap",
      '127.0.0.1',
      '::1'
    ],
    disable_monitor => true
  }
  contain ntp
}
