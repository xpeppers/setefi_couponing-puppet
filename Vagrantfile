# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|

  config.vm.define "phoenix_vagrant" do |couponing|
    couponing.vm.box = "phoenix_vagrant"
    # it should be an Ubuntu server 12.04LTS
    couponing.vm.box_url = "~/vagrant_boxes/couponing_core.box"

    config.vm.synced_folder "~/phoenix-project", "/home/vagrant/phoenix-project", create: true
    config.vm.synced_folder "~/.m2", "/home/vagrant/.m2", create: true

    couponing.vm.provider "virtualbox" do |v|
      v.customize ["modifyvm", :id, "--memory", 512]
    end

    #couponing.vm.network "forwarded_port", guest: 8080, host: 8000

    couponing.vm.provision "puppet" do |puppet|
       puppet.manifests_path = "manifests"
       puppet.manifest_file  = "site.pp"
       puppet.module_path = "manifests/modules"
       puppet.options = "--verbose --debug"
    end
  end

end
