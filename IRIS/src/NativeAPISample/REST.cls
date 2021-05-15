Class NativeAPISample.REST Extends %CSP.REST
{

Parameter HandleCorsRequest = 1;

XData UrlMap [ XMLNamespace = "http://www.intersystems.com/urlmap" ]
{
<Routes>
<Route Url="/correlation" Method="GET" Call="GetCorrelation" Cors="true"/>
<Route Url="/correlation/:key" Method="GET" Call="GetCorrelationKey" Cors="true"/>
</Routes>
}

ClassMethod GetCorrelation() As %Status
{
    #dim ex As %Exception.AbstractException
    #dim %response As %CSP.Response
    set status=$$$OK
    try {
        set %response.CharSet="utf8"
        set %response.ContentType="application/json"

        set source="",nodes=[],edgeArray=[],elements={}
        for {
            set source=$order(^Correlation(source),1,data)
            if source="" {
                quit  //ループ終了
            }
            //nodeデータ作成
            set node={}
            set nodedata={}
            set nodedata.id=source
            set nodedata.label=data
            set node.data=nodedata
            do nodes.%Push(node)

            set target=""
            for {
                set target=$order(^Correlation(source,target))
                if target="" {
                    quit //ループ終了
                }

                set edgedata={}
                set edgedata.id=source_"-"_target
                set edgedata.source=source
                set edgedata.target=target
                set edge={}
                set edge.data=edgedata
                do edgeArray.%Push(edge)
            }
            set data=""
        }
        set elements.nodes=nodes
        set elements.edges=edgeArray
        do elements.%ToJSON()
    }
    catch ex {
        set status=ex.AsStatus()
    }
    return status
}

ClassMethod GetCorrelationKey(key As %String) As %Status
{
    #dim ex As %Exception.AbstractException
    #dim %response As %CSP.Response
    set status=$$$OK
    try {
        set %response.CharSet="utf8"
        set %response.ContentType="application/json"

        do ..getTargets(key,1,.array)
        set source="",nodes=[],edgeArray=[],elements={}
        for {
            set source=$order(array(source),1,data)
            if source="" {
                quit  //ループ終了
            }
            //nodeデータ作成
            set node={}
            set nodedata={}
            set nodedata.id=source
            set nodedata.label=data
            set node.data=nodedata
            do nodes.%Push(node)

            set target=""
            for {
                set target=$order(array(source,target))
                if target="" {
                    quit //ループ終了
                }

                set edgedata={}
                set edgedata.id=source_"-"_target
                set edgedata.source=source
                set edgedata.target=target
                set edge={}
                set edge.data=edgedata
                do edgeArray.%Push(edge)
            }
            set data=""
        }
        set elements.nodes=nodes
        set elements.edges=edgeArray
        do elements.%ToJSON()

    }
    catch ex {
        set status=ex.AsStatus()
    }
    return status
}

/// 指定人物から繋がる関係者を取得（一旦配列に格納）
ClassMethod getTargets(source As %String, count As %Integer, ByRef array As %String)
{
    if count>4 return
    if $get(source)="" return
    set target="",result=""
    for {
        set target=$order(^Correlation(source,target))
        if target="" {
            quit  //ループ終了
        }
        set array(target)=$get(^Correlation(target))
        set array(source,target)=""
        set $list(result,$listlength(result)+1)=target
    }
    for i=1:1:$listlength(result) {
        do ..getTargets($list(result,i),count+1,.array)
    }
}

}
