#!/bin/bash

rm -rf jar
# IRIS jarの取得 ./jarに格納
# iris jdbc
wget -P jar https://github.com/intersystems-community/iris-driver-distribution/raw/main/JDK18/intersystems-jdbc-3.2.0.jar


# コンパイル
echo "-----------------------------------"
echo "　　コンパイルします"
javac -cp .:${PWD}/jar/intersystems-jdbc-3.2.0.jar NativeAPI/Start.java

# IRIS用コンテナが起動中かどうかの確認
if [ "$(docker container ls -q -f name="$IRIS_CONTAINER")" ]; then
    echo "-----------------------------------"
    echo "　　IRISコンテナ開始中です"
    echo "-----------------------------------"
# IRISコンテナ停止中かどうか
elif [ !"$(docker container ls -q -f name="$IRIS_CONTAINER")" -a "$(docker container ls -q -a -f name="$IRIS_CONTAINER")" ]; then
    echo "-----------------------------------"
    echo "　　IRISコンテナ開始します"
    echo "-----------------------------------"
    docker-compose -f ../docker-compose.yml start iris
# コンテナがない場合ビルド実行
else
    echo "-----------------------------------"
    echo "　　IRISコンテナを作成して開始します"
    echo "-----------------------------------"
    docker-compose -f ../docker-compose.yml up -d iris
fi

docker-compose -f ../docker-compose.yml ps 

# Java実行例
echo -e "----------------------------------------------------------------------------\n"
echo -e "[Java実行例]\n"
echo -e "   ./runhost.sh" 
echo " *** 実行前に接続先IRISのホスト名（またはIPアドレス）をご確認ください。 *** "
echo "    接続先情報は、./host-java-params.sh に記載しています。適宜ご変更ください"
echo -e "    java 実行前に　source ./host-java-params.sh　を実行してください\n"
echo "----------------------------------------------------------------------------"
