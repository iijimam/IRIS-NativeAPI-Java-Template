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

		// ^Correlationが存在するとき
		if  (irisNative.isDefined("Correlation")==1) {

            //グローバル変数を消去
            System.out.println("^Correlation を消去します\n");
            irisNative.kill("Correlation");        
        }

        //set ^Correlation("Eren")="主人公（エレン）
        irisNative.set("主人公（エレン）","Correlation","Eren");
        irisNative.set("エレンの幼馴染（アルミン）","Correlation","Armin");
        irisNative.set("エレンの幼馴染（ミカサ）","Correlation","Mikasa");
        irisNative.set("エレンのお父さん（グリシャ）","Correlation","Grisha");
        irisNative.set("エレンの異母兄弟（ジーク）","Correlation","Zeke");
        irisNative.set("鎧の巨人（ライナー）","Correlation","Reiner");
        irisNative.set("超大型の巨人（ベルトルト）","Correlation","Bertolt");
        irisNative.set("エレンのお母さん（カルラ）：ダイナに捕食","Correlation","Carla");
        irisNative.set("ジークのお母さん（ダイナ）：レイス王家[フリッツ家]","Correlation","Dina");
        irisNative.set("人類最強の兵士（リヴァイ）","Correlation","Levi");

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

		System.out.println("****^Correlation(第1ノード) に登録された人の関係者を全件表示します *****");

        // ^Correlation
		IRISIterator character=irisNative.getIRISIterator("Correlation");
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

		System.out.println("\n\nIRISの管理ポータルで ^Correlation のデータを確認してください\n");


        System.out.print("\n指定した人物の関係者を探します。人物名を入力（Armin、Levi、Zeke など） >>");
        Scanner scan = new Scanner(System.in); 
        String name = scan.nextLine();

        getTargets(irisNative,name,1);        

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
            IRISIterator correlate=irisNative.getIRISIterator("Correlation",source);
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