class video_device::vendor::intel
{
    $pref_free        = 'intel'
    $pref_proprietary = 'intel'

    class intel inherits video_device::vendor_base
    {
        video_device::driver { 'video_device_intel':
            driver      => ['xserver-xorg-video-intel'],
            video_accel => ['i965-va-driver'],
            type        => 'free',
        }
    }
}
