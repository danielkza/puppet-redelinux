define deb::deb(
  $source,
  $path = ''
) {
    $deb_name = "${name}.deb"

    if $path == '' {
	$real_path = "/tmp/${deb_name}"
    } else {
        $real_path = $path
    }

    if $source == '' {
        fail("You must specify a source")
    }

    file { $deb_name:
        ensure => file,
        source => $source,
        path   => $real_path,
    }

    package { $name:
        provider => dpkg,
        source   => $real_path,
        require  => File[$deb_name],
    }
}         

	


