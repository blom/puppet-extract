#
define extract(
  $url     = undef,
  $target  = undef,
  $creates = undef,
  $taropts = '',
  $purge   = false
) {
  Exec {
    path => '/bin:/usr/bin:/usr/local/bin',
  }

  if $target  == undef { fail('target must be present') }
  if $creates == undef { fail('creates must be present') }

  if $url {
    exec { "download ${url} to ${title}":
      command => "curl -L ${url} -o ${title}",
      onlyif  => ["test ! -e ${title}", "test ! -e ${creates}"],
    }
  }

  $extract_require = $url ? {
    undef   => undef,
    default => Exec["download ${url} to ${title}"],
  }
  exec { "extract ${title}":
    command => "tar x${taropts}f ${title} -C ${target}",
    require => $extract_require,
    creates => $creates,
  }

  if $purge {
    file { $title:
      ensure  => absent,
      require => Exec["extract ${title}"],
    }
  }
}
