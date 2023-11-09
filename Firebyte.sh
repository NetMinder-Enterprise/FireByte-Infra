echo "\033[0;34mIniciando Banco de Dados Local..."
docker run -d --name localDB -p 3306:3306 firebytedb
echo "\033[0;34mIniciando Sistema Java..."
docker run -p 8080:8080 firebyteJava
echo "\033[0;34mInicialização concluída com sucesso!"