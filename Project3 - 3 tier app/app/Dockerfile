FROM maven:3.8.4-openjdk-11 AS maven
WORKDIR /tmp
COPY application.properties /tmp/application.properties

RUN      
    cd Project-3/app/sourcecodeseniorwr && \
    cp /tmp/application.properties /tmp/Project-3/app/sourcecodeseniorwr/src/main/resources/application.properties && \
    mvn clean install

FROM tomcat:9.0.75-jdk11 AS tomcat
RUN rm -fr /usr/local/tomcat/webapps/* 
COPY --from=maven /tmp/Project-3/app/sourcecodeseniorwr/target/vprofile-v2.war /usr/local/tomcat/webapps/ROOT.war

EXPOSE 8080
CMD ["catalina.sh", "run"]
