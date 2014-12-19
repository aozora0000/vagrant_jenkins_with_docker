# -*- mode: ruby -*-
# vi: set ft=ruby :

VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
    config.vm.box = "centos65"
    config.vm.box_url = "https://s3-ap-northeast-1.amazonaws.com/aozora-boxes/CentOS-6.4-x86.box"
    config.vm.network :private_network, ip: "192.168.33.200"
    config.vm.hostname = "jenkins"

    config.vm.provider "virtualbox" do |vb|
        vb.customize ["modifyvm", :id, "--memory",1024]
        vb.customize ["modifyvm", :id, "--natdnsproxy1", "off"]
        vb.customize ["modifyvm", :id, "--natdnshostresolver1", "off"]
        vb.customize ["setextradata", :id, "VBoxInternal/Devices/VMMDev/0/Config/GetHostTimeDisabled", 0]
    end

    if Vagrant.has_plugin?("vagrant-cachier")
        config.cache.scope = :box
        config.cache.synced_folder_opts = {
          type: :nfs,
          mount_options: ['rw', 'vers=3', 'tcp', 'nolock']
        }
    end

    config.vm.provision :ansible do |ansible|
        ansible.playbook = "./playbook.yml"
        ansible.inventory_path = "./hosts"
        ansible.limit = "all"
    end

    config.vm.provision :serverspec do |spec|
        spec.pattern = './spec/scripts/*_spec.rb'
    end
end
