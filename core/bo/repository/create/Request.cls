Class FrameworkCaedu.core.bo.repository.create.Request Extends Ens.Request [ Language = objectscript ]
{

Parameter RESPONSECLASSNAME = "FrameworkCaedu.core.bo.repository.create.Response";

Property Payload As %String(MAXLEN = "");

Property ProcessServiceId As %Integer;

Property CreateServiceId As %Integer;

Property MessageLogId As %Integer;

Storage Default
{
<Data name="RequestDefaultData">
<Subscript>"Request"</Subscript>
<Value name="1">
<Value>Payload</Value>
</Value>
<Value name="2">
<Value>ProcessServiceId</Value>
</Value>
<Value name="3">
<Value>CreateServiceId</Value>
</Value>
<Value name="4">
<Value>MessageLogId</Value>
</Value>
</Data>
<DefaultData>RequestDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
