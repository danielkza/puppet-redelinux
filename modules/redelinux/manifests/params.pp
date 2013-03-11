class redelinux::params
{
    $debian_pre_wheezy = ($::lsbdistid == 'Debian'
                          and versioncmp($::lsbmajdistrelease, '7') < 0)
    $debian_mirror = 'http://sft.if.usp.br/debian/'

    $puppet_client_command = '/usr/bin/puppet agent --onetime --no-daemonize'
    $puppet_client_run_interval = 30
}
