@echo off
bitsadmin /transfer myDownloadJob /download /priority normal https://github.com/intersystems-community/iris-driver-distribution/raw/main/JDK18/intersystems-jdbc-3.2.0.jar %CD%/jar/intersystems-jdbc-3.2.0.jar

echo ---------------------------------------------------
echo ** NativeAPI.Start.java compile **
javac -encoding utf-8 -cp .:%CD%/jar/intersystems-jdbc-3.2.0.jar NativeAPI/Start.java


set iriscontainerchk1=""
set iriscontainerchk2=""
for /f "usebackq" %%t in (`docker container ls -q -f name^=%IRIS_CONTAINER%`) do set iriscontainerchk1=%%t
for /f "usebackq" %%t in (`docker container ls -q -a -f name^=%IRIS_CONTAINER%`) do set iriscontainerchk2=%%t

if %iriscontainerchk1%=="" if not %iriscontainerchk2%=="" (
    echo ***** Running IRIS container *****
    docker-compose -f ../docker-compose.yml start iris    
)

if %iriscontainerchk1%=="" if %iriscontainerchk2%=="" (
    echo ***** Running IRIS container *****
    docker-compose -f ../docker-compose.yml up -d iris 
)
docker-compose -f ../docker-compose.yml ps 


echo ---------------------------------------------------
echo ** [Example]
echo     runhost.bat" 
echo **
echo **
echo ** you need to update host name before running.
echo    1. open host-java-params.bat
echo    2. edit host name or ip address and save.
echo    3. running runhost.bat (please refer [Example])
echo ----------------------------------------------------
