Class FrameworkCaedu.core.bo.http.msg.ChamadaPostReq Extends Ens.Request
{

Property Server As %String(MAXLEN = 100);

Property Port As %String(MAXLEN = 100);

Property UrlBase As %String(MAXLEN = 250);

Property Url As %String(MAXLEN = 500);

Property ComplementoUrl As %String(MAXLEN = "");

Property Contents As %GlobalCharacterStream;

Property Headers As list Of %String(MAXLEN = "");

Storage Default
{
<Data name="ChamadaPostReqDefaultData">
<Subscript>"ChamadaPostReq"</Subscript>
<Value name="1">
<Value>Server</Value>
</Value>
<Value name="2">
<Value>Port</Value>
</Value>
<Value name="3">
<Value>UrlBase</Value>
</Value>
<Value name="4">
<Value>Url</Value>
</Value>
<Value name="5">
<Value>ComplementoUrl</Value>
</Value>
<Value name="6">
<Value>Contents</Value>
</Value>
<Value name="7">
<Value>Headers</Value>
</Value>
</Data>
<DefaultData>ChamadaPostReqDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
