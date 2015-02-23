#variables
#fecha=`date +%Y%m%d`
#dirBase=/Users/ocorcho1/Trabajo/LocaliData/OpenDataAragon/src/datasets
#dirBase=/home/dportoles
dirBase=.

mkdir $dirBase/resultadosSameAs
#modifico URLs
for item in `cat listaTodos.txt`
do
  nombre=`echo $item | sed "s/http:\/\/es.dbpedia.org\/resource\///"`
  if [ ! -f $dirBase/resultadosSameAs/$nombre.txt ]; then
    echo $item
    curl -I -L $item > $dirBase/resultadosSameAs/$nombre.txt
  fi
done

grep "HTTP/1.1 404 Not found" $dirBase/resultadosSameAs/* > LinksMalos.txt


