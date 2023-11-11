#!/bin/bash
RED='\033[0;31m'
NC='\033[0m'

# Exibir mensagem de erro e sair
exit_with_error() {
    printf "${RED}Erro: $1${NC}\n"
    exit 1
}

# Roda o .jar com o java
run_java(){
  sudo java -jar firebyte.jar || exit_with_error "Falha ao iniciar o sistema Java."
}


## Execução do script ##
printf "${PURPLE}Iniciando o sistema Java...${NC} \n"
run_java