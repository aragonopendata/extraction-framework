# Sistema de extracción de información de AragoDBPedia

## Documentación

Aunque se puede utilizar la documentación general del sistema de extracción de información de DBpedia, tal y como se describe en el [DBpedia Github wiki](https://github.com/dbpedia/extraction-framework/wiki), aquí se incluyen instrucciones más detalladas del proceso completo que tiene que ejecutarse para realizar una extracción completa de la wiki de Aragopedia.

### Preliminares. Configuración inicial
Asumiremos que hemos definido en nuestro entorno las siguientes variables:

    export extractionframework=/Users/XXXXXX/OpenDataAragon/ExtractionFramework
    export aragodbpedia=$extractionframework/aragodbpedia
    export maven=/Library/apache-maven-3.2.5/bin/
    export JAVA_HOME=/Library/Java/JavaVirtualMachines/jdk1.8.0_31.jdk/Contents/Home/
    export PATH=$PATH:$maven

### Obtención del wiki dump de Aragopedia

El wiki dump de Aragopedia es el primer paso que se necesita para realizar el proceso de extracción. Estos dumps se generan de manera periódica en http://opendata.aragon.es/aragopedia/dumps/, aunque en caso de que se tenga acceso a la máquina en producción que tiene corriendo MediaWiki, se pueden utilizar los siguientes comandos:

    fecha=`date +%Y%m%d`
    mkdir $aragodbpedia/dumps/eswiki/$fecha
    cd /etc/apache2/htdocs/mediawiki-1.22.0/maintenance
    php dumpBackup.php --current > $aragodbpedia/dumps/eswiki/$fecha/eswiki-$fecha-pages-articles.xml

Asumiendo que la fecha actual sea 25/02/2015, el fichero generado se encuentra ahora en $aragodbpedia/dumps/eswiki/20150225/eswiki-20150225-pages-articles.xml

### Generación de ficheros RDF

En primer lugar, se debe modificar el fichero de configuración de extracción de datos para determinar dónde están los ficheros que se van a utilizar para hacer referencia a la ontología, mappings y lugar donde se encuentra el dump de Aragopedia. El fichero de configuración es el siguiente: $aragodbpedia/configurationFiles/extraction/extraction.opendataaragon.properties

A continuación, se ejecuta lo siguiente en el directorio $extractionframework

    $mvn clean install

Se ejecutan los siguientes comandos en el directorio $aragodbpedia/scripts/

    $cd $aragodbpedia/scripts/
    $./02_transformarTodo.sh

Se suben al triple store (en el grafo http://opendata.aragon.es/graph/Aragopedia/latest) los ficheros .ttl que se han generado en $aragodbpedia/datasets/dumps/eswiki/20150225/. Esta operación se puede realizar directamente en el Virtuoso Conductor, o utilizando el script 03_cargaDatosVirtuoso.sh. Para poder ejecutar este script, el directorio de carga (por ejemplo, /home/localidata/virtuoso_BulkLoad) debe estar incluido en la propiedad DirsAllowed del fichero virtuoso.ini del directorio de configuración de Virtuoso. La operación que se realizar en Virtuoso Conductor es:

    ld_dir_all('/home/dportoles/virtuoso_BulkLoad/20140107','*.ttl.gz','http://datos.localidata.com/graph/Aragon/latest');
    rdf_loader_run();
    select * from DB.DBA.load_list;

Si antes se desea renombrar el grafo existente hasta el momento, se puede utilizar la siguiente secuencia de comandos en Virtuoso Conductor:

    log_enable(3)
    UPDATE DB.DBA.RDF_QUAD TABLE OPTION (index RDF_QUAD_GS) 
      SET g = iri_to_id ('new') 
      WHERE g = iri_to_id ('old', 0);  
    log_enable(1)

Se ejecuta el script que generará los siguientes ficheros: refArea.ttl, comarcas.ttl, comunidadContieneMunicipio.ttl, dataCube.ttl

    $./04_generaCONSTRUCT.sh
    
Subir al triple store (en el grafo http://opendata.aragon.es/graph/Aragopedia/latest) los nuevos ficheros .ttl que se han generado en $aragodbpedia/datasets/dumps/eswiki/20150225/. De nuevo, esta operación se puede realizar directamente en el Virutoso Conductor, o utilizando el script 05_cargaDatosVirtuoso.sh

### Añadir una nueva propiedad 

Este paso se debe ejecutar en el momento en que interesa añadir una nueva propiedad para tratar los mapeos.

El fichero con el que trabajaremos es el siguiente: $aragodbpedia/configurationFiles/Mapping_es.xml. Este fichero contiene los mappings que se utilizan para realizar las transformaciones.

Este fichero se modifica de acuerdo con las propiedades que se pueden encontrar en las distintas fichas que se utilizan para proporcionar información.

### Configuración de Apache y Elda

La configuración de Elda se realiza utilizando los ficheros territorio.ttl y cubo.ttl. Estos ficheros se deben copiar en el lugar donde se encuentra instalado Elda sobre Tomcat (por ejemplo, /var/lib/tomcat7/webapps/standalone/specs/). Asimismo, hay que subir la configuración del servidor Web, que se encuentra en el fichero web.xml, al directorio WEB-INF correspondiente (por ejemplo, /var/lib/tomcat7/webapps/standalone/WEB-INF/)

El script correspondiente se encuentra en el directorio de scripts.

### Generación de nuevas propiedades en la ontología

Se debe modificar el fichero Aragopedia.owl (por ejemplo, utilizando la herramienta Protégé), y subir Aragopedia.owl, Aragopedia.ttl y Aragopedia.html al lugar donde está el directorio /def/ (por ejemplo, var/lib/tomcat7/webapps/def)


## License

The source code is under the terms of the [GNU General Public License, version 2](http://www.gnu.org/licenses/gpl-2.0.html).

