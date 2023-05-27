#!/bin/bash
set -e
sudo apt-get install python3.10-venv -y
# Comprobar si Python 3 está instalado
command -v python3 >/dev/null 2>&1 || {
  echo >&2 "Python 3 no está instalado. Instalando...";
  sudo apt-get update;
  sudo apt-get install -y python3;
}

# Comprobar si pip está instalado
command -v pip3 >/dev/null 2>&1 || {
  echo >&2 "pip no está instalado. Instalando...";
  sudo apt-get install -y python3-pip;
}

# Comprobar si npm está instalado
command -v npm >/dev/null 2>&1 || {
  echo >&2 "npm no está instalado. Instalando...";
  sudo apt-get install -y npm;
}

# Directorios y rutas
JUPYTER_DIR="/opt/jupyterhub"
JUPYTER_ENV_DIR="$JUPYTER_DIR/env"
JUPYTER_CONFIG_DIR="$JUPYTER_DIR/.jupyterhub"
JUPYTER_LOG_DIR="$JUPYTER_DIR/log"

# Crea los directorios necesarios
sudo mkdir -p $JUPYTER_CONFIG_DIR $JUPYTER_LOG_DIR $JUPYTER_ENV_DIR
sudo chmod 777 $JUPYTER_CONFIG_DIR $JUPYTER_LOG_DIR $JUPYTER_ENV_DIR

# Genera la secret key
openssl rand -hex 32 | sudo tee $JUPYTER_CONFIG_DIR/jupyterhub_cookie_secret
sudo chmod 400 $JUPYTER_CONFIG_DIR/jupyterhub_cookie_secret
cd $JUPYTER_DIR

# Crea un entorno virtual de Python
sudo python3 -m venv $JUPYTER_ENV_DIR

# Activa el entorno virtual de Python
source $JUPYTER_ENV_DIR/bin/activate

# Actualiza pip
sudo pip install --upgrade pip

## otorga permisos de escritura a pip
sudo chmod 777 -R $JUPYTER_ENV_DIR


# Cambia el directorio de instalación global de npm a un directorio en tu directorio de inicio
if [[ ! -d ~/.npm-global ]]; then
    mkdir ~/.npm-global
    npm config set prefix '~/.npm-global'
    echo 'export PATH=~/.npm-global/bin:$PATH' >> ~/.profile
    source ~/.profile
fi

# Instala JupyterHub y proxy
pip install jupyterhub jupyterlab
npm install -g configurable-http-proxy

# Inicia JupyterHub
sudo touch $JUPYTER_DIR/jupyterhub_config.py


sudo chmod 777 $JUPYTER_DIR/jupyterhub_config.py

sudo echo "c.JupyterHub.bind_url = 'http://:9909'" >> $JUPYTER_DIR/jupyterhub_config.py
sudo echo "c.JupyterHub.cookie_secret_file = '/opt/jupyterhub/.jupyterhub/jupyterhub_cookie_secret'" >> $JUPYTER_DIR/jupyterhub_config.py
sudo echo "c.JupyterHub.db_url = 'sqlite:////opt/jupyterhub/.jupyterhub/jupyterhub.sqlite'" >> $JUPYTER_DIR/jupyterhub_config.py
sudo echo "c.PAMAuthenticator.admin_groups = {'wheel'}" >> $JUPYTER_DIR/jupyterhub_config.py
sudo echo "c.Spawner.default_url = '/lab'" >> $JUPYTER_DIR/jupyterhub_config.py
sudo echo "c.Authenticator.admin_users = {'hadoop', 'jupyterhub'}" >> $JUPYTER_DIR/jupyterhub_config.py
sudo echo "c.LocalAuthenticator.create_system_users = True" >> $JUPYTER_DIR/jupyterhub_config.py
sudo echo "c.JupyterHub.hub_ip = ''" >> $JUPYTER_DIR/jupyterhub_config.py

# Configura JupyterHub como un servicio
echo "[Unit]
Description=JupyterHub
After=syslog.target network.target

[Service]
User=root
Environment=\"PATH=/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:$JUPYTER_ENV_DIR/bin\"
ExecStart=$JUPYTER_ENV_DIR/bin/jupyterhub -f $JUPYTER_DIR/jupyterhub_config.py

[Install]
WantedBy=multi-user.target" | sudo tee /etc/systemd/system/jupyterhub.service

# Habilita e inicia el servicio JupyterHub
sudo systemctl daemon-reload
sudo systemctl enable jupyterhub
sudo systemctl start jupyterhub
