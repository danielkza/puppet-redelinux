class redelinux::desktop::xfce
{
  Package {
    ensure => installed,
  }

  package { ['xfce4', 'xfce4-goodies ']: }
}
