Vagrant.configure("2") do |config|
  config.vm.box = "ubuntu/jammy64"
  config.vm.boot_timeout = 600
  config.vm.synced_folder ".", "/vagrant", disabled: true

  servers = [
    { name: "ansible-admin", ip: "172.16.0.11", script: "scripts/install-ansible.sh", folder: "data-ansible" },
    { name: "web-nginx",    ip: "172.16.0.12", script: "scripts/install-nginx.sh",  folder: "data-nginx" },
    { name: "web-apache2",    ip: "172.16.0.13", script: "scripts/install-apache2.sh",  folder: "data-apache2" }
  ]

  servers.each do |srv|
      config.vm.define srv[:name] do |node|
        node.vm.hostname = "#{srv[:name]}.com.co"
        node.vm.network "private_network", ip: srv[:ip]
        node.vm.provider "virtualbox" do |vb|
          vb.name = srv[:name]
        end

      # Carpeta sincronizada específica por VM
      node.vm.synced_folder srv[:folder], "/home/vagrant/#{srv[:folder]}", type: "rsync", rsync__auto: true

      # Provisionamiento con generación de llave SSH
      node.vm.provision "shell", path: "scripts/generate-ssh-key.sh", privileged: false, run: "once"

      # Provisionamiento con script correspondiente
      node.vm.provision "shell", path: srv[:script], privileged: false, run: "once"
    end
  end
end
