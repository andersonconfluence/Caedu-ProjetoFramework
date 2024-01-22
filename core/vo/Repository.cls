Class FrameworkCaedu.core.vo.Repository Extends (%SerialObject, %XML.Adaptor)
{

Property Payload As %String(MAXLEN = "");

Property ProcessServiceId As %Integer;

Property CreateServiceId As %Integer;

Property MessageLogId As %Integer;

Storage Default
{
<Data name="RepositoryState">
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
<State>RepositoryState</State>
<StreamLocation>^confluence.linke27F.RepositoryS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
