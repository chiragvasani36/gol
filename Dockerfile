FROM tomcat:8.0

RUN echo 'Deploying War on Server'

COPY /gameoflife-web/target/gameoflife.war /var/lib/tomcat8/webapps
