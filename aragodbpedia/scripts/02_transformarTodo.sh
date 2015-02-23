fecha=`date +%Y%m%d`

cd ../..
extractionframework=`pwd`
aragodbpedia=$extractionframework/aragodbpedia
scripts=$aragodbpedia/scripts

sed -i .original -f $scripts/comandosSedWiki.txt $aragodbpedia/dumps/eswiki/$fecha/eswiki-$fecha-pages-articles.xml
#rm $dirBase/OpenDataAragon/src/datasets/dumps/eswiki/$fecha/eswiki-$fecha-pages-articles.xml.original

cd $extractionframework
./run extraction $aragodbpedia/configurationFiles/extraction/extraction.opendataaragon.properties

gunzip $aragodbpedia/dumps/eswiki/$fecha/*.ttl.gz

for f in `ls $aragodbpedia/dumps/eswiki/$fecha/*.ttl`
do
 sed -i .original -f $scripts/comandosSed.txt $f
done
rm $aragodbpedia/dumps/eswiki/$fecha/*.ttl.original

cp $scripts/OpenDataAragon-SameAs.ttl $aragodbpedia/dumps/eswiki/$fecha/

cd $scripts
echo "ahora hay que crear varios ttls donde se materializan algunas propiedades, cargando los ttls que hay en $aragodbpedia/dumps/eswiki/$fecha/ y ejecutando el script generaCONSTRUCT.sh"


