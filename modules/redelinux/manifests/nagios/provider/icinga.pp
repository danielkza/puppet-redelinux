class redelinux::nagios::provider::icinga
{
    $package            = 'icinga'
    $service            = 'icinga'
    $conf_dir           = '/etc/icinga'
    $object_subdir      = 'objects'
    $plugins            = ['nagios-plugins',
                           'nagios-snmp-plugins',
                           'nagios-nrpe-plugin']
    $default_cfg_suffix = 'icinga'
} 
