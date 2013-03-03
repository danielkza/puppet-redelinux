class redelinux::programming::ides
{   
    include redelinux::apt

    Package {
        ensure => latest,
    }

    # Eclipse
    package { 'eclipse': }
    # Code-blocks
    if $redelinux::debian_pre_wheezy
    {
        apt::force { 'codeblocks': 
            release  => 'wheezy',
            require  => Apt::Source['debian_wheezy'],
            before   => Package['codeblocks'],
        }
    }
    package { 'codeblocks': }
    # Monodevelop
    package { 'monodevelop': }
    # BlueJ
    package { 'bluej':
        source => 'http://www.bluej.org/download/files/bluej-309.deb',
    }

    # Not IDEs, but as good as


}
