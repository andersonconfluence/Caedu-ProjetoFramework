Class FrameworkCaedu.core.vo.RestResponse Extends (%SerialObject, %XML.Adaptor)
{

Property HttpResponseBody As %String(MAXLEN = "");

Property HttpResponseStreamBody As %Stream.GlobalCharacter;

Property HttpStatusCode As %String;

Property HttpResponseHeaderArray As array Of %String(MAXLEN = "");

Property Status As %Status;

Storage Default
{
<Data name="RestResponseState">
<Value name="1">
<Value>HttpResponseBody</Value>
</Value>
<Value name="2">
<Value>HttpResponseStreamBody</Value>
</Value>
<Value name="3">
<Value>HttpStatusCode</Value>
</Value>
<Value name="4">
<Value>Status</Value>
</Value>
<Value name="5">
<Value>HttpResponseHeaderArray</Value>
</Value>
</Data>
<State>RestResponseState</State>
<StreamLocation>^confluence.lin27F.RestResponseS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
