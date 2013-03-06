class video_device::device(
    $vendor              = undef,
    $driver              = undef,
    $allow_proprietary   = true,
    $install_control     = true,
    $install_video_accel = true,
    $install_extra       = true,
    $ensure              = installed
) {
    # Manual driver was selected, don't do any automatic selection logic
    if $driver != undef {
        if $vendor == undef or not is_string($vendor) {
            fail("Manual driver selection requires manual selection of a single vendor")
        } else {
            class { "video_device::vendor::${vendor}::${driver}":
                ensure => $ensure
            }
        }
    } else {
        if $vendor == undef {
            $vendor_real = split($video_device_vendors, ' ')
        } else {
            $vendor_real = $vendor
        }
        
        video_device::apply_vendor { $vendor_real:
            allow_proprietary => $allow_proprietary,
            ensure            => $ensure
        }
    }

    if $install_control {
        Package <| tag == 'video_device::vendor::control' |>
    }
    if $install_video_accel {
        Package <| tag == 'video_device::vendor::video_accel' |>
    }
    if $install_extra {
        Package <| tag == 'video_device::vendor::extra' |>
    }
}
