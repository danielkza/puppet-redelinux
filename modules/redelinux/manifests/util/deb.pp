define redelinux::util::deb(
    $name   = $title,
    $source = 'puppet:///modules/${::module_name}/packages/${name}.deb',
    $path   = undef,
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
        provider => dpkg,
        source   => $path_real,
        require  => File["deb::${name}"],
    }
}

    


