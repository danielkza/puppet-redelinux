class redelinux::apt
{
    class { '::apt': 
        purge_sources_list   => true,
        purge_sources_list_d => true
    }

    $debian_mirror = 'http://sft.if.usp.br/debian/'

    if $redelinux::debian_pre_wheezy
    {
        # Add backports repo
        class { '::apt::backports': }

        # Add testing repo. Very low priority, so by default nothing will
        # ever be installed from it
        ::apt::source { 'debian_wheezy': 
            location          => $debian_mirror,
            release           => 'wheezy',
            repos             => 'main contrib non-free'
            include_src       => true,
            required_packages => 'debian-keyring debian-archive-keyring',
            pin               => '-10',
        }
    }

    ::apt::source { 'debian_${lsbdistcodename}':
        location          => $debian_mirror,
        repos             => 'main contrib non-free',
        include_src       => true,
        required_packages => 'debian-keyring debian-archive-keyring',
    }

    ::apt::source { 'puppetlabs':
        location          => 'http://apt.puppetlabs.com',
        repos             => 'main',
        required_packages => 'debian-keyring debian-archive-keyring',
    }
}
