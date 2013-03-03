class redelinux
{
    $debian_pre_wheezy = ($operatingsystem == 'Debian'
                          and versioncmp($operatingsystemrelease, '7.0') < 0)
}
