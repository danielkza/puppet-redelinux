class redelinux::desktop::apps
{
    include redelinux::apt
  
    Package {
        ensure => latest
    }
    
    package { 'blender': }
    package { 'audacity': }
    package { 'vlc': } 
}