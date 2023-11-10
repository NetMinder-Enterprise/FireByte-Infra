#!/bin/bash

PURPLE='\033[0;35m'
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

# Função para exibir mensagens de erro e sair
exit_with_error() {
    printf "${RED}Erro: $1${NC}\n"
    exit 1
}

# Verifica se o script é executado como root
if [ "$EUID" -ne 0 ]; then
    exit_with_error "Por favor, execute este script como root. (sudo ./instalationScript.sh)"
fi

# Atualiza o sistema
printf "${PURPLE}Atualizando Sistema...${NC} \n"
apt-get update || exit_with_error "Falha ao atualizar o sistema."
printf "${GREEN}Sistema atualizado com sucesso!${NC} \n"

# Criação de diretórios
mkdir -p FireByte/DB FireByte/Java || exit_with_error "Falha ao criar diretórios."

# Download do script executável para a execução do aplicativo
wget "https://raw.githubusercontent.com/NetMinder-Enterprise/FireByte-Infra/main/Firebyte.sh" || exit_with_error "Falha ao baixar o script executável."

# Configuração do Docker
printf "${PURPLE}Verificando se o docker está instalado...${NC} \n"
if ! command -v docker &> /dev/null; then
    printf "${PURPLE}Instalando o docker...${NC} \n"
    sudo apt-get install docker.io -y || exit_with_error "Falha ao instalar o Docker."
    printf "${GREEN}Docker instalado com sucesso!${NC} \n"
fi

printf "${PURPLE}Iniciando o docker...${NC} \n"
sudo systemctl start docker || exit_with_error "Falha ao iniciar o Docker."
sudo systemctl enable docker || exit_with_error "Falha ao habilitar o Docker."
printf "${GREEN}Docker iniciado!${NC} \n"

# MySQL Container
printf "${PURPLE}Configurando Banco Local...${NC} \n"
cd FireByte/DB || exit_with_error "Diretório não encontrado: FireByte/DB."
mkdir -p sql || exit_with_error "Falha ao criar diretório sql."
cd sql || exit_with_error "Falha ao acessar o diretório sql."

# Download dos arquivos SQL
wget "https://raw.githubusercontent.com/NetMinder-Enterprise/FireByte-Infra/main/DB/createUser.sql" || exit_with_error "Falha ao baixar createUser.sql."
wget "https://raw.githubusercontent.com/NetMinder-Enterprise/FireByte-Infra/main/DB/Script%20DB.sql" || exit_with_error "Falha ao baixar Script DB.sql."
cd .. || exit_with_error "Falha ao voltar para o diretório DB."

# Download do Dockerfile
wget "https://raw.githubusercontent.com/NetMinder-Enterprise/FireByte-Infra/main/DB/Dockerfile" || exit_with_error "Falha ao baixar Dockerfile."
docker build -t firebytedb . || exit_with_error "Falha ao construir a imagem Docker para o banco de dados."
docker run -d --name localDB -p 3306:3306 firebytedb || exit_with_error "Falha ao iniciar o contêiner MySQL."
cd .. || exit_with_error "Falha ao voltar para o diretório FireByte."
printf "${GREEN}Banco Local configurado com sucesso!${NC} \n"

# Java .jar
cd Java || exit_with_error "Diretório não encontrado: Java."
printf "${PURPLE}Baixando Sistema Java...${NC} \n"
wget "https://github.com/NetMinder-Enterprise/FireByte-Backend/raw/main/firebyte.jar" || exit_with_error "Falha ao baixar o Sistema Java."
printf "${GREEN}Sistema Java Baixado com sucesso!${NC} \n"

# Java Container
printf "${PURPLE}Configurando Sistema Java...${NC} \n"
wget "https://raw.githubusercontent.com/NetMinder-Enterprise/FireByte-Infra/main/Java/Dockerfile" || exit_with_error "Falha ao baixar Dockerfile."
docker build -t firebytejava . || exit_with_error "Falha ao construir a imagem Docker para o aplicativo Java."
docker run -p 8080:8080 firebytejava || exit_with_error "Falha ao iniciar o contêiner Java."
printf "${GREEN}Firebyte foi configurado com sucesso!${NC} \n"
printf "${PURPLE}Para executar nosso programa novamente, você pode rodar o script 'Firebyte.sh'${NC} \n"