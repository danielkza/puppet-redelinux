class redelinux::programming::languages
{
    include redelinux::apt

    Package {
        ensure => latest,
    }

    # Python
    package { ['python', 'python3']: }
    # Ruby
    package { 'ruby': }
    # Lua
    package { ['lua50', 'lua5.1', 'lua5.2']: }
    # Fortran
    package { 'gfortran': }
    # C, C++
    package { 'build-essential': }
    package { ['gcc', 'g++', 'libc-dev']: }
    package { 'clang': }
    package { ['make', 'automake', 'autoconf']: }
    package { ['cmake', 'cmake-curses-gui', 'cmake-qt-gui']: }
    # Haskell
    package { 'haskell-platform': }
    # Erlang
    package { 'erlang': }
    # Java
    if $redelinux::debian_pre_wheezy
    {
        package { 'openjdk-6-jdk': }
    } else {
        package { 'openjdk-7-jdk': }
    }
    package { 'ant': }
    package { 'maven2': }
    # Scala
    package { 'scala': }
    # PHP
    package { 'php-cli': }
    # R
    package { 'r-recommended': }
    # Octave
    package { 'octave': }
    # Smalltalk
    package { 'squeak-vm': }
    file { 'squeak-image':
        ensure  => directory,
        path    => '/usr/share/squeak/',
        source  => 'puppet:///modules/redelinux/usr/share/squeak/',
        recurse => remote,
        links   => manage,
    }
    # Mono
    package { 'mono-complete': }
    # Assembly
    package { ['nasm', 'yasm']: }
    # Lisp
    package { 'clisp': }
    # Scheme
    package { 'racket': }
    if $redelinux::debian_pre_wheezy
    {
        Package['racket'] {
            require => Apt::Backports
        }
    }
}
