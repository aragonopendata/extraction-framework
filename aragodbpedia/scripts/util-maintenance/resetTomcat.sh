echo "Lanzado en  $(date)"
echo Paro Tomcat 7
/etc/init.d/tomcat7 stop
echo Arranco Tomcat 7
/etc/init.d/tomcat7 start
