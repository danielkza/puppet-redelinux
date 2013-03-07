class redelinux::params
{
    $debian_pre_wheezy = ($::lsbdistid == 'Debian'
                          and versioncmp($::lsbmajdistrelease, '7') < 0)
    $debian_mirror = 'http://sft.if.usp.br/debian/'
}
