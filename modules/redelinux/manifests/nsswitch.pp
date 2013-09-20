class redelinux::nsswitch
{
    util::config_file { 'nsswitch.conf':
        path   => '/etc/nsswitch.conf',
    }
}
