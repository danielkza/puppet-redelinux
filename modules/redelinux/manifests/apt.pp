class redelinux::apt(
    $mirror = undef
) {
    include redelinux::params

    $mirror_real = $mirror ? {
        undef   => $redelinux::params::debian_mirror,
        default => $mirror
    }

    class { '::apt': 
        purge_sources_list   => true,
        purge_sources_list_d => true,
        purge_preferences_d  => true,
    }

    if $redelinux::params::debian_pre_wheezy
    {
        # Add backports repo
        class { '::apt::backports': }

        # Add testing repo. Very low priority, so by default nothing will
        # ever be installed from it
        ::apt::source { 'debian_wheezy': 
            location          => $mirror_real,
            release           => 'wheezy',
            repos             => 'main contrib non-free',
            include_src       => true,
            required_packages => 'debian-keyring debian-archive-keyring',
        }

        ::apt::pin { 'wheezy':
            priority => -10
        }

        # Stupid anchor
        Anchor['redelinux::apt::begin']
        -> Class['::apt::backports']
        -> Anchor['redelinux::apt::end']
    }

    ::apt::source { "debian_${::lsbdistcodename}":
        location          => $mirror_real,
        repos             => 'main contrib non-free',
        include_src       => true,
        required_packages => 'debian-keyring debian-archive-keyring',
    }

    ::apt::source { "debian_${::lsbdistcodename}_security":
        location          => 'http://security.debian.org',
        repos             => 'main contrib non-free',
        release           => "${::lsbdistcodename}/updates",
        include_src       => true,
    }

    ::apt::source { 'puppetlabs':
        location          => 'http://apt.puppetlabs.com',
        repos             => 'main',
        include_src       => true,
        key               => '4BD6EC30',
        key_server        => 'subkeys.pgp.net'
    }
    
    Class['::apt::Update'] -> Package<| |> 

    anchor { 'redelinux::apt::begin': }
    -> Class['::apt']
    -> anchor {'redelinux::apt::end': }

}
