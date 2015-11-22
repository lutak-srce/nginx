#
# = Class: nginx::http2https
#
# This class enables http to https rewriting for *
class nginx::http2https {

  include ::nginx

  $curnotify = $::nginx::manage_service ? {
    default => undef,
    true    => Service['nginx'],
  }

  file { "${::nginx::conf_dir}/conf.d/http2https.conf":
    ensure => file,
    owner  => root,
    group  => root,
    source => 'puppet:///modules/nginx/http2https.conf',
    notify => $curnotify,
  }

}
