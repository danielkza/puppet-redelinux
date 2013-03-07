define redelinux::util::deb(
    $source = 'puppet:///modules/${::module_name}/packages/${name}.deb',
    $path   = undef,
    $ensure = present
) {
    if $path == undef {
        $path_real = "/var/${::module_name}-packages/${name}.deb"
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

    


