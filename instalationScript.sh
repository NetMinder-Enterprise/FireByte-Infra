#!/bin/bash

#Update System
echo "\033[0;34mAtualizando Sistema..."
sudo apt update -y
sudo apt upgrade -y
echo "\033[0;34mSistema atualizado com sucesso!"

#Create Directories
mkdir FireByte
cd Firebyte
mkdir DB
mkdir Java

#Create executable for running the app
wget "https://raw.githubusercontent.com/NetMinder-Enterprise/FireByte-Infra/main/Firebyte.sh"

#Setup Docker
echo "\033[0;34mVerificando se o docker está instalado..."
docker --version
if [ $? = 0 ];
  then
    echo "\033[0;34mInstalando o docker..."
    sudo apt install docker.io
    echo "\033[0;34mDocker instalado com sucesso!"
fi
echo "\033[0;34mIniciando o docker..."
sudo systemctl start docker
sudo systemctl enable docker
echo "\033[0;34mDocker iniciado!"

#MySQL Container
echo "\033[0;34mConfigurando Banco Local..."
cd DB
mkdir sql
cd sql
wget "https://raw.githubusercontent.com/NetMinder-Enterprise/FireByte-Infra/main/DB/createUser.sql"
wget "https://raw.githubusercontent.com/NetMinder-Enterprise/FireByte-Infra/main/DB/Script%20DB.sql"
cd ..
wget "https://raw.githubusercontent.com/NetMinder-Enterprise/FireByte-Infra/main/DB/Dockerfile"
docker build -t firebytedb .
docker run -d --name localDB -p 3306:3306 firebytedb
cd ..
echo "\033[0;34mBanco Local configurado com sucesso!"

#Java .jar
cd Java
echo "\033[0;34mBaixando Sistema Java..."
#wget .jar

#Java Container
echo "\033[0;34mConfigurando Sistema Java..."
wget "https://raw.githubusercontent.com/NetMinder-Enterprise/FireByte-Infra/main/Java/Dockerfile"
docker build -t firebyteJava .
docker run -p 8080:8080 firebyteJava
echo "\033[0;34mFirebyte foi configurado com sucesso!"
echo "\033[0;34mPara executar nosso programa novamente você pode rodar o script 'Firebyte.sh'"