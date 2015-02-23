clear
echo "Lanzado en  $(date)"
echo Paro Tomcat 7
/etc/init.d/tomcat7 stop
echo Borro Cache
sudo rm -r /var/cache/tomcat7/Catalina/localhost/
echo Borro Logs
sudo rm /var/log/tomcat7/*
sudo chmod 777 -R /var/log/tomcat7
echo arranco tomcat
/etc/init.d/tomcat7 start

