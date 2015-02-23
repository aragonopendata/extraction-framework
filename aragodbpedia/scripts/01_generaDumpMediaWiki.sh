fecha=`date +%Y%m%d`
mkdir ~/dumps
mkdir ~/dumps/eswiki
mkdir ~/dumps/eswiki/$fecha
cd /etc/apache2/htdocs/mediawiki-1.22.0/maintenance
php dumpBackup.php --current > ~/dumps/eswiki/$fecha/eswiki-$fecha-pages-articles.xml
