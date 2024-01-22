Class FrameworkCaedu.core.data.MessageLog Extends %Persistent
{

Property Cliente As %String;

Property Servico As %String;

Property CodeStatus As %String;

Property CodeEvent As %String;

Property Origem As %String;

Property Destino As %String;

Property Note As %String;

Property PayLoad As %String(MAXLEN = "");

Property ExMessageId As %String(MAXLEN = "");

Property ExTraceLink As %String(MAXLEN = "");

Property Start As %String;

Property Finish As %String;

Property Status As %Boolean;

Storage Default
{
<Data name="MessageLogDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>MessageLog</Value>
</Value>
<Value name="3">
<Value>Cliente</Value>
</Value>
<Value name="4">
<Value>Servico</Value>
</Value>
<Value name="5">
<Value>CodeStatus</Value>
</Value>
<Value name="6">
<Value>CodeEvent</Value>
</Value>
<Value name="7">
<Value>Origem</Value>
</Value>
<Value name="8">
<Value>Destino</Value>
</Value>
<Value name="9">
<Value>Note</Value>
</Value>
<Value name="10">
<Value>PayLoad</Value>
</Value>
<Value name="11">
<Value>ExMessageId</Value>
</Value>
<Value name="12">
<Value>TraceLinkId</Value>
</Value>
<Value name="13">
<Value>Start</Value>
</Value>
<Value name="14">
<Value>Finish</Value>
</Value>
<Value name="15">
<Value>Status</Value>
</Value>
<Value name="16">
<Value>Id</Value>
</Value>
<Value name="17">
<Value>ExTraceLinkId</Value>
</Value>
<Value name="18">
<Value>ExTraceLink</Value>
</Value>
</Data>
<DataLocation>^confluence.linkA223.MessageLogD</DataLocation>
<DefaultData>MessageLogDefaultData</DefaultData>
<IdLocation>^confluence.linkA223.MessageLogD</IdLocation>
<IndexLocation>^confluence.linkA223.MessageLogI</IndexLocation>
<StreamLocation>^confluence.linkA223.MessageLogS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
