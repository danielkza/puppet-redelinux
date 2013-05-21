class nagios::provider::nagios
{
    $package            = 'nagios3'
    $service            = 'nagios3'
    $conf_dir           = '/etc/nagios3'
    $object_subdir      = 'conf.d'
    $plugins            = ['nagios-plugins',
                           'nagios-snmp-plugins',
                           'nagios-nrpe-plugin']
    $default_cfg_suffix = 'nagios2'
}
