FROM store/intersystems/iris-community:2021.1.0.205.0 as IRIS
FROM openjdk:8-jdk-alpine

LABEL maintainer="intersystems japan developer community"

# Section 1 - Taken from https://github.com/Zenika/alpine-maven

RUN apk add --update ca-certificates && rm -rf /var/cache/apk/* && \
  find /usr/share/ca-certificates/mozilla/ -name "*.crt" -exec keytool -import -trustcacerts \
  -keystore /usr/lib/jvm/java-1.8-openjdk/jre/lib/security/cacerts -storepass changeit -noprompt \
  -file {} -alias {} \; && \
  keytool -list -keystore /usr/lib/jvm/java-1.8-openjdk/jre/lib/security/cacerts --storepass changeit

WORKDIR /irislib

# mvnローカルリポジトリにサンプルで使用するJarファイルをインストール
COPY --from=IRIS /usr/irissys/dev/java/lib/JDK18/intersystems-jdbc-3.2.0.jar /irislib/

RUN apk add --update alpine-sdk

# mavenプロジェクトを配置するディレクトリを作成
WORKDIR /usr/projects

COPY NativeAPI NativeAPI

# コンパイル
RUN javac -cp .:/irislib/intersystems-jdbc-3.2.0.jar /usr/projects/NativeAPI/Start.java

COPY ./run.sh ./run1.sh
# Windows上でコンテナをビルドする場合の対応
RUN sed -e 's/\r//g' -e "s///" run1.sh > run.sh && \
 chmod 755 ./run.sh

ENTRYPOINT ["/usr/projects/run.sh"]