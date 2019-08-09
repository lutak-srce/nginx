#
# = Define: nginx::vhost
#
# This definition creates a new virtual host
#
define nginx::vhost (
  $listen,
  $docroot,
  $docroot_owner     = 'root',
  $docroot_group     = 'root',
  $index             = ['index.html', 'index.htm', 'index.php'],
  $ssl               = false,
  $ssl_cert          = undef,
  $ssl_key           = undef,
  $ssl_client_cert   = undef,
  $hsts              = '',
  $template          = 'nginx/vhost/header.erb',
  $priority          = 'vhost',
  $log_dir           = '',
  $servername        = undef,
) {
  include nginx

  # set the server name correctly
  if $servername == undef {
    $srvname = $name
  } else {
    $srvname = $servername
  }

  # set the logroot correctly
  if $log_dir == '' {
    $logroot = $::nginx::log_dir
  } else {
    $logroot = $log_dir
  }

  # Check to see if SSL Certificates are properly defined.
  if ($ssl == true) {
    if ($ssl_cert == undef) or ($ssl_key == undef) {
      fail('nginx: SSL certificate/key (ssl_cert/ssl_cert) and/or SSL Private must be defined and exist on the target system(s)')
    }
  }

  # This ensures that the docroot exists
  # But enables it to be specified across multiple vhost resources
  if ! defined(File[$docroot]) {
    file { $docroot:
      ensure => directory,
      owner  => $docroot_owner,
      group  => $docroot_group,
    }
  }

  # vhost configuration file
  # we use concat
  $concat_notify = $::nginx::manage_service ? {
    default => undef,
    true    => Service['nginx'],
  }
  $concat_require = $ssl ? {
    default => undef,
    true    => File[$ssl_cert, $ssl_key],
  }
  concat { "nginx_vhost_${name}":
    path    => "${::nginx::conf_dir}/conf.d/${priority}-${name}.conf",
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    notify  => $concat_notify,
    require => $concat_require,
  }
  # fragments
  concat::fragment { "nginx_${name}_header":
    target  => "nginx_vhost_${name}",
    content => template($template),
    order   => '100',
  }
  concat::fragment { "nginx_${name}_footer":
    target  => "nginx_vhost_${name}",
    content => '}',
    order   => '300',
  }

}
