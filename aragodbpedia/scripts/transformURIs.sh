#variables
fecha=`date +%Y%m%d`
dirBase=/Users/ocorcho1/Trabajo/LocaliData/OpenDataAragon/src/datasets
#dirBase=/home/dportoles

#descomprimo los ficheros
gunzip $dirBase/dumps/eswiki/$fecha/*.ttl.gz

#modifico URLs
for f in `ls $dirBase/dumps/eswiki/$fecha/*.ttl`
do
  sed -i .original -f comandosSed.txt $f
done
