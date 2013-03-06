class video_device::vendor::nvidia
{
    $pref_free        = 'nvidia'
    $pref_proprietary = 'nouveau'

    class nvidia($ensure)
    {
        video_device::driver { 'video_device_nvidia_nvidia':
            driver => $lsbdistid ? {
                Debiana            => ['nvidia-glx'],
                /(?i)Ubuntu|Mint/  => ['nvidia-current']
            },
    		control     => ['nvidia-settings'],
        	video_accel => ['nvidia-vdpau-driver', 'vdpau-va-driver'],
            type        => 'proprietary',
            ensure      => $ensure
        }
    }

    class nouveau($ensure)
    {
        video_device::driver { 'video_device_nvidia_nouveau':
            driver => $lsbdistid ? {
                Debian              => ['xserver-xorg-video-nouveau'],
                /(?i)Ubuntu|Mint/   => ['xserver-xorg-video-nouveau', 'nouveau-firmware']
            },
            type   => 'free',
            ensure => $ensure
        }
    }
}
