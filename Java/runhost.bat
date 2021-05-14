@echo off
call host-java-params.bat

java -cp .:%CD%/jar/intersystems-jdbc-3.2.0.jar:NativeAPI/Start.class NativeAPI.Start

echo -----------------------------------------------------------------
echo  [Prepating for StreetView.html] running enrich routine on IRIS
echo -----------------------------------------------------------------

docker-compose exec -f ../docker-compose.yml iris iris session iris enrich

echo -----------------------
echo  ** completed !! **
echo -----------------------