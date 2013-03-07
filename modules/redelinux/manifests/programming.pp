class redelinux::programming
{
    anchor { 'redelinux::ssh::begin',
             'redelinux::ssh::end': }
    Anchor['redelinux::ssh::begin']
    -> Class['languages', 'tools_and_libs', 'editors_and_ides']
    -> Anchor['redelinux::ssh::end']

    include redelinux::programming::languages
    include redelinux::programming::tools_and_libs
    include redelinux::programming::editors_and_ides


}
