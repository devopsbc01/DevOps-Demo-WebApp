FROM ajit5144/ubuntu-tcat-x2-1
COPY ./target/*.war /usr/local/tomcat/webapps
EXPOSE 8080
EXPOSE 8081
CMD ["/etc/init.d/postgresql","start"]
CMD ["/usr/local/tomcat/bin/catalina.sh","run"]
