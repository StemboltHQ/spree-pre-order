SpreePreOrder
=============

This provides functionality to offer a product for pre-order, bill a deposit amount
then at some later point, bill the remaining price when the item is ready to be
shipped.

Compatability Notice
====================

This branch of spree-pre-order may not work for your codebase.
We backported certain changes from Spree master in our local fork, most notably the removal of object params.

While this is done in later versions of spree, this branch has only been tested against our local version of spree.
The master branch works with Spree 1-3-stable.

Example
=======

Testing
-------

Be sure to bundle your dependencies and then create a dummy test app for the specs to run against.

    $ bundle
    $ bundle exec rake test_app
    $ bundle exec rspec spec

Copyright (c) 2013 FreeRunning Technologies, released under the New BSD License
