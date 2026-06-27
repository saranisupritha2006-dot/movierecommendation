FROM tomcat:9.0-jdk11

RUN rm -rf /usr/local/tomcat/webapps/ROOT

COPY src/ /usr/local/tomcat/webapps/ROOT/

ADD https://repo1.maven.org/maven2/com/mysql/mysql-connector-j/8.0.33/mysql-connector-j-8.0.33.jar /usr/local/tomcat/lib/

EXPOSE 8080

CMD ["catalina.sh", "run"]