#!/bin/bash

# Configuración de la conexión SSH
SSH_USER=hadoop
SSH_MASTER=master
SSH_WORKER=worker
SSH_EDGE=edge

# Rutas de los archivos de configuración de Hadoop, HBase y Zookeeper que se encuentran en la carpetalocal e configs

HADOOP_CONF=$(pwd)/configs/hadoop
HBASE_CONF=$(pwd)/configs/hbase
ZK_CONF=$(pwd)/configs/zookeeper

# Copiar archivos de configuración a master
scp -r $HADOOP_CONF $SSH_USER@$SSH_MASTER:/opt/hadoop/etc/
scp -r $HBASE_CONF $SSH_USER@$SSH_MASTER:/opt/
scp -r $ZK_CONF $SSH_USER@$SSH_MASTER:/opt/

# Copiar archivos de configuración a worker
scp -r $HADOOP_CONF $SSH_USER@$SSH_WORKER:/opt/hadoop/etc/
scp -r $HBASE_CONF $SSH_USER@$SSH_WORKER:/opt/
scp -r $ZK_CONF $SSH_USER@$SSH_WORKER:/opt/

# Copiar archivos de configuración a edge
scp -r $HADOOP_CONF $SSH_USER@$SSH_EDGE:/opt/hadoop/etc/
scp -r $HBASE_CONF $SSH_USER@$SSH_EDGE:/opt/
scp -r $ZK_CONF $SSH_USER@$SSH_EDGE:/opt/



