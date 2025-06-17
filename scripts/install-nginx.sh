#!/bin/bash
set -e

echo "---Actualización de paquetes---"
sudo apt-get update && sudo apt-get upgrade -y

echo "---Instalación de Nginx---"
sudo apt-get install nginx -y

echo "---Habilitar Nginx para que se inicie al arrancar el sistema---"
sudo systemctl enable nginx
sudo systemctl enable nginx

echo "---Iniciar Nginx---"
sudo systemctl start nginx

echo "---Habilitar el firewall para Nginx---"
sudo ufw allow 'Nginx Full'

echo "---Habilitar el firewall para SSH---"
sudo ufw allow 22/tcp

echo "---Habilitar el firewall---"
sudo ufw enable

echo "---Verificar el estado del firewall---"
sudo ufw status

echo "---Verificar el estado de Nginx---"
sudo systemctl status nginx

echo "---Verificar la instalación de Nginx---"
curl -I http://localhost