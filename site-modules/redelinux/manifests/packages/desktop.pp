class redelinux::packages::desktop
{
  contain redelinux::packages::desktop::apps
  contain redelinux::packages::desktop::mozilla
  contain redelinux::packages::desktop::xfce
}
