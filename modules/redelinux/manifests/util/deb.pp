
define redelinux::util::deb(
    $source = "puppet:///modules/${module_name}/packages/${name}.deb",
    $path   = undef,
    $ensure = present
) {
    include redelinux::params
    include redelinux::util::mkdir

    if $path == undef {
        $path_real = "/var/${module_name}-packages/${name}.deb"
    } else {
        $path_real = $path
    }
    
    ensure_resource('redelinux::util::mkdir', $path_real)

    file { "deb::${title}":
        ensure  => file,
        source  => $source,
        path    => $path_real,
    }

    package { $title:
        name     => $name,
        ensure   => $ensure,
        provider => dpkg,
        source   => $path_real,
        require  => File["deb::${title}"],
    }
}

    


