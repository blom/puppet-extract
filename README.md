puppet-extract
=============

[![Build Status](https://travis-ci.org/blom/puppet-extract.png)](https://travis-ci.org/blom/puppet-extract)

* [Homepage](https://github.com/blom/puppet-extract)

Extracts an archive file and optionally downloads it first (expects `curl`
to be installed).

Usage
-----

    extract { '/opt/example-1.2.3.tar.gz':
      url     => 'http://example.com/example-1.2.3.tar.gz',
      target  => '/opt',
      creates => '/opt/example-1.2.3',
    }

Takes the following attributes:

* `url` (optional): Where to download the archive (default: `undef`).
* `target` (required): Where to extract the archive (default: `undef`).
* `creates` (required): Directory created when extracted (default: `undef`).
* `taropts` (optional): Extra tar options in addition to `xf` (default: `''`).
* `purge` (optional): Purge archive after extraction (default: `false`)?