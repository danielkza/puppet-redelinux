class redelinux::programming::ides
{   
#    include deb
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
    deb::deb { 'bluej':
	source => 'puppet:///modules/redelinux/packages/bluej.deb',
    }

    # Not IDEs, but as good as
}
