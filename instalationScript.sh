#!/bin/bash
PURPLE='\033[0;35m'
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

## Funções ##

# Exibir mensagem de erro e sair
exit_with_error() {
    printf "${RED}Erro: $1${NC}\n"
    exit 1
}

# Verifica se o script é executado como root
check_root(){
  if [ "$EUID" -ne 0 ]; then
      exit_with_error "Por favor, execute este script como root. (sudo ./instalationScript.sh)"
  fi
}

# Atualiza o sistema
update_system(){
  apt-get update || exit_with_error "Falha ao atualizar o sistema."
}

# Criação de diretórios
make_directories(){
  mkdir -p FireByte FireByte/instalation FireByte/instalation/init-scripts || exit_with_error "Falha ao criar diretórios."
}

# Download dos scripts
download_scripts(){
  # Download do script executável para a execução do aplicativo
  cd FireByte || exit_with_error "Diretório não encontrado: FireByte."
  wget "https://raw.githubusercontent.com/NetMinder-Enterprise/FireByte-Infra/main/Firebyte.sh" || exit_with_error "Falha ao baixar o script executável."
  chmod +x Firebyte.sh || exit_with_error "Falha ao tornar o script executável."

  # Download do Dockerfile do container de banco
  cd instalation || exit_with_error "Diretório não encontrado: FireByte/instalation."
  wget "https://raw.githubusercontent.com/NetMinder-Enterprise/FireByte-Infra/main/Dockerfile" || exit_with_error "Falha ao baixar Dockerfile.";

  # Download dos scripts SQL
  cd init-scripts || exit_with_error "Diretório não encontrado: FireByte/instalation/init-scripts."
  wget "https://raw.githubusercontent.com/NetMinder-Enterprise/FireByte-Infra/main/sql/init.sql" || exit_with_error "Falha ao baixar script inicial sql."

  # Download do .jar
  cd .. || exit_with_error "Diretório não encontrado: FireByte/instalation."
  wget "https://github.com/NetMinder-Enterprise/FireByte-Backend/raw/main/firebyte.jar" || exit_with_error "Falha ao baixar o Sistema Java."
}

# Checa se o docker está instalado (se não, instala)
check_docker(){
  if ! command -v docker &> /dev/null; 
    then
      printf "${PURPLE}Instalando o docker...${NC} \n"
      sudo apt-get install docker.io -y || exit_with_error "Falha ao instalar o Docker."
      printf "${GREEN}Docker instalado com sucesso!${NC} \n"
    else
      printf "${GREEN}Docker já instalado!${NC} \n"
  fi
}

# Iniciar o docker
start_docker(){
  sudo systemctl start docker || exit_with_error "Falha ao iniciar o Docker."
  sudo systemctl enable docker || exit_with_error "Falha ao habilitar o Docker."
}

# Builda e inicia os containers
build_and_run_database_container(){
  sudo docker build -t firebytedb .
  sudo docker run -d -p 3306:3306 firebytedb
}

# Checa se o java está instalado (se não, instala)
check_java_instalation(){
  if ! command -v java &> /dev/null; 
    then
      printf "${PURPLE}Instalando o Java...${NC} \n"
      sudo apt install openjdk-17-jdk -y || exit_with_error "Falha ao instalar o Java."
      printf "${GREEN}Java instalado com sucesso!${NC} \n"
    else
      printf "${GREEN}Java já instalado!${NC} \n"
  fi
}

# Roda o .jar com o java
run_java(){
  sudo java -jar firebyte.jar || exit_with_error "Falha ao iniciar o sistema Java."
}

## Execução do script ##

printf "${PURPLE}Atualizando Sistema...${NC} \n"
update_system
printf "${GREEN}Sistema atualizado com sucesso!${NC} \n"

printf "${PURPLE}Criando diretórios...${NC} \n"
make_directories
printf "${GREEN}Diretórios criados com sucesso!${NC} \n"

printf "${PURPLE}Baixando arquivos necessários...${NC} \n"
download_scripts
printf "${GREEN}Arquivos baixados com sucesso!${NC} \n"

printf "${PURPLE}Verificando se o docker está instalado...${NC} \n"
check_docker

printf "${PURPLE}Iniciando o docker...${NC} \n"
start_docker
printf "${GREEN}Docker iniciado com sucesso!${NC} \n"

printf "${PURPLE}Iniciando container do banco...${NC} \n"
build_and_run_database_container
printf "${GREEN}Container iniciado com sucesso!${NC} \n"

printf "${PURPLE}Verificando se o java está instalado...${NC} \n"
check_java_instalation

printf "${PURPLE}Iniciando o sistema Java...${NC} \n"
printf "${PURPLE}Para executar nosso programa novamente, você pode rodar o script ${GREEN}'Firebyte.sh'${NC} \n"
run_java