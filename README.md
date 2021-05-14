# **キーバリュー形式**で Java から IRIS にアクセスできる実行環境テンプレート（**NativeAPI for Java**）

このテンプレートでは、Java の実行環境用コンテナから InterSystems IRIS のコンテナへ接続し、**レコードでもオブジェくでもない、キーバリュー形式**でのデータ更新／取得を体験できます。

テンプレートの中では、以下の人物相関図のイメージを IRIS に登録しています。

**人物相関図のイメージ**
![](https://github.com/iijimam/doc-images/blob/master/IRIS-NativeAPI-Template/Correlation.gif)

人物相関図と言えば、グラフデータベースをイメージされると思います。

IRIS はグラフデータベースではないのですが、IRIS ネイティブのデータの「**グローバル**」を利用することで、グラフデータベースと似たような構造を表現することができます。

> IRIS の高パフォーマンスを支える**「グローバル」**は 40 年以上前（＝ InterSystems 創業）から Intersystems のコア技術であるデータベースとして提供されてきました。 **「グローバル」** に対する操作方法は、現代のカテゴリに合わせるとしたら NoSQL データベースと言えます。

では、どのようにグラフデータベースのような構造を表現しているか？についてですが、グラフ構造は、ノードと辺から構成されていて、辺は 2 つのノードを結び付けるものです。

SNS の「友達」で考えると、ノードは「ユーザ」、辺は「友達関係」で表現できます。

テンプレートで使用している人物相関図では、ノードは「登場人物」、辺は「登場人物との関係」を表現しています。

**人物相関図のノードと辺（エッジ）**
![](https://github.com/iijimam/doc-images/blob/master/IRIS-NativeAPI-Template/Correlation.gif)


ノードと辺を、どのようにグローバル変数に設定しているでしょうか。


ノードは以下の通りです（配列は、画面表示に利用するノードの ID を設定し、右辺に人物名を登録しています）。
```
^Correlation("Eren")="主人公（エレン）"
```

辺（エッジ）は以下の通りです（グローバル変数の配列を利用して、登場人物→関係のある人[ソース→ターゲット]を設定しています）。
>主人公エレンは、アルミン、ミカサ、ジークと関係がある。を表現しています。

```
^Correlation("Eren","Armin")="" 
^Correlation("Eren","Mikasa")=""
^Correlation("Eren","Zeke")=""
```

両者で関係がある場合は、さらに以下のような配列を追加します。

```
^Correlation("Mikasa")="エレンの幼馴染（ミカサ）"
^Correlation("Mikasa","Armin")=""
^Correlation("Mikasa","Eren")=""
```

実際に、IRIS サーバ側で記述する場合には、[ObjectScript](https://docs.intersystems.com/irislatestj/csp/docbook/Doc.View.cls?KEY=AFL_objectscript) の SET コマンドを使用してグローバル変数を設定します。

```
set ^Correlation("Eren")="主人公（エレン）"
set ^Correlation("Eren","Mikasa")=""
set ^Correlation("Eren","Armin")=""
set ^Correlation("Eren","Zeke")=""
set ^Correlation("Mikasa")="エレンの幼馴染（ミカサ）"
set ^Correlation("Mikasa","Armin")=""
set ^Correlation("Mikasa","Eren")=""
```

配列のサブスクリプト（括弧の中身）は、配列のノード（例では、第 1 番目と第 2 番目）毎に Unicode 昇順でソートされます。

実行後、管理ポータルなどからグローバル変数一覧を参照すると、実行順に関係なく Unicode 昇順にソートされていることを確認できます。
> 管理ポータルは、[http://ホスト名:52779/csp/sys/UtilHome.csp](http://localhost:52779/csp/sys/UtilHome.csp) でアクセスできます（ユーザ名：_system　、パスワード：SYS）。

管理ポータル > [システムエクスプローラ] > [グローバル] > 左画面で「ネームスペース」USER を選択 > ^Correlation の「表示」をクリック
![](https://github.com/iijimam/doc-images/blob/master/IRIS-NativeAPI-Template/MP-Global.gif)



## 1) テンプレートの処理概要

実行環境テンプレートでは、Java 用コンテナから IRIS 用コンテナへ、レコードでもオブジェクトでもないキーバリュー形式でのアクセスを行うため、[Native API](https://docs.intersystems.com/irislatestj/csp/docbook/Doc.View.cls?KEY=AFL_dbnative) を使用しています。
[Native API](https://docs.intersystems.com/irislatestj/csp/docbook/Doc.View.cls?KEY=AFL_dbnative) は、IRIS の JDBC ドライバを使用してアクセスできます。

> Java から IRIS へ接続する方法は 4 手法（JDBC／XEP／Native API／Hibernate）あります。XEP（大量データの高速登録に最適な方法）をお試しいただける実行環境テンプレートをご用意しています。ご興味ありましたら、[GPS（GPX）データを InterSystems IRIS に高速に取り込む方法を体験できる実行環境テンプレート](https://jp.community.intersystems.com/node/495076) をご参照ください。


## 2) [NativeAPI](https://docs.intersystems.com/irislatestj/csp/docbook/Doc.View.cls?KEY=AFL_dbnative) について

Native API は、IRIS 内部のネイティブデータ（＝グローバル変数）を直接操作できる API で [Java](https://docs.intersystems.com/irislatestj/csp/docbook/Doc.View.cls?KEY=AFL_dbnative)、[.NET](https://docs.intersystems.com/irislatestj/csp/docbook/Doc.View.cls?KEY=AFL_netnative)、[Python](https://docs.intersystems.com/irislatestj/csp/docbook/Doc.View.cls?KEY=AFL_pynative)、[Node.js](https://docs.intersystems.com/irislatestj/csp/docbook/Doc.View.cls?KEY=AFL_nodenative) からアクセスできます。
> グローバル変数の操作には、IRIS サーバーサイドプログラミングで使用する [ObjectScript](https://docs.intersystems.com/irislatestj/csp/docbook/Doc.View.cls?KEY=AFL_objectscript) を利用しますが、Native API を利用することで、[ObjectScript](https://docs.intersystems.com/irislatestj/csp/docbook/Doc.View.cls?KEY=AFL_objectscript) を使用せずにお好みの言語からアクセスすることができます。

また、Native API は、グローバル変数の設定／取得の他にも、クラスメソッド、ルーチン、関数を実行することができます。



## 3) 実行環境テンプレートの使用方法

実行環境テンプレートはコンテナを利用しています。実行に必要なドライバは、コンテナビルド時に準備しています。

Docker、docker-compose、git が利用できる環境でお試しください。

**使用するコンテナのイメージ**
![](https://github.com/iijimam/doc-images/blob/master/IRIS-NativeAPI-Template/conatiner.gif)

Java からデータ登録後、[Cytoscape.js](https://js.cytoscape.org/) を利用した HTML を使用して人物相関を視覚的に確認できます。


[http://ホスト名:52779/csp/user/graph.html](http://localhost:52779/csp/user/graph.html)

> REST 経由でグローバル変数を取得しています。IRIS で作成する REST サーバについてご興味ある方は、ぜひ [こちらの記事](https://jp.community.intersystems.com/node/479546) もご参照ください。


実行手順は以下の通りです。

- [3-1) ダウンロード (git clone)](#3-1-)
- [3-2) Java実行環境用コンテナを使う場合](#3-2-))
- [4) Java の実行をホストで行う場合](#4-)
- [4-1) Linuxの場合](#4-1-)
- [4-2) Windowsの場合](#4-2-)


### 3-1) ダウンロード (git clone)

```
git clone https://github.com/Intersystems-jp/IRIS-NativeAPI-Java-Template.git
```


### 3-2) Java実行環境用コンテナを使う場合

1) コンテナをビルドする方法

    ※ IRIS のイメージのダウンロードや Java 実行環境の作成を行うため、少し時間がかかります。
    ```
    docker-compose build
    ```

2) コンテナを開始する方法

    ```
    docker-compose up -d iris
    ```
    この実行で **IRIS 用コンテナ** が開始します（Java 用コンテナは Java 実行時に開始します）。

    
    - 停止したコンテナを再開する方法（Java 用コンテナは Java 実行時に開始します）。
        ```
        docker-compose start iris
        ```

3) サンプルを動かす方法

    ```
    $ docker-compose run java
    Creating iris-nativeapi-java-template_java_run ... done
    InterSystemsIRISにJDBC経由で接続できました
    ****^Correlation(第1ノード) に登録された人の関係者を全件表示します *****

    人物 = Armin - 説明：エレンの幼馴染（アルミン）
    関係者 : Bertolt
    関係者 : Eren
    関係者 : Mikasa

    人物 = Bertolt - 説明：超大型の巨人（ベルトルト）
        <省略>

    IRISの管理ポータルで ^Correlation のデータを確認してください

    $
    ```
4) コンテナを停止する方法
    

    ```
    docker-compose stop
    ```

    IRIS／Java のコンテナを**破棄したい場合**は **down** を指定して実行します。

    ```
    docker-compose down
    ```

5) Javaのソースコードを変えた場合の反映方法
    
    ```
    docker-compose build java
    ```


## 4) Java の実行をホストで行う場合

ホストに、OpenJDK 8 がインストールされている状態でお試し下さい。

ソースコードは、[Java/NativeAPI/Start.java](.Java/NativeAPI/Start.java) にあります。

Java の 接続先 IRIS はコンテナの IRIS を使用しています。

### 4-1) Linuxの場合

Java から IRIS へ接続するときのホスト名に **localhost** を指定しています。

実行環境に合わせてホスト名を変更できるように、[host-java-params.sh](./Java/host-java-params.sh) にホスト名を指定し、環境変数に設定しています。

localhost 以外の場合は、以降に登場するシェル実行前に [host-java-params.sh](./Java/host-java-params.sh) の以下行を環境に合わせて変更してください。

```
IRISHOSTNAME="localhost"
```

準備ができたら以下の手順で実行してください。


```
~/IRIS-NativeAPI-Java-Template$ cd Java
~/IRIS-NativeAPI-Java-Template/Java$ source ./host-java-params.sh
~/IRIS-NativeAPI-Java-Template/Java$ ./build-java-host.sh           
```

Javaの実行には、[runhost.sh](./Java/runhost.sh) を使用します。

実行例）
```
$ ./runhost.sh
isjedu@iijimatest:~/testcontainer/IRIS-NativeAPI-Java-Template/Java$ ./runhost.sh
InterSystemsIRISにJDBC経由で接続できました
****^Correlation(第1ノード) に登録された人の関係者を全件表示します *****

人物 = Armin - 説明：エレンの幼馴染（アルミン）
   関係者 : Bertolt
   関係者 : Eren
   関係者 : Mikasa

人物 = Bertolt - 説明：超大型の巨人（ベルトルト）
   関係者 : Reiner
     ＜表示省略＞
IRISの管理ポータルで ^Correlation のデータを確認してください

----------------------
** 処理終了しました **
----------------------
$    
```

### 4-2) Windows の場合

Java から IRIS へ接続するときのホスト名に **localhost** を指定しています。

実行環境に合わせてホスト名を変更できるように、[host-java-params.bat](./Java/host-java-params.bat) にホスト名を指定し、環境変数に設定しています。

localhost 以外の場合は、以降に登場するシェル実行前に [host-java-params.bat](./Java/host-java-params.bat) の以下行を環境に合わせて変更してください。

```
SET IRISHOSTNAME=localhost
```

準備ができたら以下の手順で実行してください。

Maven を使用したビルドと、IRIS 用コンテナを開始します。


```
~/IRIS-NativeAPI-Java-Template> cd Java
~/IRIS-NativeAPI-Java-Template/Java> host-java-params.bat
~/IRIS-NativeAPI-Java-Template/Java> build-java-host.bat           
```

Javaの実行には、[runhost.bat](./Java/runhost.bat) を使用します。


実行例）
```
> runhost.bat
InterSystemsIRISにJDBC経由で接続できました
****^Correlation(第1ノード) に登録された人の関係者を全件表示します *****

人物 = Armin - 説明：エレンの幼馴染（アルミン）
   関係者 : Bertolt
   関係者 : Eren
   関係者 : Mikasa

人物 = Bertolt - 説明：超大型の巨人（ベルトルト）
   関係者 : Reiner
    ＜表示省略＞
IRISの管理ポータルで ^Correlation のデータを確認してください

-----------------------
 ** completed !! **
-----------------------
>     
```


**READY SET CODE!!**