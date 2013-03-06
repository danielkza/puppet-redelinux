define video_device::driver(
	$driver,
	$control     = undef,
	$video_accel = undef,
	$extra       = undef,
	$type        = 'unknown',
	$ensure      = latest
) {
	package { $driver:
		ensure => $ensure
	}

	if $control != undef and !empty($control) {
		@package { $control:
			ensure => $ensure,
			tag    => 'video_device::vendor::control'
		}
	}

	if $video_accel != undef and !empty($video_accel) {
		@package { $video_accel:
			ensure => $ensure,
			tag    => 'video_device::vendor::video_accel'
		}
	}

	if $extra != undef and !empty($extra) {
		@package { $extra:
			ensure => $ensure,
			tag    => 'video_device::vendor::extra'
		}
	}
}
