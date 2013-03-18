class redelinux::desktop
{
    anchor{ 'redelinux::desktop::begin': }
    -> class { 'redelinux::desktop::apps': }
    -> class { 'redelinux::desktop::mozilla': }
    -> class { 'redelinux::desktop::xfce': }
    -> anchor { 'redelinux::desktop::end': }
}
