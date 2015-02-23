dirBackup=~/virtuosoBackup
fecha=`date +%Y%m%d`

mkdir $dirBackup
mkdir $dirBackup/$fecha

cd  /var/lib/virtuoso-opensource-6.1/db
zip -r db.zip .
mv db.zip $dirBackup/$fecha
