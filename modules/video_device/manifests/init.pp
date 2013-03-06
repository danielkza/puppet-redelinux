import stdlib

class video_device
{
}

define video_device::device(
	$vendor              = undef,
	$allow_proprietary   = false,
	$install_control     = true,
	$install_video_accel = true,
	$install_extra       = true
) {
	if $vendor == undef {
		$vendor_real = split($video_device_vendors, ' ')
	} else {
		$vendor_real = $vendor
	}

	define install_driver_for_vendor($allow_proprietary, $ensure)
	{
		if $allow_proprietary {
			$pref_var = 'pref_proprietary'
		} else {
			$pref_var = 'pref_free'
		}

		$driver = getvar("video_device::vendor::${title}::${pref_var}")
		if $driver != undef:
			class { "video_device::vendor::${title}::${driver}":
				ensure => $ensure
			}
		}
	}

	install_driver_for_vendor { $vendor_real:
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



