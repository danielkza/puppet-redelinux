define redelinux::util::config_fragment(
    $target,
    $selector = undef,
    $owner    = undef,
    $group    = undef,
    $mode     = undef,
    $backup   = undef,
    $order    = undef,
) {
    $module_path = get_module_path($caller_module_name)

    $fragment_name = $selector ? {
        undef   => "${target}_${name}",
        default => "${target}_${selector}_${name}",
    }
   
    $content = inline_template(file("${module_path}/templates/${fragment_name}.erb"))
    if $content != '' {
        concat::fragment { $fragment_name:
            target  => $target,
            content => $content,
            owner   => $owner,
            group   => $group,
            mode    => $mode,
            backup  => $backup,
            order   => $order,
        }
    }
}