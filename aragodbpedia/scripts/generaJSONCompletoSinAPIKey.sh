mkdir ./dumpsJSON
mkdir ./dumpsJSON/municipios
echo Comenzamos con los municipios

for muni in `cat listaMunicipios.txt`
do
  muniName=`echo $muni | sed s/http:\\\/\\\/opendata.aragon.es\\\/recurso\\\/territorio\\\/Municipio\\\///`
  echo $muniName
  curl -H "ACCEPT:application/json" $muni.json?_view=completa > dumpsJSON/municipios/$muniName.json
  sleep 1
done

mkdir ./dumpsJSON/comarcas
echo Continuamos con las comarcas
for comarca in `cat listaComarcas.txt`
do
comarcaName=`echo $comarca | sed s/http:\\\/\\\/opendata.aragon.es\\\/recurso\\\/territorio\\\/Comarca\\\///`
comarcaName2=`echo $comarcaName | sed s/\\\//-/`
echo $comarcaName
curl -H "ACCEPT:application/json" $comarca.json?_view=completa > dumpsJSON/comarcas/$comarcaName2.json
sleep 1
done

mkdir ./dumpsJSON/provincias
echo Continuamos con las provincias
for prov in `cat listaProvincias.txt`
do
provName=`echo $prov | sed s/http:\\\/\\\/opendata.aragon.es\\\/recurso\\\/territorio\\\/Provincia\\\///`
echo $provName
curl -H "ACCEPT:application/json" $prov.json?_view=completa > dumpsJSON/provincias/$provName.json
sleep 1
done

mkdir ./dumpsJSON/comunidades
echo Continuamos con las comunidades
for com in `cat listaComunidades.txt`
do
comName=`echo $com | sed s/http:\\\/\\\/opendata.aragon.es\\\/recurso\\\/territorio\\\/ComunidadAutonoma\\\///`
echo $comName
curl -H "ACCEPT:application/json" $com.json?_view=completa > dumpsJSON/comunidades/$comName.json
sleep 1
done