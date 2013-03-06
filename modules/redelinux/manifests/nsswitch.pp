class redelinux::nsswitch
{
    include redelinux::util

    config_file { 'nsswitch.conf':
        path   => '/etc/nsswitch.conf',
    }
}
