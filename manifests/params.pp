# Class: nginx::params
#
# This module manages NGINX paramaters
#
# Parameters:
#
# There are no default parameters for this class.
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
# This class file is not called directly
class nginx::params {
  # pupppet module options
  $manage_service = true

  # general settings
  $conf_dir  = '/etc/nginx'
  $confd_dir = '/etc/nginx/conf.d'
  $log_dir   = '/var/log/nginx'
  $pid_file  = '/var/run/nginx.pid'
  $service   = 'nginx'

  if $::osfamily == 'redhat' or $::operatingsystem == 'amazon' {
    $daemon_user = 'nginx'
  } elsif $::osfamily == 'debian' {
    $daemon_user = 'www-data'
  }

  # performance settings
  $multi_accept       = 'off'

  $worker_processes   = 1
  $worker_connections = 1024

  $sendfile           = 'on'
  $tcp_nopush         = 'on'

  $keepalive_timeout  = 65
  $tcp_nodelay        = 'on'

  $gzip               = 'on'
}
