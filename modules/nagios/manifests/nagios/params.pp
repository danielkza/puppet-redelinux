class nagios::params
{
    include nagios

    $provider      = $nagios::use_provider
    $provider_full = "nagios::provider::${provider}"
    include "${provider_full}"

    $package            = getvar("${provider_full}::package")
    $service            = getvar("${provider_full}::service")
    $conf_dir           = getvar("${provider_full}::conf_dir")
    $object_subdir      = getvar("${provider_full}::object_subdir")
    $plugins            = getvar("${provider_full}::plugins")
    $default_cfg_suffix = getvar("${provider_full}::default_cfg_suffix")
    $object_dir         = "${conf_dir}/${object_subdir}"
}

