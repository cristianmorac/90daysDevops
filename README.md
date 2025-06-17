# Crear Servidores con vagrant

**Vagrant** es una herramienta para la creación de entornos virtualizados a través de comandos y archivos de configuración.

## Diagrama

![Diagrama vagrant](img/diagrama-vagrant.svg)

## Estructura del proyecto

```sh
semana-03/
├── README.md       # Documentación crear servidores
├── data-apache2    # página web y archivos de configuración
├── data-nginx      # página web y archivos de configuración
├── ansible
   ├── inventori.ini    # inventario de servidores
├── scripts
    ├── generate-ssh-key.sh   # crear clave ssh pública
    ├── install-ansible.sh    # isntalar ansible con entorno virtual
    ├── install-apache2.sh    # instalar apache2
    ├── install-nginx.sh      # instalar nginx      
```

## Información de los ficheros

### Vagrantfile

#### configuración general de la máquina virtual
```bash
Vagrant.configure("2") do |config|
  ---
end
```
- Inicia el bloque de configuración de Vagrant.
- `"2"` indica la versión del archivo de configuración.

#### Configuraciones básicas
```bash
config.vm.box = "ubuntu/jammy64"
  config.vm.boot_timeout = 600
  config.vm.synced_folder ".", "/vagrant", disabled: true
```
- **config.vm.box:** imagen base
- **config.vm.boot_timeout:** Tiempo de espera para el arranque de la máquina virtual
- **config.vm.synced_folder:** Sincronización de directorios entre el host y la VM
  - `disabled: true`: Desactiva la sincronización por defecto entre el directorio host y directorio de la VM `/vagrant`.

#### Lista de servidores
```bash
servers = [
    { name: "ansible-admin", ip: "172.16.0.11", script: "scripts/install-ansible.sh", folder: "ansible" },
    { name: "web-nginx",    ip: "172.16.0.12", script: "scripts/install-nginx.sh",  folder: "data-nginx" },
    { name: "web2-apache",    ip: "172.16.0.13", script: "scripts/install-apache2.sh",  folder: "data-apache2" }
  ]
```

#### Bucle para configuraciones en la lista de servidores
```bash
servers.each do |srv|
  ---
end
```
- Recorrer por cada servidor
```bash
config.vm.define srv[:name] do |node|
  node.vm.hostname = "#{srv[:name]}.com.co" # DNS
  node.vm.network "private_network", ip: srv[:ip] # IP privada
end
```

- Configuración de la máquina virtual
```bash
node.vm.provider "virtualbox" do |vb|
    vb.name = srv[:name] # nombre de la máquina virtual
end
```
- Sincronización de carpetas entre el host y la VM
  - `disabled: true`: Desactiva la sincronización por defecto entre el proyecto local y `/vagrant`.
  - `type: "rsync"`: Usa `rsync` para sincronizar la carpeta local `data-web` con `/home/vagrant/data-xxx` en la VM.
  - `rsync__auto: true`: Habilita la sincronización automática al detectar cambios locales.

```bash
config.vm.synced_folder ".", "/vagrant", disabled: true
config.vm.synced_folder "data-web", "/home/vagrant/data-web", type: "rsync", rsync__auto: true
```
- Aprovisionamiento
  - Ejecución de scripts de instalación
  - `run: "once` Solo ejecuta una sola vez el aprovisionamiento

```bash
# Generación de llave SSH
node.vm.provision "shell", path: "scripts/generate-ssh-key.sh", privileged: false, run: "once"

# Instalación de dependencias con script correspondiente
node.vm.provision "shell", path: srv[:script], privileged: false, run: "once"
```



