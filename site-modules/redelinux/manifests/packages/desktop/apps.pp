class redelinux::desktop::apps
{
  Package {
    ensure => installed,
  }

  package { 'blender': }
  package { 'audacity': }
  package { 'vlc': } 
}
