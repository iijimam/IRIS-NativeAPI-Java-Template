Class App.Setup
{

ClassMethod CreateSampleData(flg As %Integer = 1) [ SqlProc ]
{
	kill ^Relation
	if flg=1 {
		set ^Relation("Eren")="主人公（エレン）"
		set ^Relation("Armin")="エレンの幼馴染（アルミン）"
		set ^Relation("Mikasa")="エレンの幼馴染（ミカサ）"
		set ^Relation("Grisha")="エレンのお父さん（グリシャ）"
		set ^Relation("Zeke")="エレンの異母兄弟（ジーク）"
		set ^Relation("Reiner")="鎧の巨人（ライナー）"
		set ^Relation("Bertolt")="超大型の巨人（ベルトルト）"
		set ^Relation("Carla")="エレンのお母さん（カルラ）：ダイナに捕食"
		set ^Relation("Dina")="ジークのお母さん（ダイナ）：レイス王家[フリッツ家]"
		set ^Relation("Levi")="人類最強の兵士（リヴァイ）"

		set ^Relation("Eren","Mikasa")=""
		set ^Relation("Eren","Armin")=""
		set ^Relation("Armin","Mikasa")=""
		set ^Relation("Mikasa","Armin")=""
		set ^Relation("Armin","Eren")=""
		set ^Relation("Mikasa","Eren")=""
		set ^Relation("Grisha","Eren")=""
		set ^Relation("Grisha","Zeke")=""
		set ^Relation("Eren","Zeke")=""
		set ^Relation("Zeke","Eren")=""
		set ^Relation("Grisha","Dina")=""
		set ^Relation("Dina","Grisha")=""
		set ^Relation("Grisha","Carla")=""
		set ^Relation("Carla","Grisha")=""
		set ^Relation("Dina","Carla")=""
		set ^Relation("Armin","Bertolt")=""
		set ^Relation("Reiner","Bertolt")=""
		set ^Relation("Bertolt","Reiner")=""
		set ^Relation("Levi","Zeke")=""

	}
	if flg=2 {
		set ^Relation("Momotaro")="主人公（桃太郎）"
		set ^Relation("Grandfather")="おじいさん"
		set ^Relation("Grandmother")="おばあさん"
		set ^Relation("Monkey")="サル"
		set ^Relation("Dog")="いぬ"
		set ^Relation("Pheasant")="キジ"
		set ^Relation("Daemon")="鬼"

		set ^Relation("Grandfather","Momotaro")=""
		set ^Relation("Grandmother","Momotaro")=""
		set ^Relation("Grandmother","Grandfather")=""
		set ^Relation("Grandfather","Grandmother")=""
		set ^Relation("Momotaro","Monkey")=""
		set ^Relation("Monkey","Momotaro")=""
		set ^Relation("Momotaro","Dog")=""
		set ^Relation("Dog","Momotaro")=""
		set ^Relation("Momotaro","Pheasant")=""
		set ^Relation("Pheasant","Momotaro")=""
		set ^Relation("Momotaro","Daemon")=""
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
