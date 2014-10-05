class redelinux::repos::ubuntu(
  $mirror        = 'http://ubuntu.c3sl.ufpr.br/ubuntu',
  $repos         = 'main restricted universe multiverse',
  $use_backports = true
) {
  apt::source { "ubuntu-${::lsbdistcodename}":
    location          => $mirror,
    release           => $::lsbdistcodename,
    repos             => $repos,
    include_src       => true,
    required_packages => 'ubuntu-keyring ubuntu-archive-keyring',
  }

  apt::pin { 'pin-release':
    priority => 500,
    release  => $::lsbdistcodename,
    order    => 30,
  }

  apt::source { "ubuntu-${::lsbdistcodename}-security":
    location    => $mirror,
    repos       => $repos,
    release     => "${::lsbdistcodename}/updates",
    include_src => true,
  }

  apt::pin { 'pin-security':
    priority => 991,
    label    => "Debian-Security",
    order    => 10,
  }

  if $use_backports {
    apt::source { 'ubuntu-${::lsbdistcodename}-backports':
      location          => $mirror,
      repos             => $repos,
      release           => "${::lsbdistcodename}-backports",
      include_src       => true,
      required_packages => 'ubuntu-keyring ubuntu-archive-keyring',
    }

    apt::pin { 'pin-backports':
      priority => 450,
      release  => "${::lsbdistcodename}-backports",
      order    => 40,
    }
  }
}
