# -*- mode: ruby -*-
# vi: set ft=ruby :

ENV["LC_ALL"] = "en_US.UTF-8"

Vagrant.require_version ">= 2.2.9"
if !Vagrant.has_plugin?('vagrant-hostmanager')
    puts "Plugin vagrant-hostmanager is missing!"
    exit 1
end

Vagrant.configure(2) do |config|
  BOX_IMAGE = "centos/7"
  NODE_COUNT = 2
  NODE_MEMORY = 4096
  NETWORK_NAME = "atomsphere_network"

  config.hostmanager.enabled = true
  config.hostmanager.ip_resolver = proc do |vm, resolving_vm|
     if vm.id
       `VBoxManage guestproperty get #{vm.id} "/VirtualBox/GuestInfo/Net/1/V4/IP"`.split()[1]
     end
  end

  config.vm.define "database" do |db|
    db.vm.box = BOX_IMAGE
    db.vm.hostname = "database"
    db.vm.network :private_network, ip: "192.168.20.10", virtualbox__intnet: NETWORK_NAME
    db.vm.network "forwarded_port", guest: 1521, host: 1521
    db.vm.network "forwarded_port", guest: 5500, host: 5500

    db.vm.provider "virtualbox" do |vb|
      vb.gui = false
      vb.name = "atomsphere-database"
      vb.memory = "8192"
      vb.cpus = 2
    end

    db.vm.provision "shell" do |s|
      s.path = "provision/provisionDatabase.sh"
      s.env = {
               ORACLE_SID: "XE",
               ORACLE_PASSWORD: "manager10g",
               ORACLE_CHARACTERSET: "AL32UTF8",
               ORACLE_BASE: "/opt/oracle",
               ORACLE_HOME: "/opt/oracle/product/18c/dbhomeXE"
             }
    end
  end

  (1..NODE_COUNT).each do |i|
    config.vm.define "node#{i}" do |node|
      node.vm.box = BOX_IMAGE
      node.vm.hostname = "node#{i}"
      node.vm.network :private_network, ip: "192.168.20.#{i + 20}", virtualbox__intnet: NETWORK_NAME
      HOST_PORT = 8840+i
      node.vm.network "forwarded_port", guest: 8843, host: HOST_PORT

      node.vm.provider "virtualbox" do |vb|
        vb.gui = false
        vb.name = "atomsphere-node#{i}"
        vb.memory = NODE_MEMORY
        vb.cpus = 1
      end

      node.vm.provision "shell" do |s|
        s.path = "provision/provisionNode.sh"
        s.env = {
                }
      end
    end
  end

  config.vm.provision "shell", inline: <<-SHELL
      echo "Installing which..."
      sudo yum -y -t install which > /dev/null
      echo "Installing wget..."
      sudo yum -y -t install wget > /dev/null
      echo "Installing curl..."
      sudo yum -y -t install curl > /dev/null
  SHELL

end
