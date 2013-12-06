define nagios::host_entry(
    $host_name    = $title,
    $ensure       = present,
    $host_alias   = $title,
    $address      = $host_name,
    $parents      = undef,
    $hostgroups   = undef,
    $use          = undef,
    $check_period = undef,
) {
    include nagios::params

    $resource_name = "nagios_host_${host_name}"
    if !defined(Cfgutil::Config_file[$resource_name]) {
        $address_real = $address ? {
            undef   => $host_name,
            default => $address,
        }

        cfgutil::cfg::file { $resource_name:
            ensure  => $ensure,
            path    => "${nagios::params::object_dir}/host-${host_name}.cfg",
            content => template("nagios/nagios_host.erb"),
        }
    }
}
