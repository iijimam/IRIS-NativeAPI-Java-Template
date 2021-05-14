Class App.Setup
{

ClassMethod CreateSampleData(flg As %Integer = 1) [ SqlProc ]
{
	kill ^Correlation
	if flg=1 {
		set ^Correlation("Eren")="主人公（エレン）"
		set ^Correlation("Armin")="エレンの幼馴染（アルミン）"
		set ^Correlation("Mikasa")="エレンの幼馴染（ミカサ）"
		set ^Correlation("Grisha")="エレンのお父さん（グリシャ）"
		set ^Correlation("Zeke")="エレンの異母兄弟（ジーク）"
		set ^Correlation("Reiner")="鎧の巨人（ライナー）"
		set ^Correlation("Bertolt")="超大型の巨人（ベルトルト）"
		set ^Correlation("Carla")="エレンのお母さん（カルラ）：ダイナに捕食"
		set ^Correlation("Dina")="ジークのお母さん（ダイナ）：レイス王家[フリッツ家]"
		set ^Correlation("Levi")="人類最強の兵士（リヴァイ）"

		set ^Correlation("Eren","Mikasa")=""
		set ^Correlation("Eren","Armin")=""
		set ^Correlation("Armin","Mikasa")=""
		set ^Correlation("Mikasa","Armin")=""
		set ^Correlation("Armin","Eren")=""
		set ^Correlation("Mikasa","Eren")=""
		set ^Correlation("Grisha","Eren")=""
		set ^Correlation("Grisha","Zeke")=""
		set ^Correlation("Eren","Zeke")=""
		set ^Correlation("Zeke","Eren")=""
		set ^Correlation("Grisha","Dina")=""
		set ^Correlation("Dina","Grisha")=""
		set ^Correlation("Grisha","Carla")=""
		set ^Correlation("Carla","Grisha")=""
		set ^Correlation("Dina","Carla")=""
		set ^Correlation("Armin","Bertolt")=""
		set ^Correlation("Reiner","Bertolt")=""
		set ^Correlation("Bertolt","Reiner")=""
		set ^Correlation("Levi","Zeke")=""

	}
	if flg=2 {
		set ^Correlation("Momotaro")="主人公（桃太郎）"
		set ^Correlation("Grandfather")="おじいさん"
		set ^Correlation("Grandmother")="おばあさん"
		set ^Correlation("Monkey")="サル"
		set ^Correlation("Dog")="いぬ"
		set ^Correlation("Pheasant")="キジ"
		set ^Correlation("Daemon")="鬼"

		set ^Correlation("Grandfather","Momotaro")=""
		set ^Correlation("Grandmother","Momotaro")=""
		set ^Correlation("Grandmother","Grandfather")=""
		set ^Correlation("Grandfather","Grandmother")=""
		set ^Correlation("Momotaro","Monkey")=""
		set ^Correlation("Monkey","Momotaro")=""
		set ^Correlation("Momotaro","Dog")=""
		set ^Correlation("Dog","Momotaro")=""
		set ^Correlation("Momotaro","Pheasant")=""
		set ^Correlation("Pheasant","Momotaro")=""
		set ^Correlation("Momotaro","Daemon")=""
	}
}

ClassMethod SetRESTPath() As %Status
{
	#dim ex As %Exception.AbstractException
	set status=$$$OK
	try {
		new $namespace
		// REST用パスの作成
		set $namespace="%SYS"
		set webName = "/graph"
		set webProperties("DispatchClass") = "NativeAPISample.REST"
		set webProperties("NameSpace") = "USER"
		set webProperties("Enabled") = 1
		set webProperties("AutheEnabled") = 96
		set webProperties("MatchRoles")=":%All"
		$$$ThrowOnError(##class(Security.Applications).Create(webName, .webProperties))
		// CSPSystemへロール追加
		$$$ThrowOnError(##class(Security.Users).AddRoles("CSPSystem","%DB_USER"))
	}
	catch ex {
		set status=ex.AsStatus()
	}
	return $$$OK
}

}
