define video_device::vendor(
	$driver,
	$control    = undef,
	$video_accel= undef,
	$extra      = undef,
	$ensure     = latest)
{
	package { $driver:
		ensure => latest
	}

	if $control != undef {
		@package { $control:
			ensure => $ensure,
			tag    => 'video_device::vendor::control'
		}
	}

	if $video_accel != undef {
		@package { $video_accel:
			ensure => $ensure,
			tag    => 'video_device::vendor::video_accel'
		}
	}

	if $extra != undef {
		@package { $extra:
			ensure => $ensure,
			tag    => 'video_device::vendor::extra'
		}
	}
}