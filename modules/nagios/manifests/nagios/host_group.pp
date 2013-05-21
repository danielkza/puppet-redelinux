define nagios::host_group(
    $hostgroup_name  = $title,
    $ensure          = present,
    $hostgroup_alias = $hostgroup_name,
    $members         = undef,
) {
    include nagios::params

    $resource_name = "nagios_group_${hostgroup_name}"
    if !defined(Cfgutil::Config_file[$resource_name]) {
        cfgutil::config_file { $resource_name: 
            ensure  => $ensure,
            path    => "${nagios::params::object_dir}/group-${hostgroup_name}.cfg",
            content => template("nagios/nagios_hostgroup.erb"),
        }
    }
}
