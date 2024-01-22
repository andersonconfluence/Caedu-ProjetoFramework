Class FrameworkCaedu.core.data.FromTo Extends (%Persistent, %XML.Adaptor, %JSON.Adaptor)
{

Property ReferenceFromToCode As %String [ SqlColumnNumber = 2 ];

Property Key As %String(MAXLEN = 100) [ SqlColumnNumber = 3 ];

Property Value As %String [ SqlColumnNumber = 4 ];

Property UpdatedAt As %TimeStamp [ SqlColumnNumber = 5 ];

Property Status As %Boolean [ SqlColumnNumber = 6 ];

Index KeyIdx On (ReferenceFromToCode, Key);

Storage Default
{
<Data name="FromToDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ReferenceFromToCode</Value>
</Value>
<Value name="3">
<Value>Key</Value>
</Value>
<Value name="4">
<Value>Value</Value>
</Value>
<Value name="5">
<Value>UpdatedAt</Value>
</Value>
<Value name="6">
<Value>Status</Value>
</Value>
</Data>
<DataLocation>^FrameworkCaedu.cA223.FromToD</DataLocation>
<DefaultData>FromToDefaultData</DefaultData>
<IdLocation>^FrameworkCaedu.cA223.FromToD</IdLocation>
<IndexLocation>^FrameworkCaedu.cA223.FromToI</IndexLocation>
<StreamLocation>^FrameworkCaedu.cA223.FromToS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
