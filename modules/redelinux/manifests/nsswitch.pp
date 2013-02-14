class redelinux::nsswitch
{
    file { 'nsswitch.conf':
        ensure => file,
        path   => '/etc/nsswitch.conf',
        source => 'puppet:///modules/redelinux/etc/nsswitch.conf',
    }    
}
