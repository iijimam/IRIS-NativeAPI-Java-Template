//javac -encoding utf-8 NativeAPITest.java
package NativeAPI;
import java.util.Scanner;
import com.intersystems.jdbc.IRIS;
import com.intersystems.jdbc.IRISConnection;
import com.intersystems.jdbc.IRISDataSource;
import com.intersystems.jdbc.IRISIterator;
public class Start{

    protected   static  String              namespace = "USER";
    protected   static  String              host = "nativeapi-iris";
    protected   static  int                 port = 1972; 
    protected   static  String              username = "SuperUser";
    protected   static  String              password = "SYS";

    public static void main (String[] args) {

	try {

        String env1 = System.getenv("IRISHOSTNAME");
        if (env1 !=null ) {
            //System.out.println(env1);
            host=env1;
        }
		//接続オープンには IRISDataSourceを使う
		IRISDataSource ds = new IRISDataSource();
		ds.setURL("jdbc:IRIS://"+host+":"+port+"/"+namespace);
		ds.setUser(username);
		ds.setPassword(password);

		//
		IRISConnection dbconnection = (IRISConnection) ds.getConnection();
		System.out.println("InterSystemsIRISにJDBC経由で接続できました");

		//create irisNative object
		IRIS irisNative = IRIS.createIRIS(dbconnection);

		// ^Characterが存在するとき
		if  (irisNative.isDefined("Character")==1) {

            //グローバル変数を消去
            System.out.println("^Character と ^Correlation を消去します\n");
            irisNative.kill("Character");
            irisNative.kill("Correlation");        
        }

        //set ^Character("Eren")="主人公（エレン）
        irisNative.set("主人公（エレン）","Character","Eren");
        irisNative.set("エレンの幼馴染（アルミン）","Character","Armin");
        irisNative.set("エレンの幼馴染（ミカサ）","Character","Mikasa");
        irisNative.set("エレンのお父さん（グリシャ）","Character","Grisha");
        irisNative.set("エレンの異母兄弟（ジーク）","Character","Zeke");
        irisNative.set("鎧の巨人（ライナー）","Character","Reiner");
        irisNative.set("超大型の巨人（ベルトルト）","Character","Bertolt");
        irisNative.set("エレンのお母さん（カルラ）：ダイナに捕食","Character","Carla");
        irisNative.set("ジークのお母さん（ダイナ）：レイス王家[フリッツ家]","Character","Dina");
        irisNative.set("人類最強の兵士（リヴァイ）","Character","Levi");

        //関係性を設定
        //set ^Correlation("Eren","Mikasa")=""
        irisNative.set("","Correlation","Eren","Mikasa");
        irisNative.set("","Correlation","Eren","Armin");
        irisNative.set("","Correlation","Armin","Mikasa");
        irisNative.set("","Correlation","Mikasa","Armin");
        irisNative.set("","Correlation","Armin","Eren");
        irisNative.set("","Correlation","Mikasa","Eren");
        irisNative.set("","Correlation","Grisha","Eren");
        irisNative.set("","Correlation","Grisha","Zeke");
        irisNative.set("","Correlation","Eren","Zeke");
        irisNative.set("","Correlation","Zeke","Eren");
        irisNative.set("","Correlation","Grisha","Dina");
        irisNative.set("","Correlation","Dina","Grisha");            
        irisNative.set("","Correlation","Grisha","Carla");
        irisNative.set("","Correlation","Carla","Grisha");
        irisNative.set("","Correlation","Dina","Carla");
        irisNative.set("","Correlation","Armin","Bertolt");
        irisNative.set("","Correlation","Reiner","Bertolt");
        irisNative.set("","Correlation","Bertolt","Reiner");
        irisNative.set("","Correlation","Levi","Zeke");

		System.out.println("****^Character に登録された人の関係者を全件表示します *****");

        // ^Character
		IRISIterator character=irisNative.getIRISIterator("Character");
		while (character.hasNext()) {
			String source=character.next();
			System.out.println("\n人物 = "+ source + " - 説明："+ character.getValue());
            //関係のある人を表示（^Correlation）
            IRISIterator correlate=irisNative.getIRISIterator("Correlation",source);
            while (correlate.hasNext()) {
                String target=correlate.next();
                System.out.println("   関係者 : "+ target);
            }
        }

		System.out.println("\n\nIRISの管理ポータルで^Character と ^Correlation のデータを確認してください\n");

		//　クラスメソッド実行（戻り値が文字列）
		//System.out.println("Training.PersonのCreateEmail()（クラスメソッド）＞＞"+irisNative.classMethodString("Training.Person", "CreateEmail","person1"));

		//　ルーチン実行（戻り値が文字列）
		//System.out.println("NativeAPITestルーチンのtest()実行＞＞"+irisNative.functionString("test1","NativeAPITest"));


		//irisの接続をClose
		irisNative.close();
		dbconnection.close();
	}
        catch (Exception ex) {
            System.out.println(ex.getMessage());
        }
	}
 
    //関係のある人表示
    public static void getCorrelation(IRIS irisNative,String source) throws Exception {
		IRISIterator sub2=irisNative.getIRISIterator("Correlation",source);
		while (sub2.hasNext()) {
			String target=sub2.next();
			System.out.println("   関係のある人 : "+ target);
        }
    }

}