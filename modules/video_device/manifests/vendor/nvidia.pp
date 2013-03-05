class video_device::vendor::nvidia
{
	video_device::vendor { 'video_device_nvidia':
		driver => $operatingsystem ? {
			'Debian' => ['nvidia-glx'],
			'Ubuntu' => ['nvidia-current'],
		},
		control     => ['nvidia-settings'],
		video_accel => ['vdpau-va-driver']
	}
}
