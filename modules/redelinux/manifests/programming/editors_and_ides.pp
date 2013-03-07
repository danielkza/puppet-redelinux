class redelinux::programming::editors_and_ides
{   
    include redelinux::apt

    Package {
        ensure => latest,
    }

    # IDEs
    ## Eclipse
    package { 'eclipse': }
    ## Code::blocks
    if $redelinux::debian_pre_wheezy
    {
        apt::force { 'codeblocks': 
            release  => 'wheezy',
            require  => Apt::Source['debian_wheezy'],
            before   => Package['codeblocks'],
        }
    }
    package { 'codeblocks': }
    ## Monodevelop
    package { 'monodevelop': }
    ## BlueJ
    util::deb { 'bluej': 
        ensure => present
    }
    ## KDevelop
    package { 'kdevelop': }
    ## IntelliJ IDEA
    util::deb { 'intellij-idea-ic-12.0.4':
        ensure => present
    }
    ## Netbeans
    package { 'netbeans': }

    # Editors
    ## vim
    package { ['vim', 'vim-gnome', 'vim-latexsuite', 'vim-puppet', 'vim-rails',
               'vim-scripts', 'vim-syntax-go']: }
    ## the other one
    package { ['emacs', 'xemacs21']: }
    ## nano
    package { 'nano': }
    ## Gedit
    package { ['gedit', 'gedit-plugins', 'gedit-r-plugin', 'gedit-latex-plugin']: }
    ## Geany
    package { 'geany': }
    ## Bluefish
    package { 'bluefish': }
    ## SciTE
    package { 'scite': }
    ## Sublime Text
    apt::source { 'sublime-text':
        location    => 'http://ppa.launchpad.net/webupd8team/sublime-text-2/ubuntu',
        repos       => 'main',
        release     => 'precise',
        include_src => true,
        key         => 'EEA14886',
        key_server  => 'keyserver.ubuntu.com',
    }
    package { 'sublime-text':
        require => Apt::Source['sublime-text']
    }
}
