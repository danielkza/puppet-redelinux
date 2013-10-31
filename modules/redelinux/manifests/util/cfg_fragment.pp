define redelinux::util::cfg_fragment(
    $target,
    $source,
    $identifier   = undef,
    $selector     = undef,
    $owner        = undef,
    $group        = undef,
    $mode         = undef,
    $backup       = undef,
    $order        = undef,
    $use_template = false,
    $separator    = '$'
) {
    $module_path = get_module_path($caller_module_name)
    $source_is_folder = ($source =~ /\/$/)

    if !$source_is_folder and !$identifier {
        $fragment_file = "${source}"
    } else {
        $fragment_name = $selector ? {
            undef   => "${identifier}",
            default => "${selector}${separator}${identifier}",
        }

        if $source_is_folder {
            $fragment_file = "${source}/${fragment_name}"
        } else {
            $fragment_file = regsubst($source, '^(.+)([.].+$)|$',
                                      "\\1${separator}${fragment_name}\\2") 
        }
    }

    if $use_template {
        $fragment_path = "${fragment_file}.erb"
        
        if file_exists($fragment_path) {
            $content = template($fragment_path)
            $source  = undef
        }
    } else {
        $fragment_path = "${fragment_file}"

        if file_exists($fragment_path) {
            $content = undef
            $source  = $fragment_path
        }
    }


    if $content != undef or $source != undef {
        info("fragment exists - `$fragment_path`")

        concat::fragment { $title:
            target  => $target,
            content => $content,
            source  => $source,
            owner   => $owner,
            group   => $group,
            mode    => $mode,
            backup  => $backup,
            order   => $order,
        }
    } else {
        info("fragment missing - `$fragment_path`")
    }
}