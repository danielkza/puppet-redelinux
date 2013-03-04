class redelinux::apt
{
    class { '::apt': }

    $debian_mirror = 'http://sft.if.usp.br/debian/'

    if $redelinux::debian_pre_wheezy
    {  
        # Add backports repo
        class { '::apt::backports': }

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
