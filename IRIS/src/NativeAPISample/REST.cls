Class NativeAPISample.REST Extends %CSP.REST
{

Parameter HandleCorsRequest = 1;

XData UrlMap [ XMLNamespace = "http://www.intersystems.com/urlmap" ]
{
<Routes>
<Route Url="/correlation" Method="GET" Call="GetCorrelation" Cors="true"/>
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

}
