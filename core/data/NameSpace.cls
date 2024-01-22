/// Representação do namespace que se relacionam com as intefarces do Framework Caedu
Class FrameworkCaedu.core.data.NameSpace Extends (%Persistent, %XML.Adaptor)
{

/// NameSpace que utilizam a interface 
Property NameSpace As %String(MAXLEN = 250) [ Required ];

/// Namespace que utilizam a interface 
Property Insterface As list Of FrameworkCaedu.core.data.Instance;

Index NameSpaceIndex On NameSpace [ Unique ];

Storage Default
{
<Data name="NameSpaceDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>NameSpace</Value>
</Value>
<Value name="3">
<Value>Insterface</Value>
</Value>
</Data>
<DataLocation>^FrameworkCaedu.co1C9.NameSpaceD</DataLocation>
<DefaultData>NameSpaceDefaultData</DefaultData>
<IdLocation>^FrameworkCaedu.co1C9.NameSpaceD</IdLocation>
<IndexLocation>^FrameworkCaedu.co1C9.NameSpaceI</IndexLocation>
<StreamLocation>^FrameworkCaedu.co1C9.NameSpaceS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
