#!/bin/bash

PURPLE='\033[0;35m'
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'
#Check root permission
if [ "$EUID" -ne 0 ];
  then
    printf "${RED}Por favor, execute este script como root.${NC}"
    exit
fi

#Update System
printf "${PURPLE}Atualizando Sistema...${NC} \n"
apt-get update
printf "${GREEN}Sistema atualizado com sucesso!${NC} \n"

#Create Directories
mkdir FireByte
cd Firebyte
mkdir DB
mkdir Java

#Create executable for running the app
wget "https://raw.githubusercontent.com/NetMinder-Enterprise/FireByte-Infra/main/Firebyte.sh"

#Setup Docker
printf "${PURPLE}Verificando se o docker está instalado...${NC} \n"
docker --version
if [ $? = 0 ];
  then
    printf "${PURPLE}Instalando o docker...${NC} \n"
    sudo apt-get install docker.io -y
    printf "${GREEN}Docker instalado com sucesso!${NC} \n"
fi
printf "${PURPLE}Iniciando o docker...${NC} \n"
sudo systemctl start docker
sudo systemctl enable docker
printf "${GREEN}Docker iniciado!${NC} \n"

#MySQL Container
printf "${PURPLE}Configurando Banco Local...${NC} \n"
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
printf "${GREEN}Banco Local configurado com sucesso!${NC} \n"

#Java .jar
cd Java
printf "${PURPLE}Baixando Sistema Java...${NC} \n"
#wget .jar
printf "${GREEN}Sistema Java Baixado com sucesso!${NC} \n"

#Java Container
printf "${PURPLE}Configurando Sistema Java...${NC} \n"
wget "https://raw.githubusercontent.com/NetMinder-Enterprise/FireByte-Infra/main/Java/Dockerfile"
docker build -t firebyteJava .
docker run -p 8080:8080 firebyteJava
printf "${GREEN}Firebyte foi configurado com sucesso!${NC} \n"
printf "${PURPLE}Para executar nosso programa novamente você pode rodar o script 'Firebyte.sh'${NC} \n"