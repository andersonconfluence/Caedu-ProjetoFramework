Class FrameworkCaedu.core.data.MessageField Extends %Persistent
{

Property MessageId As %String;

Property Code As %String;

Property Value As %String;

Storage Default
{
<Data name="MessageFieldDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>MessageId</Value>
</Value>
<Value name="3">
<Value>Code</Value>
</Value>
<Value name="4">
<Value>Value</Value>
</Value>
</Data>
<DataLocation>^FrameworkCaedu1C9.MessageFieldD</DataLocation>
<DefaultData>MessageFieldDefaultData</DefaultData>
<IdLocation>^FrameworkCaedu1C9.MessageFieldD</IdLocation>
<IndexLocation>^FrameworkCaedu1C9.MessageFieldI</IndexLocation>
<StreamLocation>^FrameworkCaedu1C9.MessageFieldS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
