#!/bin/bash
# Actualizamos el sistema
sudo apt-get update
sudo apt-get upgrade -y

# Instalamos Java 8
sudo apt-get install openjdk-8-jdk -y

# Verificamos la instalación de Java
java -version

# creamos los directorios para instalar Hadoop, Zookeeper y HBase
sudo mkdir -p /opt/hadoop
sudo mkdir -p /opt/zookeeper
sudo mkdir -p /opt/hbase

# asignamos los permisos necesarios (777)
sudo chown -R $USER:$USER /opt/zookeeper
sudo chown -R $USER:$USER /opt/hadoop
sudo chown -R $USER:$USER /opt/hbase
sudo chmod -R 777 /opt/zookeeper
sudo chmod -R 777 /opt/hadoop
sudo chmod -R 777 /opt/hbase



# Descargamos e instalamos Hadoop
cd /opt
wget https://dlcdn.apache.org/hadoop/common/hadoop-2.10.2/hadoop-2.10.2.tar.gz
tar xzf hadoop-2.10.2.tar.gz
mv hadoop-2.10.2 /opt/hadoop
rm hadoop-2.10.2.tar.gz

#creamos las carpetas necesarias para el funcionamiento de Hadoop
mkdir -p /opt/hadoop/data/namenode
mkdir -p /opt/hadoop/data/datanode

#permisos para las carpetas de Hadoop
sudo chown -R $USER:$USER /opt/hadoop
sudo chmod -R 777 /opt/hadoop


# Descargamos e instalamos Zookeeper
wget https://dlcdn.apache.org/zookeeper/zookeeper-3.7.1/apache-zookeeper-3.7.1-bin.tar.gz
tar xzf zookeeper-3.7.1.tar.gz
mv zookeeper-3.7.1 /opt/zookeeper
rm zookeeper-3.7.1.tar.gz

#crea el archivo myid en el directorio data de zookeeper segun si es master=1, worker=2 o edge=3
# Configurar el ID del nodo
case "$(hostname)" in
    master)
        echo 1 > /opt/zookeeper/data/myid
        echo "El hostname corresponde a 'master', se creó el ID del nodo 1."
        ;;
    worker)
        echo 2 > /opt/zookeeper/data/myid
        echo "El hostname corresponde a 'worker', se creó el ID del nodo 2."
        ;;
    edge)
        echo 3 > /opt/zookeeper/data/myid
        echo "El hostname corresponde a 'edge', se creó el ID del nodo 3."
        ;;
    *)
        echo "Hostname desconocido, no se puede configurar el ID del nodo"
        exit 1
        ;;
esac

# Descargamos e instalamos HBase
wget https://dlcdn.apache.org/hbase/2.4.17/hbase-2.4.17-src.tar.gz
tar xzf hbase-2.4.17-bin.tar.gz
mv hbase-2.4.17 /opt/hbase
rm hbase-2.4.17-bin.tar.gz

# Configuramos las variables de entorno en el archivo ~/.bashrc
echo 'export JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64' >> ~/.bashrc
echo 'export HADOOP_HOME=/opt/hadoop' >> ~/.bashrc
echo 'export HBASE_HOME=/opt/hbase' >> ~/.bashrc
echo 'export ZOOKEEPER_HOME=/opt/zookeeper' >> ~/.bashrc
echo 'export PATH=$PATH:$HADOOP_HOME/bin:$HADOOP_HOME/sbin:$HBASE_HOME/bin:$ZOOKEEPER_HOME/bin' >> ~/.bashrc

source ~/.bashrc


echo "Instalación finalizada. Por favor, verifica las variables de entorno y los archivos de configuración."

