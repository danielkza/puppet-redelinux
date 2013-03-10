class redelinux::desktop::apps
{
    require redelinux::apt
  
    Package {
        ensure => latest
    }
    
    package { 'blender': }
    package { 'audacity': }
    package { 'vlc': } 
}
