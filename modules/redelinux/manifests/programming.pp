class redelinux::programming
{
    include redelinux::programming::languages
    include redelinux::programming::tools_and_libs
    include redelinux::programming::editors_and_ides

    anchor{ 'redelinux::programming::begin': }
    -> Class['redelinux::programming::languages',
             'redelinux::programming::tools_and_libs',
             'redelinux::programming::editors_and_ides']
    -> anchor { 'redelinux::programming::end': }
}
