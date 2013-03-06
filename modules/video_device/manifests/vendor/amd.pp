class video_device::vendor::amd
{
    $pref_free        = 'xf86_video_ati'
    $pref_proprietary = 'catalyst'

    Exec {
        path => ['/bin/', '/sbin/',
                 '/usr/bin/', '/usr/sbin/',
                 '/usr/local/bin/', '/usr/local/sbin/'
        ]
    }

    class catalyst($ensure)
    {
    	video_device::driver { 'video_device_amd_catalyst':
    		driver => $lsbdistid ? {
    			Debian        => ['fglrx-driver', 'fglrx-modules-dkms'],
    			/Ubuntu|Mint/ => ['fglrx'],
    		},
    		control     => ['fglrx-control'],
    		video_accel => ['xvba-va-driver'],
            type        => 'proprietary',
            ensure      => $ensure,
            notify      => Exec["aticonfig"]
    	}

        exec { "aticonfig":
            command     => "aticonfig --initial",
            unless      => "aticonfig --initial=check",
            refreshonly => true
        }
    }

    class xf86_video_ati($ensure)
    {
        video_device::driver { 'video_device_amd_xf86_video_ati':
            driver      => 'xserver-xorg-video-ati',
            type        => 'free',
            ensure      => $ensure,
        }
    }
}
