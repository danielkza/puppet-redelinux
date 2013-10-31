class redelinux::nsswitch
{
    util::cfg_file { 'nsswitch.conf':
        path   => '/etc/nsswitch.conf',
    }
}
