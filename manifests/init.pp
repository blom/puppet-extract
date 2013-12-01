#
define extract(
  $target,
  $creates,
  $file    = undef,
  $url     = undef,
  $taropts = '',
  $purge   = false
) {
  Exec {
    path => '/bin:/usr/bin:/usr/local/bin',
  }

  $archive_file = $file ? {
    undef   => $title,
    default => $file,
  }

  if $url {
    exec { "download ${url} to ${archive_file}":
      command => "curl -L ${url} -o ${archive_file}.tmp && mv ${archive_file}.tmp ${archive_file}",
      onlyif  => ["test ! -e ${archive_file}", "test ! -e ${creates}"],
    }
  }

  $extract_require = $url ? {
    undef   => undef,
    default => Exec["download ${url} to ${archive_file}"],
  }
  exec { "extract ${archive_file}":
    command => "tar x${taropts}f ${archive_file} -C ${target}",
    require => $extract_require,
    creates => $creates,
  }

  if $purge {
    file { $archive_file:
      ensure  => absent,
      require => Exec["extract ${archive_file}"],
    }
  }
}
