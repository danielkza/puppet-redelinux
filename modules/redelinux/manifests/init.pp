class redelinux
{
    $debian_pre_wheezy = ($::lsbdistid == 'Debian'
                          and versioncmp($::lsbmajdistrelease, '7') < 0)
}
