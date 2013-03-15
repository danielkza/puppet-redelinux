node default
{
    stage { 'pre-deploy': } -> Stage['main']
}
