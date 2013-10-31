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

define redelinux::util::cfg_file(
    $path          = $title,
    $ensure        = file,
    $content       = '$undef$',
    $source        = undef,
    $source_prefix = undef,
    $replace       = undef,
    $owner         = 'root',
    $group         = 'root',
    $mode          = '0644',
    $recurse       = undef,
    $extra_sources = undef,
    $host_groups   = $redelinux::params::host_groups,
) {
    if $ensure == 'absent' {
        file { $title:
            ensure => absent,
            path   => $path,
        }
    } else {
		File {
		    ensure  => $ensure,
		    owner   => $owner,
		    group   => $group,
		    mode    => $mode,
		    path    => $path,
		    replace => $replace,
		    recurse => $recurse,
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
		} else {
			$selectors = flatten([$::fqdn, $::hostname, sort($host_groups)])
            
			if empty($source) {
				if $source_prefix {
					$source_real = module_file_url($path)
				} else {
					$source_real = module_file_url("${source_prefix}/${path}")
				}
			} else {
				$source_real = $source
			}
		    
		    $sources = any2array($source_real) + any2array($extra_sources)
	        crit("SOURCES ********* $sources")
		    file { $title:
				source => $sources
		    }
		}
    }
}