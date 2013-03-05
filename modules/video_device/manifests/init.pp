class video_device
{
}

define video_device::device(
	$vendor              = undef,
	$install_control     = true,
	$install_video_accel = true,
	$install_extra       = true
) {
	notice("Vendor: ${video_device_vendors}")
	$vendor_real = $video_device_vendors ? {
		/(?i)amd/      => 'amd',
		/(?i)intel/    => 'intel',
		/(?i)nvidia/   => 'nvidia',
		default     => undef
	}

	if $vendor_real != undef {
		include "video_device::vendor::${vendor_real}"

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
}

