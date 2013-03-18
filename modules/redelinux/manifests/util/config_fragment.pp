define redelinux::util::config_fragment(
    $target   = undef,
    $selector = undef,
    $owner    = undef,
    $group    = undef,
    $mode     = undef,
    $backup   = undef,
    $order    = undef,
) {
    $module_path = get_module_path($module_name)
    $fragment_name = "${target}_${selector}_${name}"
   
    concat::fragment { $fragment_name:
        target  => $target,
        content => inline_template(file("${module_path}/templates/${fragment_name}.erb")),
        owner   => $owner,
        group   => $group,
        mode    => $mode,
        backup  => $backup,
        order   => $order,
    }
}