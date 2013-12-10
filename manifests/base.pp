$packages = [ 'mercurial', 'git', 'vim' ]
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

