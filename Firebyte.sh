start_docker(){
  sudo systemctl start docker || exit_with_error "Falha ao iniciar o Docker."
  sudo systemctl enable docker || exit_with_error "Falha ao habilitar o Docker."
}

# Builda e inicia o container do DB
build_and_run_db_container(){
  if [ ! "$(docker ps -a -q -f name=firebytedb)" ];
    then
      cd DB || exit_with_error "Diretório não encontrado: DB."
      docker build -t firebytedb . || exit_with_error "Falha ao construir a imagem Docker para o banco de dados."
      docker run -d --name firebytedb -p 3306:3306 firebytedb || exit_with_error "Falha ao iniciar o contêiner MySQL."
      cd .. || exit_with_error "Falha ao voltar para o diretório FireByte."
    else
      printf "${GREEN}Container DB já está rodando!${NC} \n"
  fi
}

# Builda e inicia o container do Java (caso já esteja rodando, remove e inicia novamente)
build_and_run_java_container(){
  if [ ! "$(docker ps -a -q -f name=firebytejava)" ];
    then
      docker rm firebytejava || exit_with_error "Falha ao remover o contêiner Java."
  fi
  cd Java || exit_with_error "Diretório não encontrado: java."
  docker build -t firebytejava . || exit_with_error "Falha ao construir a imagem Docker para o aplicativo Java."
  docker run -i --name firebytejava -p 8080:8080 firebytejava || exit_with_error "Falha ao iniciar o contêiner Java."
  cd .. || exit_with_error "Falha ao voltar para o diretório FireByte."
  printf "${GREEN}Firebyte foi configurado com sucesso!${NC} \n"
}


## Execução do script ##

printf "${PURPLE}Iniciando o docker...${NC} \n"
start_docker
printf "${GREEN}Docker iniciado com sucesso!${NC} \n"

printf "${PURPLE}Iniciando container do Banco Local...${NC} \n"
build_and_run_db_container
printf "${GREEN}Container do Banco Local iniciado com sucesso!${NC} \n"

printf "${PURPLE}Iniciando container Java...${NC} \n"
build_and_run_java_container

printf "${PURPLE}Para executar nosso programa novamente, você pode rodar o script ${GREEN}'Firebyte.sh'${NC} \n"