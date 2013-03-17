define redelinux::nagios::host_group(
    $hostgroup_name  = $title,
    $ensure          = present,
    $hostgroup_alias = $hostgroup_name,
    $members         = undef,
) {
    include redelinux::nagios::params

    $resource_name = "nagios_group_${hostgroup_name}"
    if !defined(Util::Config_file[$resource_name]) {
        util::config_file { $resource_name: 
            ensure  => $ensure,
            path    => "${redelinux::nagios::params::object_dir}/group-${hostgroup_name}.cfg",
            content => template("redelinux/nagios_hostgroup.erb"),
        }
    }
}
