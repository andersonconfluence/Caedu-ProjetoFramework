/// Representation of Instance in Linker
Class FrameworkCaedu.core.data.Instance Extends (%Persistent, %XML.Adaptor)
{

/// Name of instance
Property Name As %String(MAXLEN = 250) [ Required, SqlColumnNumber = 2 ];

/// Host of instance
Property Host As %String(MAXLEN = 150) [ SqlColumnNumber = 3 ];

/// Port of instance
Property Port As %String(MAXLEN = 5) [ SqlColumnNumber = 4 ];

/// Indentify that the Https is enabled
Property HttpsEnabled As %Boolean [ SqlColumnNumber = 5 ];

/// Services used by Instance
Relationship Services As FrameworkCaedu.core.data.Service [ Cardinality = many, Inverse = Instance ];

Index NameIndex On Name [ Unique ];

Storage Default
{
<Data name="InstanceDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Name</Value>
</Value>
<Value name="3">
<Value>Host</Value>
</Value>
<Value name="4">
<Value>Port</Value>
</Value>
<Value name="5">
<Value>HttpsEnabled</Value>
</Value>
</Data>
<DataLocation>^FrameworkCaeduA223.InstanceD</DataLocation>
<DefaultData>InstanceDefaultData</DefaultData>
<IdLocation>^FrameworkCaeduA223.InstanceD</IdLocation>
<IndexLocation>^FrameworkCaeduA223.InstanceI</IndexLocation>
<StreamLocation>^FrameworkCaeduA223.InstanceS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
