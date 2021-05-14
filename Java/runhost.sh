#!/bin/bash
source ./host-java-params.sh

java -cp .:${PWD}/jar/intersystems-jdbc-3.2.0.jar:NativeAPI/Start.class NativeAPI.Start

echo "----------------------"
echo "** 処理終了しました **"
echo "----------------------"

