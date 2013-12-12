# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant::Config.run do |config|
  config.vm.box = "bttf_vagrant_box"
  config.vm.box_url = "http://goo.gl/8kWkm"
  config.vm.forward_port 8000, 8080
  config.vm.share_folder "host_dir", "/home/vagrant/host_dir", "."
  config.vm.provision :puppet do |puppet|
    puppet.manifests_path = "manifests"
    puppet.manifest_file  = "base.pp"
  end
end
