class redelinux::packages::programming::languages
{
  Package {
    ensure => installed
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
  package { ['make', 'automake', 'autoconf', 'autoheader']: }
  package { ['cmake', 'cmake-curses-gui', 'cmake-qt-gui']: }
  # Haskell
  package { 'haskell-platform': }
  # Erlang
  package { 'erlang': }
  # Java
  if $redelinux::params::debian_pre_wheezy
  {
    package { 'openjdk-6-jdk': }
  } else {
    package { 'openjdk-7-jdk': }
  }
  package { 'ant': }
  package { 'maven2': }
  # Scala
  package { 'scala': }
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
  # Puredata
  apt::key {
    'puredata1':
      key        => '9F0FE587374BBE81',
      key_server => 'keyserver.ubuntu.com'
    'puredata2':
      key        => 'D63D3D09C39F5EEB'
      key_server => 'keyserver.ubuntu.com'
  }

  apt::source { 'puredata-extended':
    location => 'http://apt.puredata.info/releases',
    repos    => 'main',
    release  => $::lsbdistcodename
    require  => Apt::Key['puredata1', 'puredata2']
  }

  package { 'pd-extended':
    require => Apt::Source['puredata-extended']
  }

  package { ['puredata', 'puredata-gui', 'puredata-dev', 'puredata-doc',
             'puredata-extra', 'puredata-utils', 'puredata-import',
             'pd-aubio', 'pd-csound', 'pd-cyclone', 'pd-purepd']:
    before => Package['pd-extended']
  }
}
