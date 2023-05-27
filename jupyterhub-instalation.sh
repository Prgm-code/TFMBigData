#!/bin/bash
set -e

# Directorios y rutas
JUPYTER_DIR="/opt/jupyterhub"
JUPYTER_ENV_DIR="$JUPYTER_DIR/miniconda/envs/jupyterhub-env"
JUPYTER_CONFIG_DIR="$JUPYTER_DIR/.jupyterhub"
JUPYTER_LOG_DIR="$JUPYTER_DIR/log"
MINICONDA_INSTALLER="$JUPYTER_DIR/miniconda.sh"
MINICONDA_BIN_DIR="$JUPYTER_DIR/miniconda/bin"

# Crea los directorios necesarios
sudo mkdir -p $JUPYTER_CONFIG_DIR $JUPYTER_LOG_DIR
sudo chmod 777 $JUPYTER_CONFIG_DIR $JUPYTER_LOG_DIR

# Genera la secret key
openssl rand -hex 32 | sudo tee $JUPYTER_CONFIG_DIR/jupyterhub_cookie_secret
sudo chmod 400 $JUPYTER_CONFIG_DIR/jupyterhub_cookie_secret
cd $JUPYTER_DIR
# Descarga e instala miniconda
sudo curl https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -o $MINICONDA_INSTALLER
if [[ ! -f $MINICONDA_INSTALLER ]]; then
  echo "La descarga de Miniconda ha fallado"
  exit 1
fi
sudo bash $MINICONDA_INSTALLER -b -p $JUPYTER_DIR/miniconda
if [[ ! -d $MINICONDA_BIN_DIR ]]; then
  echo "La instalación de Miniconda ha fallado"
  exit 1
fi
sudo chown -R $USER:$USER $JUPYTER_DIR/miniconda
sudo chmod -R 777 $JUPYTER_DIR/miniconda


sudo rm $MINICONDA_INSTALLER

# Añade conda al PATH
echo 'export PATH="'$MINICONDA_BIN_DIR':$PATH"' >> ~/.bashrc
source ~/.bashrc

# Configura conda
$MINICONDA_BIN_DIR/conda config --set always_yes yes --set changeps1 no
$MINICONDA_BIN_DIR/conda update -q conda

# Crea el entorno de conda
$MINICONDA_BIN_DIR/conda create -p $JUPYTER_ENV_DIR python=3.8

# Instala los paquetes necesarios
$MINICONDA_BIN_DIR/conda install -p $JUPYTER_ENV_DIR -c conda-forge jupyterhub  notebook jupyterlab 

# Instala PySpark
$MINICONDA_BIN_DIR/conda install -p $JUPYTER_ENV_DIR -c conda-forge pyspark

# Inicia JupyterHub
$JUPYTER_ENV_DIR/bin/jupyterhub --generate-config
sudo mv jupyterhub_config.py $JUPYTER_DIR/

sudo echo "c.Spawner.default_url = '/lab'" >> $JUPYTER_DIR/jupyterhub_config.py
sudo echo "c.Authenticator.admin_users = {'hadoop', 'jupyterhub'}" >> $JUPYTER_DIR/jupyterhub_config.py
sudo echo "c.LocalAuthenticator.create_system_users = True" >> $JUPYTER_DIR/jupyterhub_config.py


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
