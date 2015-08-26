# Private class
class xdmod::install {

  case $::osfamily {
    'RedHat': {
      include ::epel
      $package_require = Yumrepo['epel']
      package { 'xdmod':
        ensure  => $xdmod::package_ensure,
        name    => $xdmod::package_name,
        require => $package_require,
      }
    }
    'Debian': {
      include staging
      staging::file { 'xdmod-5.0.0.tar.gz':
        source => 'http://downloads.sourceforge.net/project/xdmod/xdmod/5.0.0/xdmod-5.0.0.tar.gz'
      }
      staging::extract { 'xdmod-5.0.0.tar.gz':
        target  => '/var/tmp',
        creates => '/var/tmp/xdmod-5.0.0',
        require => Staging::File[ 'xdmod-5.0.0.tar.gz' ]
      }
      exec { 'install':
        command => "./install --prefix=/opt/xdmod",
        unless  => [ "test -d /opt/xdmod" ],
        cwd     => '/var/tmp/xdmod-5.0.0',
        path    => [ '/usr/bin','/bin','/usr/sbin' ],
      }
    }
    default: {
      # Do nothing
    }
  }


}
