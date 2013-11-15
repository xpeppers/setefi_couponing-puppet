# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.box = "couponing_deploy"

  # it should be an Ubuntu server 12.04LTS
  #config.vm.box_url = "couponing_deploy.box"
  config.vm.box_url = "~/fake_services/fake_services.box"

  config.vm.network :bridged
  # config.vm.network :forwarded_port, guest: 3100, host: 3100
  # config.vm.network :hostonly, "192.168.10.90"

  config.vm.provider "virtualbox" do |v|
    config.vm.customize ["modifyvm", :id, "--memory", 512]
  end

  # config.vm.share_folder "v-data", "/vagrant_data", "../data"

  config.vm.provision "puppet" do |puppet|
     puppet.manifests_path = "manifests"
     puppet.manifest_file  = "base.pp"
  end

end
