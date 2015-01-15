class redelinux::packages::programming::editors_and_ides
{   
  Package {
    ensure => installed
  }

  # IDEs
  ## Eclipse
  package { 'eclipse': }
  ## Code::blocks
  package { 'codeblocks': }
  ## Monodevelop
  package { 'monodevelop': }
  ## BlueJ
  package { 'bluej': }
  ## KDevelop
  package { 'kdevelop': }
  ## IntelliJ IDEA
  package { 'intellij-idea-ic': }
  ## Netbeans
  package { 'netbeans': }

  # Editors
  ## vim
  package { ['vim', 'vim-gnome', 'vim-latexsuite', 'vim-puppet', 'vim-rails',
             'vim-scripts', 'vim-syntax-go']: }
  ## the other one
  package { 'emacs': }
  ## nano
  package { 'nano': }
  ## GEdit
  package { ['gedit', 'gedit-plugins', 'gedit-r-plugin', 'gedit-latex-plugin']: }
  ## Geany
  package { 'geany': }
  ## Bluefish
  package { 'bluefish': }
  ## SciTE
  package { 'scite': }
  ## Sublime Text
  apt::key { 'sublime-text':
    key        => 'EEA14886',
    key_server => 'keyserver.ubuntu.com'
  }

  apt::source { 'sublime-text':
    location    => 'http://ppa.launchpad.net/webupd8team/sublime-text-3/ubuntu',
    repos       => 'main',
    require     => Apt::Key['sublime-text'],
    release     => $::operatingsystem ? {
      'Ubuntu' => $::lsbdistcodename,
      'Debian' => $::lsbdistcodename ? {
        'wheezy' => 'precise',
        default  => 'trusty'
      },
      default  => fail("Unsupported OS $::operatingsystem")
    }
  }

  package { 'sublime-text-installer':
    require => Apt::Source['sublime-text']
  }
}

