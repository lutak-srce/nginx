#
# = Class: nginx
#
# This module manages NGINX.
#
class nginx (
  $manage_service     = $::nginx::params::manage_service,
  $service            = $::nginx::params::service,
  $conf_dir           = $::nginx::params::conf_dir,
  $confd_dir          = $::nginx::params::confd_dir,
  $log_dir            = $::nginx::params::log_dir,
  $pid_file           = $::nginx::params::pid_file,
  $daemon_user        = $::nginx::params::daemon_user,
  $multi_accept       = $::nginx::params::multi_accept,
  $worker_processes   = $::nginx::params::worker_processes,
  $worker_connections = $::nginx::params::worker_connections,
  $sendfile           = $::nginx::params::sendfile,
  $tcp_nopush         = $::nginx::params::tcp_nopush,
  $keepalive_timeout  = $::nginx::params::keepalive_timeout,
  $tcp_nodelay        = $::nginx::params::tcp_nodelay,
  $gzip               = $::nginx::params::gzip,
) inherits nginx::params {

  include ::nginx::config

  File {
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    require => Package['nginx'],
  }

  # install nginx
  package { 'nginx': ensure => present, }

  # create conf dirs
  file { '/etc/nginx':
    ensure => directory,
    path   => $conf_dir,
  }
  file { '/etc/nginx/conf.d':
    ensure  => directory,
    path    => $confd_dir,
    recurse => true,
    purge   => true,
  }

  # main config file
  file { "${conf_dir}/nginx.conf":
    content => template('nginx/nginx.conf.erb'),
  }

  # logrotate
  file { '/etc/logrotate.d/nginx':
    content => template('nginx/logrotate.erb'),
  }

  # manage nginx service
  if $manage_service == true {
    service { 'nginx':
      ensure    => running,
      enable    => true,
      subscribe => File["${conf_dir}/nginx.conf"],
      require   => Package['nginx'],
    }
  }
}
