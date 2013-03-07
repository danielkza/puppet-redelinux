class video_device::vendor::nvidia
{
    $pref_free        = 'nouveau'
    $pref_proprietary = 'nvidia'

    Exec {
        path => ['/bin/', '/sbin/',
                 '/usr/bin/', '/usr/sbin/',
                 '/usr/local/bin/', '/usr/local/sbin'
        ]
    }

    class nvidia($ensure)
    {
        video_device::driver { 'video_device_nvidia_nvidia':
            driver => $lsbdistid ? {
                Debian         => ['nvidia-glx', 'nvidia-xconfig'],
                /Ubuntu|Mint/  => ['nvidia-current', 'nvidia-xconfig']
            },
    		control     => ['nvidia-settings'],
        	video_accel => ['nvidia-vdpau-driver', 'vdpau-va-driver'],
            type        => 'proprietary',
            ensure      => $ensure,
            notify      => Exec['nvidia-xconfig']
        }

        exec { 'nvidia-xconfig':
            command     => 'nvidia-xconfig',
            onlyif      => 'which nvidia-xconfig',
            unless      => shellquote('grep', '-Ei', 'Driver[[:blank:]]+"nvidia"', '/etc/X11/xorg.conf'),
            refreshonly => true
        }
    }

    class nouveau($ensure)
    {
        video_device::driver { 'video_device_nvidia_nouveau':
            driver => $lsbdistid ? {
                Debian          => ['xserver-xorg-video-nouveau'],
                /Ubuntu|Mint/   => ['xserver-xorg-video-nouveau', 'nouveau-firmware']
            },
            type   => 'free',
            ensure => $ensure
        }
    }
}
