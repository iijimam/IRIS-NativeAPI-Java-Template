package NativeAPI;
import java.util.Scanner;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
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

		// ^Relationが存在するとき
		if  (irisNative.isDefined("Relation")==1) {

            //グローバル変数を消去
            System.out.println("^Relation を消去します\n");
            irisNative.kill("Relation");        
        }

        //set ^Relation("Eren")="主人公（エレン）
        irisNative.set("主人公（エレン）","Relation","Eren");
        irisNative.set("エレンの幼馴染（アルミン）","Relation","Armin");
        irisNative.set("エレンの幼馴染（ミカサ）","Relation","Mikasa");
        irisNative.set("エレンのお父さん（グリシャ）","Relation","Grisha");
        irisNative.set("エレンの異母兄弟（ジーク）","Relation","Zeke");
        irisNative.set("鎧の巨人（ライナー）","Relation","Reiner");
        irisNative.set("超大型の巨人（ベルトルト）","Relation","Bertolt");
        irisNative.set("エレンのお母さん（カルラ）：ダイナに捕食","Relation","Carla");
        irisNative.set("ジークのお母さん（ダイナ）：レイス王家[フリッツ家]","Relation","Dina");
        irisNative.set("人類最強の兵士（リヴァイ）","Relation","Levi");

        //関係性を設定
        //set ^Relation("Eren","Mikasa")=""
        irisNative.set("","Relation","Eren","Mikasa");
        irisNative.set("","Relation","Eren","Armin");
        irisNative.set("","Relation","Armin","Mikasa");
        irisNative.set("","Relation","Mikasa","Armin");
        irisNative.set("","Relation","Armin","Eren");
        irisNative.set("","Relation","Mikasa","Eren");
        irisNative.set("","Relation","Grisha","Eren");
        irisNative.set("","Relation","Grisha","Zeke");
        irisNative.set("","Relation","Eren","Zeke");
        irisNative.set("","Relation","Zeke","Eren");
        irisNative.set("","Relation","Grisha","Dina");
        irisNative.set("","Relation","Dina","Grisha");            
        irisNative.set("","Relation","Grisha","Carla");
        irisNative.set("","Relation","Carla","Grisha");
        irisNative.set("","Relation","Dina","Carla");
        irisNative.set("","Relation","Armin","Bertolt");
        irisNative.set("","Relation","Reiner","Bertolt");
        irisNative.set("","Relation","Bertolt","Reiner");
        irisNative.set("","Relation","Levi","Zeke");

		System.out.println("****^Relation(第1ノード) に登録された人の関係者を全件表示します *****");

        // ^Relation
		IRISIterator character=irisNative.getIRISIterator("Relation");
		while (character.hasNext()) {
			String source=character.next();
			System.out.println("\n人物 = "+ source + " - 説明："+ character.getValue());
            //関係のある人を表示（^Relation）
            IRISIterator correlate=irisNative.getIRISIterator("Relation",source);
            while (correlate.hasNext()) {
                String target=correlate.next();
                System.out.println("   関係者 : "+ target);
            }
        }

		System.out.println("\n\nIRISの管理ポータルで ^Relation のデータを確認してください\n");


        System.out.print("\n指定した人物の関係者を探します。人物名を入力（Armin、Levi、Zeke など） >>");
        Scanner scan = new Scanner(System.in); 
        String name = scan.nextLine();

        if (!("".equals(name))) {
            getTargets(irisNative,name,1);        
        }

		//irisの接続をClose
		irisNative.close();
		dbconnection.close();
	}
        catch (Exception ex) {
            System.out.println(ex.getMessage());
        }
	}

    // 指定された第2引数の関係者を取得する
    static void getTargets(IRIS irisNative,String source,int count) {
        try {
            if (count >3) {
                return;
            }
            List<String> result = new ArrayList<String>();
            System.out.println("\n" + source + " の関係者を探します");
            //関係のある人を表示
            IRISIterator correlate=irisNative.getIRISIterator("Relation",source);
            while (correlate.hasNext()) {
                String target=correlate.next();
                System.out.println("   関係者 : " + target);
                result.add(target);
            }
            for (int i=0; i<result.size(); i++){
                getTargets(irisNative,result.get(i),count+1);
            }
        }
        catch (Exception e) {
            System.out.println(e.getMessage());
        }
    }
}