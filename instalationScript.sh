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
#wget Firebyte.sh

#MySQL Container
echo "\033[0;34mConfigurando Banco Local..."
cd DB
mkdir sql
cd sql
wget "https://raw.githubusercontent.com/NetMinder-Enterprise/FireByte-Backend/main/src/main/java/entities/createUser.sql"
wget "https://raw.githubusercontent.com/NetMinder-Enterprise/FireByte-Backend/main/src/main/java/entities/Script%20DB.sql"
cd ..
#wget Dockerfile DB
docker build -t firebytedb .
docker run -d --name localDB -p 3306:3306 firebytedb
cd ..
echo "\033[0;34mBanco Local configurado com sucesso!"

#Java Container
cd Java
echo "\033[0;34mConfigurando Sistema Java..."
#wget .jar
echo "\033[0;34mDigite seu usuário para acessar o serviço Firebyte:"
read usuario
echo "\033[0;34mDigite sua senha:"
read senha
#wget Dockerfile Java
docker build -t firebyteJava .
docker run -p 8080:8080 firebyteJava
echo "\033[0;34mFirebyte foi configurado com sucesso!"
echo "\033[0;34mPara executar nosso programa novamente você pode rodar o script 'Firebyte.sh'"