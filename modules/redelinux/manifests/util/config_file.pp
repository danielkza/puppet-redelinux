define redelinux::util::config_file(
    $path       = $title,
    $content    = undef,
    $source     = undef,
    $replace    = undef,
    $mode       = undef,
)
{
    if $content == undef {

    } els
    } else {
        $source_real = undef
    }


    File {
        ensure  => file,
        owner   => 'root',
        group   => 'root',
        mode    => $mode ? {
            undef   => 'a=r,u+w',
            default => $mode,
        },
        path    => $path,
        replace => $replace,
    }

    # Work around the fact that even passing content as undef sometimes
    # causes the 'You cannot specify more than one of content, source, target'
    # error.

    if $content != undef {
        if $source != undef {
            fail("You must specify either content OR source")
        }

        file { $title: 
            content => $content,
        }
    } else {
        file { $title: 
            source  => $source ? {
                undef   => "puppet:///modules/${caller_module_name}/${path}",
                default => $source,
            },
        }
    }
}
