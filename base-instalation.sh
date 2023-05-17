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
#creamos las carpetas necesarias para el funcionamiento de Hadoop
sudo mkdir -p /opt/hadoop/data/namenode
sudo mkdir -p /opt/hadoop/data/datanode
sudo mkdir -p /opt/zookeeper/data
sudo touch /opt/zookeeper/data/myid

# asignamos los permisos necesarios (777)
sudo chown -R $USER:$USER /opt/zookeeper
sudo chown -R $USER:$USER /opt/hadoop
sudo chown -R $USER:$USER /opt/hbase
sudo chmod -R 777 /opt/zookeeper
sudo chmod -R 777 /opt/hadoop
sudo chmod -R 777 /opt/hbase




# Descargamos e instalamos Hadoop

wget https://dlcdn.apache.org/hadoop/common/hadoop-2.10.2/hadoop-2.10.2.tar.gz
tar xzf hadoop-2.10.2.tar.gz
mv  hadoop-2.10.2/* /opt/hadoop
rm hadoop-2.10.2.tar.gz
rm -rf hadoop-2.10.2



#permisos para las carpetas de Hadoop
sudo chown -R $USER:$USER /opt/hadoop
sudo chmod -R 777 /opt/hadoop


# Descargamos e instalamos Zookeeper
wget https://dlcdn.apache.org/zookeeper/zookeeper-3.7.1/apache-zookeeper-3.7.1-bin.tar.gz
tar xzf apache-zookeeper-3.7.1-bin.tar.gz
mv apache-zookeeper-3.7.1-bin/* /opt/zookeeper
rm apache-zookeeper-3.7.1-bin.tar.gz
rm -rf apache-zookeeper-3.7.1-bin


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
echo "El ID del nodo en el archivo myid:"
cat /opt/zookeeper/data/myid

# Descargamos e instalamos HBase
wget https://dlcdn.apache.org/hbase/2.4.17/hbase-2.4.17-bin.tar.gz
tar xzf hbase-2.4.17-bin.tar.gz
mv hbase-2.4.17/* /opt/hbase
rm hbase-2.4.17-bin.tar.gz
rm -rf hbase-2.4.17



# Verifica si las variables de entorno ya están definidas en el perfil del usuario
if ! grep -q "JAVA_HOME" ~/.bashrc || ! grep -q "HADOOP_HOME" ~/.bashrc || ! grep -q "HBASE_HOME" ~/.bashrc || ! grep -q "ZOOKEEPER_HOME" ~/.bashrc; then
# Carga las variables de entorno desde el archivo en el perfil del usuario

# Ruta del directorio de instalación de Java

echo "export JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64" >> ~/.bashrc

# Ruta del directorio de instalación de Hadoop
echo "export HADOOP_HOME=/opt/hadoop" >> ~/.bashrc

# Ruta del directorio de instalación de HBase
echo "export HBASE_HOME=/opt/hbase" >> ~/.bashrc

# Ruta del directorio de instalación de ZooKeeper
echo "export ZOOKEEPER_HOME=/opt/zookeeper" >> ~/.bashrc

# Actualización del PATH para incluir las rutas de las herramientas
echo 'export PATH=$PATH:$HADOOP_HOME/bin:$HADOOP_HOME/sbin:$HBASE_HOME/bin:$ZOOKEEPER_HOME/bin' >> ~/.bashrc
# Recarga el perfil del usuario
source ~/.bashrc
fi



# imprimir el valor de las variables de entorno
echo "JAVA_HOME: $JAVA_HOME"
echo "HADOOP_HOME: $HADOOP_HOME"
echo "HBASE_HOME: $HBASE_HOME"
echo "ZOOKEEPER_HOME: $ZOOKEEPER_HOME"

source ~/.bashrc


echo "Instalación finalizada. Por favor, verifica las variables de entorno y los archivos de configuración."

