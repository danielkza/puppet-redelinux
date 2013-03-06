define video_device::apply_vendor(
    $allow_proprietary = true,
    $ensure            = latest
) {
    if $allow_proprietary {
        $pref_var = 'pref_proprietary'
    } else {
        $pref_var = 'pref_free'
    }

    include "video_device::vendor::${title}"

    $driver = getvar("video_device::vendor::${title}::${pref_var}")
    if $driver != undef {
        class { "video_device::vendor::${title}::${driver}":
            ensure => $ensure
        }
    }
}
