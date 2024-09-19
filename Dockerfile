# Baixa uma m�quina capaz de compilar um projeto Maven
FROM maven:3.8.1-jdk-11-openj9 AS builder

# Copia os arquivos do projeto do para a m�quina virtual
COPY . /usr/src/app
WORKDIR /usr/src/app

# Compila seu sistema na m�quina virtual, criando o arquivo war
RUN mvn clean install package

# Baixa o servidor Apache com a m�quina virtual Java (Tomcat)
FROM tomcat:9.0.74-jdk11

# Copia o arquivo war gerado pelo Maven para a pasta do servidor Tomcat
COPY --from=builder /usr/src/app/target/ROOT.war /usr/local/tomcat/webapps/

# Exp�e a porta 8080 no Docker
# Mas a porta de acesso do sistema ao Docker est� no docker-composer.yml (8089)
EXPOSE 8080

# Inicia o Tomcat
CMD ["catalina.sh", "run"]