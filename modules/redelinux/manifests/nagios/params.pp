class redelinux::nagios::params
inherits "redelinux::nagios::provider::${redelinux::nagios::use_provider}"
{
    $object_dir = "${conf_dir}/${object_subdir}"
}
