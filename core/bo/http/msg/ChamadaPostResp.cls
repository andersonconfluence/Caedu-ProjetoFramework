Class FrameworkCaedu.core.bo.http.msg.ChamadaPostResp Extends Ens.Response
{

Property StatusCode As %Integer;

Property StatusLine As %String(MAXLEN = "");

Property StatusMessage As %String(MAXLEN = "");

Property Contents As %GlobalCharacterStream;

Storage Default
{
<Data name="ChamadaPostRespDefaultData">
<Subscript>"ChamadaPostResp"</Subscript>
<Value name="1">
<Value>StatusCode</Value>
</Value>
<Value name="2">
<Value>StatusLine</Value>
</Value>
<Value name="3">
<Value>StatusMessage</Value>
</Value>
<Value name="4">
<Value>Contents</Value>
</Value>
</Data>
<DefaultData>ChamadaPostRespDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
