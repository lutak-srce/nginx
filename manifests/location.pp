#
# = Define: nginx::location
#
# This definition creates a new location entry within a virtual host
#
# == Parameters:
#
# [*location*]
#   Type: string
#   Specifies the URI associated with this location entry
#
# [*vhost*]
#   Type: string, default: undef
#   Defines the default vHost for this location entry to include with
#
# [*proxy*]
#   Type: string, default: undef
#   Proxy server(s) for a location to connect to.
#
# [*frontend_ssl*]
#   Type: boolean, default: false
#   If frontend will be SSL terminated, then add aditional flags to location.
#
# [*www_root*]
#   Type: string, default: undef
#   Specifies the location on disk for files to be read from. Cannot be
#   set in conjunction with $proxy
#
define nginx::location (
  $location,
  $vhost        = undef,
  $proxy        = undef,
  $frontend_ssl = false,
  $www_root     = undef,
  $template     = 'nginx/vhost/location.erb',
) {

  # vhost must be defined
  if ($vhost == undef) {
    fail('Cannot create a location reference without attaching to a virtual host.')
  }
  # proxy and www_root are not allowed to be defined
  if ($proxy != undef and $www_root != undef ) {
    fail('Cannot declare both $proxy and $www_root. Incompatible parameters.')
  }

  ::concat::fragment { "nginx_location_${name}":
    target  => "nginx_vhost_${vhost}",
    content => template($template),
    order   => '250',
  }

}
