class redelinux::apt(
    $mirror = undef
) {
    include redelinux::params

    $mirror_real = $mirror ? {
        undef   => $redelinux::params::debian_mirror,
        default => $mirror,
    }

    class { '::apt':
        purge_sources_list   => true,
        purge_sources_list_d => true,
        purge_preferences_d  => true,
    }

    ::apt::pin { 'pin_stable':
        priority => 700,
        release  => "stable",
        order    => 10,
    }

    if $redelinux::params::debian_use_backports
    {
        # Add backports repo
        class { '::apt::backports': }

        ::apt::pin { 'pin_backports':
            priority => 650,
            release  => "${::lsbdistcodename}-backports",
            order    => 20,
        }

        # Stupid anchor
        Anchor['redelinux::apt::begin']
        -> Class['::apt::backports']
        -> Anchor['redelinux::apt::end']
    }

    if $redelinux::params::debian_use_testing
    {
        # Add testing repo. Very low priority, so by default nothing will
        # ever be installed from it
        ::apt::source { 'debian_testing': 
            location          => $mirror_real,
            release           => 'testing',
            repos             => 'main contrib non-free',
            include_src       => true,
            required_packages => 'debian-keyring debian-archive-keyring',
        }

        ::apt::pin { 'pin_testing':
            priority => 500,
            release  => 'testing',
            order    => 30,
        }
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

    ::apt::source { 'redelinux':
        location   => 'http://apt.linux.ime.usp.br',
        repos      => 'main contrib non-free',
        key        => '1F48EB41',
        key_server => 'subkeys.pgp.net',
    }

    ::apt::pin { 'pin_redelinux':
        priority => 990,
        origin   => 'apt.linux.ime.usp.br',
        order    => 9,
    }

    Class['::Apt::Update'] -> Package<| |> 

    anchor { 'redelinux::apt::begin': }
    -> Class['::apt']
    -> anchor {'redelinux::apt::end': }

}
