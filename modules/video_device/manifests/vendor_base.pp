class video_device::vendor_base(
    $ensure = latest
) {
    Video_device::Driver {
        ensure => $ensure
    }
}
