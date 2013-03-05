class video_device::vendor::intel
{
	video_device::vendor { 'video_device_intel':
		driver      => ['xserver-xorg-video-intel'],
		video_accel => ['i965-va-driver']
	}
}