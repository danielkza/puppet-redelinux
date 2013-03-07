define redelinux::util::deb(
    $source = "puppet:///modules/${module_name}/packages/${name}.deb",
    $path   = undef,
    $ensure = present
) {
    @file { "deb::default_install_path":
        ensure => directory,
        path   => "/var/${module_name}-packages/",
        before => "deb::${name}",
    }
    
    if $path == undef {
        File<| title == "deb::default_install_path" |>
        $path_real = "/var/${module_name}-packages/${name}.deb"
    } else {
        $path_real = $path
    }

    file { "deb::${name}":
        ensure => file,
        source => $source,
        path   => $path_real,
    }

    package { $name:
        ensure   => $ensure,
        provider => dpkg,
        source   => $path_real,
        require  => File["deb::${name}"],
    }
}

    


