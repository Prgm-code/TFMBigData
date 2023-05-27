#!/bin/bash

# Actualizar la lista de paquetes
sudo apt-get update

# Instalar NTP
sudo apt-get install -y ntp

# Copiar el archivo de configuración original por si acaso
sudo cp /etc/ntp.conf /etc/ntp.conf.bak

# Configurar el pool de servidores de tiempo
echo "server 0.pool.ntp.org iburst" | sudo tee /etc/ntp.conf
echo "server 1.pool.ntp.org iburst" | sudo tee -a /etc/ntp.conf
echo "server 2.pool.ntp.org iburst" | sudo tee -a /etc/ntp.conf
echo "server 3.pool.ntp.org iburst" | sudo tee -a /etc/ntp.conf

# Reiniciar el servicio NTP para que los cambios tengan efecto
sudo service ntp restart

# Configurar la zona horaria del sistema para UTC
sudo timedatectl set-timezone UTC

# Verificar el estado del servicio NTP
sudo ntpq -p

# Verificar la zona horaria del sistema
timedatectl
