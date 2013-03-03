class redelinux::apt
{
    include apt

    $debian_mirror = 'http://sft.if.usp.br/debian/'

    apt::source { 'debian':
        location          => $debian_mirror,
        repos             => 'main',
        required_packages => 'debian-keyring debian-archive-keyring',
    }

    if $redelinux::debian_pre_wheezy
    {  
        include apt::backports

        # Add testing repo. Very low priority, so by default nothing will
        # ever be installed from it
        apt::source { 'debian_wheezy': 
            location          => $debian_mirror,
            release           => 'wheezy',
            required_packages => 'debian-keyring debian-archive-keyring',
            pin               => '-10',
        }
    }
}
