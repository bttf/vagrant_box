$packages = [ 'mercurial', 'git', 'vim', 'make']
$gems = [ 'rspec-puppet', 'puppetlabs_spec_helper', 'rake' ]

package {$packages:
  ensure => installed,
  before => Exec['dotfiles'],
}

package {$gems:
  ensure   => 'installed',
  provider => 'gem',
}

exec {'dotfiles':
  cwd       => '/home/vagrant/',
  creates   => '/home/vagrant/dotfiles',
  command   => 'git clone --recursive https://github.com/bttf/dotfiles',
  logoutput => 'on_failure',
  path      => [ '/bin', '/usr/bin', '/usr/local/bin' ],
}

exec {'deathstar_plans':
  cwd       => '/home/vagrant',
  user      => 'vagrant',
  creates   => '/home/vagrant/deathstar-plans',
  command   => 'git clone https://github.com/bttf/deathstar_plans',
  logoutput => 'on_failure',
  path      => [ '/bin', '/usr/bin', '/usr/local/bin' ],
}

file {'/home/vagrant/.vimrc':
  ensure  => 'link',
  target  => '/home/vagrant/dotfiles/vimrc',
  require => Exec['dotfiles'],
}

file {'/home/vagrant/.vim':
  ensure  => 'link',
  target  => '/home/vagrant/dotfiles/vimfiles',
  require => Exec['dotfiles'],
}

file { 'downloads_dir':
  ensure => directory,
  path   => '/home/vagrant/downloads',
  mode   => '0755',
  owner  => 'vagrant',
  group  => 'vagrant',
}

$nix_path = [ '/bin', '/usr/bin', '/usr/local/bin' ]

exec { 'get_node_tar':
  user    => 'vagrant',
  cwd     => '/home/vagrant/downloads',
  command => 'wget http://nodejs.org/dist/v0.10.22/node-v0.10.22.tar.gz',
  path    => $nix_path,
  creates => '/home/vagrant/downloads/node-v0.10.22.tar.gz',
  require => File['downloads_dir'],
}

exec { 'untar_node':
  user    => 'vagrant',
  cwd     => '/home/vagrant/downloads',
  command => 'tar zxvf node-v0.10.22.tar.gz',
  path    => $nix_path,
  creates => '/home/vagrant/downloads/node-v0.10.22',
  require => Exec['get_node_tar'],
  notify  => Exec['make_node'],
}

exec { 'make_node':
  cwd         => '/home/vagrant/downloads/node-v0.10.22',
  path        => $nix_path,
  command     => './configure && make && make install',
  refreshonly => true,
  require     => [ Exec['untar_node'], Package[$packages] ],
}

