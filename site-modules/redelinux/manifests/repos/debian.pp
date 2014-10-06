class redelinux::repos::debian(
  $mirror        = 'http://debian.c3sl.ufpr.br/debian',
  $repos         = 'main contrib non-free',
  $use_backports = true
) {
  apt::source { "debian-${::lsbdistcodename}":
    location          => $mirror,
    release           => $::lsbdistcodename,
    repos             => $repos,
    include_src       => true,
    required_packages => 'debian-keyring debian-archive-keyring',
  }

  apt::pin { 'default-release':
    priority => 500,
    release  => $::lsbdistcodename,
    order    => 30,
  }

  # Debian does not do security updates for non-stable releases
  $do_security = $::lsbdistrelease ? {
    /^((old)?stable|(\d+[.]?)+))$/ => true,
    default                        => false
  }

  if $do_security {
    apt::source { "debian-${::lsbdistcodename}-security":
      location    => $mirror,
      repos       => $repos,
      release     => "${::lsbdistcodename}/updates",
      include_src => true,
    }

    apt::pin { 'security':
      priority => 510,
      label    => "Debian-Security",
      order    => 20
    }
  }

  if $use_backports {
    apt::source { 'debian-${::lsbdistcodename}-backports':
      location          => $mirror,
      repos             => $repos,
      release           => "${::lsbdistcodename}-backports",
      include_src       => true,
      required_packages => 'debian-keyring debian-archive-keyring',
    }

    apt::pin { 'backports':
      priority => 450,
      release  => "${::lsbdistcodename}-backports",
      order    => 40,
    }
  }
}
