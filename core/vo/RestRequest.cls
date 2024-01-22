Class FrameworkCaedu.core.vo.RestRequest Extends (%SerialObject, %XML.Adaptor)
{

Property URL As %String(MAXLEN = "");

Property HttpRequestBody As %String(MAXLEN = "");

Property HttpHeaderArray As array Of %String(MAXLEN = "");

Property InstanceName As %String(MAXLEN = 250);

Property RepositoryId As %Integer;

Property IsResponseHeader As %Boolean [ InitialExpression = 0 ];

Storage Default
{
<Data name="RestRequestState">
<Value name="1">
<Value>URL</Value>
</Value>
<Value name="2">
<Value>HttpRequestBody</Value>
</Value>
<Value name="3">
<Value>HttpHeaderArray</Value>
</Value>
<Value name="4">
<Value>InstanceName</Value>
</Value>
<Value name="5">
<Value>RepositoryId</Value>
</Value>
<Value name="6">
<Value>IsResponseHeader</Value>
</Value>
</Data>
<State>RestRequestState</State>
<StreamLocation>^confluence.link27F.RestRequestS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
