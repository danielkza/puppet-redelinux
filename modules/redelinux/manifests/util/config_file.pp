define redelinux::util::config_file(
    $path       = $title,
    $content    = undef,
    $source     = undef,
    $replace    = undef,
    $mode       = undef,
)
{
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
        source  => $content ? {
            undef   => "puppet:///modules/${module_name}/${path}",
            default => undef,
        },
        replace => $replace,
    }
}
