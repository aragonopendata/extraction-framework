#variables
fecha=`date +%Y%m%d`
nombreGrafo=Aragopedia
dirBase=../dumps/eswiki/$fecha

query=`cat SPARQL/constructRefArea.sparql`
encoded_value=$(python -c "import urllib; print urllib.quote('''$query''')")
curl "http://opendata.aragon.es/sparql?graph-uri=http://opendata.aragon.es/graph/$nombreGrafo/latest&query=$encoded_value" -o $dirBase/refArea.ttl

query=`cat SPARQL/constructComarca.sparql`
encoded_value=$(python -c "import urllib; print urllib.quote('''$query''')")
curl "http://opendata.aragon.es/sparql?graph-uri=http://opendata.aragon.es/graph/$nombreGrafo/latest&query=$encoded_value" -o $dirBase/comarcas.ttl

query=`cat SPARQL/constructComunidadTieneMunicipio.sparql`
encoded_value=$(python -c "import urllib; print urllib.quote('''$query''')")
curl "http://opendata.aragon.es/sparql?graph-uri=http://opendata.aragon.es/graph/$nombreGrafo/latest&query=$encoded_value" -o $dirBase/comunidadContieneMunicipio.ttl

query=`cat SPARQL/constructDataCube.sparql`
encoded_value=$(python -c "import urllib; print urllib.quote('''$query''')")
curl "http://opendata.aragon.es/sparql?graph-uri=http://opendata.aragon.es/graph/$nombreGrafo/latest&query=$encoded_value" -o $dirBase/dataCube.ttl
