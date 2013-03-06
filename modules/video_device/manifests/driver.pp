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

	# Virtual packages, realized later according to generic driver install
	# options

	if $control != undef and !empty($control) {
		@package { $control:
			ensure => $ensure,
			tag    => 'video_device::driver::control'
		}
	}

	if $video_accel != undef and !empty($video_accel) {
		@package { $video_accel:
			ensure => $ensure,
			tag    => 'video_device::driver::video_accel'
		}
	}

	if $extra != undef and !empty($extra) {
		@package { $extra:
			ensure => $ensure,
			tag    => 'video_device::driver::extra'
		}
	}
}
