class redelinux::desktop::apps
{
    Package {
        ensure => latest,
    }
    
    package { 'blender': }
    package { 'audacity': }
    package { 'vlc': } 
}
