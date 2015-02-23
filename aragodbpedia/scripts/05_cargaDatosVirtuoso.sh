#variables
fecha=`date +%Y%m%d`
nombreGrafo=Aragopedia
usuarioV=dba
passV=Aragopedia
dirBase=/home/dportoles
directorioCarga=$dirBase/virtuoso_BulkLoad/$fecha/

#creo el directorio de carga
mkdir $dirBase/virtuoso_BulkLoad/$fecha
echo directorio creado
#copio los ficheros al directorio de carga
gunzip $dirBase/dumps/eswiki/$fecha/*.ttl.gz
cp $dirBase/dumps/eswiki/$fecha/*.ttl $directorioCarga
echo copia efectuada
#añado a todos los ficheros del direcotio la fecha para garantizar su carga
mmv "$directorioCarga/*.ttl" "$directorioCarga/`date +%Y%m%d%H%M%S`#1.ttl"
echo renombrado hecho
#renombro el grafo, con tres comandos(separados por ;)
#1-disables logging and enables row-by-row autocommit
#2-renombro grafo
#3-enables row-by-row autocommit and enables logging
echo iniciamos renombrado de grafo
isql-vt localhost:1111 $usuarioV $passV exec="log_enable(2);UPDATE DB.DBA.RDF_QUAD TABLE OPTION (index RDF_QUAD_GS) SET g = iri_to_id ('http://opendata.aragon.es/graph/$nombreGrafo/`date +%Y%m%d`') WHERE g = iri_to_id ('http://opendata.aragon.es/graph/$nombreGrafo/latest', 0);log_enable(3);"
echo grafo renombrado
#cargamos los datos en un nuevo grafo
echo iniciamos carga datos
isql-vt localhost:1111 $usuarioV $passV exec="ld_dir_all('$directorioCarga','*.ttl','http://opendata.aragon.es/graph/$nombreGrafo/latest')"
isql-vt localhost:1111 $usuarioV $passV exec="rdf_loader_run();"
echo fin carga
#isql-vt localhost:1111 $usuarioV $passV exec="select * from DB.DBA.load_list;"

query=`cat constructRefArea.sparql`
encoded_value=$(python -c "import urllib; print urllib.quote('''$query''')")
curl "http://localhost/sparql?graph-uri=http://opendata.aragon.es/graph/$nombreGrafo/latest&query=$encoded_value" -o $directorioCarga/refArea.ttl
echo iniciamos segunda carga datos
isql-vt localhost:1111 $usuarioV $passV exec="ld_dir_all('$directorioCarga','*.ttl','http://opendata.aragon.es/graph/$nombreGrafo/latest')"
isql-vt localhost:1111 $usuarioV $passV exec="rdf_loader_run();"
echo fin segunda carga datos
