puppet-extract
=============

[![Build Status](https://travis-ci.org/blom/puppet-extract.png)](https://travis-ci.org/blom/puppet-extract)

* [Homepage](https://github.com/blom/puppet-extract)

Puppet module for downloading and extracting archives. Requires `curl` to be
installed.

Installation
------------

### Puppetfile

    mod "extract", :git => "https://github.com/blom/puppet-extract.git"

Usage
-----

    extract { '/opt/example-1.2.3.tar.gz':
      url     => 'http://example.com/example-1.2.3.tar.gz',
      target  => '/opt',
      creates => '/opt/example-1.2.3',
    }

Takes the following attributes:

* `file` (optional): Archive file location, overrides title (default: `undef`).
* `url` (optional): Where to download the archive (default: `undef`).
* `target` (required): Where to extract the archive.
* `creates` (required): Directory created when extracted.
* `taropts` (optional): Extra tar options in addition to `xf` (default: `''`).
* `purge` (optional): Purge archive after extraction (default: `false`)?
