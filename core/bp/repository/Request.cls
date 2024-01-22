Class FrameworkCaedu.core.bp.repository.Request Extends Ens.Request [ Language = objectscript ]
{

Parameter RESPONSECLASSNAME = "FrameworkCaedu.core.bp.repository.Response";

Property RequestAction As %String(MAXLEN = 15);

Property RepositoryId As %Integer;

Property Payload As %String(MAXLEN = "");

Property ProcessServiceId As %Integer;

Property CreateServiceId As %Integer;

Property MessageLogId As %Integer;

Storage Default
{
<Data name="RequestDefaultData">
<Subscript>"Request"</Subscript>
<Value name="1">
<Value>RequestAction</Value>
</Value>
<Value name="2">
<Value>RequestId</Value>
</Value>
<Value name="3">
<Value>RequestBody</Value>
</Value>
<Value name="4">
<Value>RepositoryId</Value>
</Value>
<Value name="5">
<Value>Payload</Value>
</Value>
<Value name="6">
<Value>ProcessServiceId</Value>
</Value>
<Value name="7">
<Value>CreateServiceId</Value>
</Value>
<Value name="8">
<Value>MessageLogId</Value>
</Value>
</Data>
<DefaultData>RequestDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
