define redelinux::nagios::host_entry(
    $host_name    = $title,
    $ensure       = present,
    $host_alias   = $title,
    $address      = $host_name,
    $parents      = undef,
    $hostgroups   = undef,
    $use          = undef,
    $check_period = undef,
) {
    include redelinux::nagios::params

    $resource_name = "nagios_host_${host_name}"
    if !defined(Util::Config_file[$resource_name]) {
        $address_real = $address ? {
            undef   => $host_name,
            default => $address,
        }

        util::config_file { $resource_name:
            ensure  => $ensure,
            path    => "${redelinux::nagios::params::object_dir}/host-${host_name}.cfg",
            content => template("redelinux/nagios_host.erb"),
        }
    }
}
