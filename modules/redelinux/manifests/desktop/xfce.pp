class redelinux::desktop::xfce
{
    Package {
        ensure => latest,
    }

    package { ['xfce4', 'xfce4-goodies ']: }
}
