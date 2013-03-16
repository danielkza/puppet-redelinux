# This resource manages a file, usually a configuration file, by automatically
# selecting sources according to pre-defined rules:
#
# 1) Sources live on the caller file module's files folder.
# 2) Sources have the form <sources_path>/<file_path>[-selector]
# 3) Selectors, in order of use, from first to last:
#    - $::fqdn
#    - $::hostname
#    - contents of $redelinux::params::host_groups, in alphabetical order.
#    - '' (the preceding dash is ommited)
# 4) If none of the previous sources are available, paths listed in the
#    'extra_sources' param, if any, will be used (in passed order).
#
# All the other parameters are equivalent to their 'file' counterparts,
# but with sane defaults allowing them to be ommited for configuration files.
# The only special case is 'content', which disables the source lookup logic.

define redelinux::util::config_file(
    $path               = $title,
    $content            = '$undef$',
    $source             = undef,
    $replace            = undef,
    $mode               = undef,
    $extra_sources      = '$undef$',
)
{
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
    # For some stupid reason, undef == '', work around it as well.

    if $content != '$undef$' {
        if $source != undef {
            fail("You must specify one of: content, source")
        }

        file { $title: 
            content => $content,
        }
    } elsif $source == undef {
        fail("You must specify one of: content, source")
    } else {
        $sources = concat([$::fqdn, $::hostname], $redelinux::params::host_groups)
        $sources = prefix("puppet:///modules/${caller_module_name}/${path}-", $sources)
        $sources = concat($sources, ["puppet:///modules/${caller_module_name}/${path}"])

        if $extra_sources != '$undef$' {
            if !is_array($extra_sources) {
                $extra_sources = [$extra_sources]
            }

            $sources = concat($sources, $extra_sources)
        }

        warn("file ${path} sources ${sources}")

        file { $title:
            source  => $sources
        }
    }
}
