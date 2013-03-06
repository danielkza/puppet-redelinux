class video_device::device(
    $vendor              = undef,
    $allow_proprietary   = true,
    $install_control     = true,
    $install_video_accel = true,
    $install_extra       = true
) {
    if $vendor == undef {
        $vendor_real = split($video_device_vendors, ' ')
    } else {
        $vendor_real = $vendor
    }

    video_device::apply_vendor { $vendor_real:
        allow_proprietary => $allow_proprietary,
        ensure => $ensure
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
