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

    ::apt::source { "debian-${::lsbdistcodename}":
        location          => $mirror_real,
        repos             => 'main contrib non-free',
        include_src       => true,
        required_packages => 'debian-keyring debian-archive-keyring',
    }

    ::apt::pin { 'pin-stable':
        priority => 500,
        release  => "stable",
        order    => 30,
    }

    ::apt::source { "debian-${::lsbdistcodename}-security":
        location          => 'http://security.debian.org',
        repos             => 'main contrib non-free',
        release           => "${::lsbdistcodename}/updates",
        include_src       => true,
    }

    ::apt::pin { 'pin-security':
        priority => 991,
        label    => "Debian-Security",
        order    => 10,
    }

    ::apt::source { 'redelinux':
        location   => 'http://apt.linux.ime.usp.br',
        repos      => 'main contrib non-free',
        key        => '1F48EB41',
        key_server => 'subkeys.pgp.net',
    }

    ::apt::pin { 'pin-redelinux':
        priority => 990,
        origin   => 'apt.linux.ime.usp.br',
        order    => 20,
    }

    if $redelinux::params::debian_use_backports
    {
        apt::source { 'debian-backports':
            location          => $mirror_real,
            repos             => 'main contrib non-free',
            release           => "${::lsbdistcodename}-backports",
            include_src       => true,
            required_packages => 'debian-keyring debian-archive-keyring',
        }

        ::apt::pin { 'pin-backports':
            priority => 450,
            release  => "${::lsbdistcodename}-backports",
            order    => 40,
        }
    }

    if $redelinux::params::debian_use_testing
    {
        # Add testing repo. Very low priority, so by default nothing will
        # ever be installed from it
        ::apt::source { 'debian-testing': 
            location          => $mirror_real,
            release           => 'testing',
            repos             => 'main contrib non-free',
            include_src       => true,
            required_packages => 'debian-keyring debian-archive-keyring',
        }

        ::apt::pin { 'pin-testing':
            priority => 200,
            release  => 'testing',
            order    => 50,
        }
    }

    Class['::Apt::Update'] -> Package<| |> 

    anchor { 'redelinux::apt::begin': }
    -> Class['::apt']
    -> anchor {'redelinux::apt::end': }

}
