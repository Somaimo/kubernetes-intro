# -*- mode: ruby -*-
# vim: ft=ruby


# ---- Custom settings ----

# Passwords for neo4j users
ADMINUSERNAME = "marc"
ADMINUSERPASS = "marc"
DEPLOYMENTSCRIPT = "provisioning/deploy-kube.sh"

# ---- Configuration variables ----

GUI               = false # Enable/Disable GUI
RAM               = 2048   # Default memory size in MB

# Network configuration
DOMAIN            = ".nat.test.lan"
NETWORK           = "192.168.50."
NETMASK           = "255.255.255.0"

# Default Virtualbox .box
BOX               = 'ubuntu/bionic64'


HOSTS = {
   "kube-master" => [NETWORK+"10", RAM, GUI, BOX],
   "kube-node01" => [NETWORK+"11", RAM, GUI, BOX],
   "kube-node02" => [NETWORK+"12", RAM, GUI, BOX]
}

# Variant with graphileon running in a separate VM with a Desktop Environment.
# This is not really functional because Graphileon cannot be run headless.
# HOSTS = {
#    "neo4j-app" => [NETWORK+"10", RAM, GUI, BOX],
#    "neo4j-data" => [NETWORK+"11", RAM, GUI, BOX],
#    # "graphileon" => [NETWORK+"12", RAM, GUI, "peru/ubuntu-18.04-desktop-amd64"]
# }

# ---- Vagrant configuration ----

Vagrant.configure(2) do |config|
  HOSTS.each do | (name, cfg) |
    ipaddr, ram, gui, box = cfg

    config.vm.define name do |machine|
      machine.vm.box   = box
      machine.vm.guest = :ubuntu

      machine.vm.provider "virtualbox" do |vbox|
        vbox.gui    = gui
        vbox.memory = ram
        vbox.name = name
      end

      machine.vm.hostname = name + DOMAIN
      machine.vm.network 'private_network', ip: ipaddr, netmask: NETMASK

      machine.vm.provision "shell", path: DEPLOYMENTSCRIPT
    end
  end # HOSTS-each
end
