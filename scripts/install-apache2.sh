#!/bin/bash
set -e

echo "---Actualización de paquetes---"
sudo apt-get update && sudo apt-get upgrade -y

echo "---Instalación de Apache2---"
sudo apt-get install apache2 -y

echo "---Habilitar Apache2 para que se inicie al arrancar el sistema---"
sudo systemctl enable nginx

echo "---Iniciar Nginx---"
sudo systemctl start apache2
sudo systemctl enable apache2

echo "---Habilitar el firewall para Apache2---"
sudo ufw allow 'Apache'

echo "---Habilitar el firewall para SSH---"
sudo ufw allow 22/tcp

echo "---Habilitar el firewall---"
sudo ufw enable

echo "---Verificar el estado del firewall---"
sudo ufw status

echo "---Verificar el estado de Nginx---"
sudo systemctl status apache2

echo "---Verificar la instalación de Nginx---"
curl -I http://localhost