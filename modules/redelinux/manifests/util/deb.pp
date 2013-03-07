define redelinux::util::deb::create_file_dir(
    $path  = $title,
    $owner = undef,
    $group = undef,
    $mode  = undef
)
{
    validate_absolute_path($path)
    
    $path_parent = regsubst($path, '/[^/]*$', '')
    if $path_parent != "" {
        file { $path_parent:
            ensure => directory,
            owner  => $owner,
            group  => $group,
            mode   => $mode,
        }
        
        create_file_dir { $path_parent:
            owner => $owner,
            group => $group,
            mode  => $mode,
        }      
    }  
}

define redelinux::util::deb(
    $source = "puppet:///modules/${module_name}/packages/${name}.deb",
    $path   = undef,
    $ensure = present
) {
    if $path == undef {
        $path_real = "/var/${module_name}-packages/${name}.deb"
    } else {
        $path_real = $path
    }
    
    create_file_dir { $path_real: }

    # The require is probably not needed, but being explicit usually helps
    file { "deb::${title}":
        ensure  => file,
        source  => $source,
        path    => $path_real,
        require => Create_file_dir[$path_real]
    }

    package { $title:
        name     => $name,
        ensure   => $ensure,
        provider => dpkg,
        source   => $path_real,
        require  => File["deb::${title}"],
    }
}

    


