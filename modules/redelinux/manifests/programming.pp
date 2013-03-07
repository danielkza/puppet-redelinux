class redelinux::programming
{
    anchor { ['redelinux::programming::begin',
              'redelinux::programming::end']: }

    Anchor['redelinux::programming::begin']
    -> Class['languages', 'tools_and_libs', 'editors_and_ides']
    -> Anchor['redelinux::programming::end']

    include redelinux::programming::languages
    include redelinux::programming::tools_and_libs
    include redelinux::programming::editors_and_ides


}
