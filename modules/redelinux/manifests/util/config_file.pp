define redelinux::util::config_file(
    $path       = $title,
    $content    = undef,
    $source     = undef,
    $replace    = undef,
    $mode       = undef,
)
{
    if $content == undef {
        if $source == undef {
            $source_real = "puppet:///modules/${caller_module_name}/${path}"
        } else {
            $source_real = $source
        }
    } elsif $source != undef {
        fail("You must specify either content OR source")
    } else {
        $source_real = undef
    }

    file { $title:
        ensure  => file,
        owner   => 'root',
        group   => 'root',
        mode    => $mode ? {
            undef   => 'a=r,u+w',
            default => $mode,
        },
        path    => $path,
        content => $content,
        source  => $source_real,
        replace => $replace,
    }
}
