#
# = Class: nginx::config
#
# This class provides some advanced nginx settings
#
# Parameters:
#   [*server_names_hash_bucket_size*] - maximum length of a virtual host entry
#   [*types_hash_max_size*]           - maximum size of the types hash tables
#   [*types_hash_bucket_size*]        - bucket size for the types hash tables
#
class nginx::config (
  $server_names_hash_bucket_size = '64',
  $types_hash_max_size           = '1024',
  $types_hash_bucket_size        = '64',
) {
  include ::nginx

  $curnotify = $::nginx::manage_service ? {
    default => undef,
    true    => Service['nginx'],
  }

  file { "${::nginx::conf_dir}/conf.d/advanced_config.conf":
    ensure  => file,
    owner   => root,
    group   => root,
    content => template('nginx/advanced_config.erb'),
    notify  => $curnotify,
  }

}
