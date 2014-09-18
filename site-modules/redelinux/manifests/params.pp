class redelinux::params(
    $host_groups = [],
    
    $debian_pre_wheezy = ($::lsbdistid == 'Debian'
                          and versioncmp($::lsbmajdistrelease, '7') < 0),
    
    $debian_mirror        = 'http://sft.if.usp.br/debian/',
    $debian_use_backports = true,
    $debian_use_testing   = false,

    $kerberos_admin_group = 'olimpo',
    $kerberos_realm       = 'LINUX.IME.USP.BR',

    $puppet_client_command     = '/usr/bin/puppet agent --onetime --no-daemonize',
    $puppet_client_hourly_runs = 2,
)
{
}
