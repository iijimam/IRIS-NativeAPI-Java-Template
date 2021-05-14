@echo off
call host-java-params.bat

java -cp .;%CD%\jar\intersystems-jdbc-3.2.0.jar;NativeAPI\Start.class NativeAPI.Start

echo -----------------------
echo  ** completed !! **
echo -----------------------