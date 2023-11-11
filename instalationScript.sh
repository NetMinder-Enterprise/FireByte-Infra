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
  mkdir -p FireByte/DB FireByte/DB/sql FireByte/Java || exit_with_error "Falha ao criar diretórios."
}

# Download dos scripts
download_scripts(){
  # Download do script executável para a execução do aplicativo
  cd FireByte || exit_with_error "Diretório não encontrado: FireByte."
  wget "https://raw.githubusercontent.com/NetMinder-Enterprise/FireByte-Infra/main/Firebyte.sh" || exit_with_error "Falha ao baixar o script executável."
  chmod +x Firebyte.sh || exit_with_error "Falha ao tornar o script executável."

  # Download dos scripts SQL
  cd DB || exit_with_error "Diretório não encontrado: FireByte/DB."
  wget "https://raw.githubusercontent.com/NetMinder-Enterprise/FireByte-Infra/main/DB/Dockerfile" || exit_with_error "Falha ao baixar Dockerfile."
  cd sql || exit_with_error "Diretório não encontrado: FireByte/DB/sql."
  wget "https://raw.githubusercontent.com/NetMinder-Enterprise/FireByte-Infra/main/DB/createUser.sql" || exit_with_error "Falha ao baixar createUser.sql."
  wget "https://raw.githubusercontent.com/NetMinder-Enterprise/FireByte-Infra/main/DB/Script%20DB.sql" || exit_with_error "Falha ao baixar Script DB.sql."

  # Download do .jar
  cd ../../Java || exit_with_error "Diretório não encontrado: Java."
  wget "https://github.com/NetMinder-Enterprise/FireByte-Backend/raw/main/firebyte.jar" || exit_with_error "Falha ao baixar o Sistema Java."
  wget "https://raw.githubusercontent.com/NetMinder-Enterprise/FireByte-Infra/main/Java/Dockerfile" || exit_with_error "Falha ao baixar Dockerfile."

  #voltar a pasta raiz
  cd .. || exit_with_error "Falha ao voltar para a pasta raiz."
}

# Checa se o docker está instalado
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

# Builda e inicia o container do DB
build_and_run_db_container(){
  if [ ! "$(docker ps -a -q -f name=<name>)" ];
    then
      cd DB || exit_with_error "Diretório não encontrado: DB."
      docker build -t firebytedb . || exit_with_error "Falha ao construir a imagem Docker para o banco de dados."
      docker run -d --name firebytedb -p 3306:3306 firebytedb || exit_with_error "Falha ao iniciar o contêiner MySQL."
      cd .. || exit_with_error "Falha ao voltar para o diretório FireByte."
    else
      printf "${GREEN}Container DB já está rodando!${NC} \n"
  fi
}

# Builda e inicia o container do Java
build_and_run_java_container(){
  if [ ! "$(docker ps -a -q -f name=<name>)" ];
    then
      cd Java || exit_with_error "Diretório não encontrado: java."
      docker build -t firebytejava . || exit_with_error "Falha ao construir a imagem Docker para o aplicativo Java."
      docker run -d --name firebytejava -p 8080:8080 firebytejava || exit_with_error "Falha ao iniciar o contêiner Java."
      cd .. || exit_with_error "Falha ao voltar para o diretório FireByte."
    else
      printf "${GREEN}Container Java já está rodando!${NC} \n"
  fi
}

enter_java_app(){
  docker exec -it firebytejava bash || exit_with_error "Falha ao entrar no container Java."
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

printf "${PURPLE}Iniciando container do Banco Local...${NC} \n"
build_db_container
printf "${GREEN}Container do Banco Local iniciado com sucesso!${NC} \n"

printf "${PURPLE}Iniciando container Java...${NC} \n"
build_java_container
printf "${GREEN}Container Java iniciado com sucesso!${NC} \n"

printf "${GREEN}Firebyte foi configurado com sucesso!${NC} \n"
printf "${PURPLE}Para executar nosso programa novamente, você pode rodar o script ${GREEN}'Firebyte.sh'${NC} \n"

printf "${PURPLE}Iniciando a aplicação...'${NC} \n"
enter_java_app