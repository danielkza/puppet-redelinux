define video_device::apply_vendor(
    $allow_proprietary = true,
    $ensure            = latest
) {
    # Load the vendor class, found out what is the preferred driver to be
    # installed depending on whether proprietary drivers should be accepted,
    # then instantiate the right class, forwaring the ensure parameter.

    $vendor = $title

    if $allow_proprietary {
        $pref_var = 'pref_proprietary'
    } else {
        $pref_var = 'pref_free'
    }

    include "video_device::vendor::${title}"

    $driver = getvar("video_device::vendor::${vendor}::${pref_var}")
    if $driver != undef {
        class { "video_device::vendor::${title}::${driver}":
            ensure => $ensure
        }
    } else {
        fail("Failed to retrieve preferred driver for vendor ${vendor}. Certify " \
             "that both pref_proprietary and pref_free are properly set.")
    }
}
