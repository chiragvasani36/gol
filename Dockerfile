FROM tomcat:8.0

RUN echo 'Deploying War on Server'

COPY /gameoflife-web/target/gameoflife.war /usr/local/tomcat/webapps
