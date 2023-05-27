#!/bin/bash

# Declaración de las variables de entorno

# Ruta del directorio de instalación de Java
export JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64

# Ruta del directorio de instalación de Hadoop
export HADOOP_HOME=/opt/hadoop

# Ruta del directorio de instalación de HBase
export HBASE_HOME=/opt/hbase

# Ruta del directorio de instalación de ZooKeeper
export ZOOKEEPER_HOME=/opt/zookeeper

# Actualización del PATH para incluir las rutas de las herramientas
export PATH=$PATH:$HADOOP_HOME/bin:$HADOOP_HOME/sbin:$HBASE_HOME/bin:$ZOOKEEPER_HOME/bin
