class redelinux::ntp
{
    require redelinux::apt

    # NTP
    package { 'ntp':
        ensure => present,
    }
    
    service { 'ntp':
        ensure  => running,
        enable  => true,
        require => Package['ntp'],
    }
}
