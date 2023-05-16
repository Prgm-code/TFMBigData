#!/bin/bash

# Actualizar la lista de paquetes
sudo apt-get update

# Instalar sshpass
sudo apt-get install -y sshpass

# Verificar si ya existe un par de claves SSH en el directorio ~/.ssh
if [ ! -f ~/.ssh/id_rsa.pub ]; then
    # Generar un nuevo par de claves SSH (presiona enter para todas las preguntas)
    ssh-keygen -t rsa -N '' -f ~/.ssh/id_rsa
fi

# Copiar la clave pública al nodo master
sshpass -p 'hadoop' ssh-copy-id -i ~/.ssh/id_rsa.pub hadoop@master

# Copiar la clave pública al nodo worker
sshpass -p 'hadoop' ssh-copy-id -i ~/.ssh/id_rsa.pub hadoop@worker

# Copiar la clave pública al nodo edge
sshpass -p 'hadoop' ssh-copy-id -i ~/.ssh/id_rsa.pub hadoop@edge
