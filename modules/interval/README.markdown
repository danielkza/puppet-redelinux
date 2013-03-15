puppet-interval
===============

Adds a Puppet function to generate array of evenly spaced but randomly selected numbers

Usage:
------

    interval(count, max)

  * count:  the number of values to return
  * max:    the upper limit of the random numbers, exclusive

Example:
--------

    # Generate three random numbers between 0 and 60
    $arr = interval(3, 60)
    # => [19, 39, 59]

