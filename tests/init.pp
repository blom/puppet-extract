extract { 'puppet-extract master':
  file    => '/tmp/puppet-extract.tar.gz',
  url     => 'https://github.com/blom/puppet-extract/archive/master.tar.gz',
  target  => '/tmp',
  creates => '/tmp/puppet-extract-master',
}
