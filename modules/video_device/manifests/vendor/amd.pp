class video_device::vendor::amd
{
	video_device::vendor { 'video_device_amd':
		driver => $operatingsystem ? {
			'Debian' => ['fglrx-driver', 'fglrx-modules-dkms'],
			'Ubuntu' => ['fglrx'],
		},
		control     => ['fglrx-control'],
		video_accel => ['xvba-va-driver']
	}
}