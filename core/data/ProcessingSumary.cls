///   Class to store sumary Payloads processed
Class FrameworkCaedu.core.data.ProcessingSumary Extends %Persistent
{

/// Date that messages was sumarized
Property SumaryDate As %Date;

/// Name of sumary
Property SumaryName As %String(MAXLEN = "") [ Required ];

/// Reference to the service (is not a business service) configurarion that process the entry.
Property Service As FrameworkCaedu.core.data.Service;

/// Control status
Property Status As %String(DISPLAYLIST = ",Created,Processing,Processed,Discarded,Error", VALUELIST = ",1,2,3,4,5") [ InitialExpression = 1, Required ];

/// Quantity of processed messages
Property Quantity As %Integer;

/// Size in bytes of processed messages
Property Size As %Integer;

/// Timestamp of creation
Property TimeCreated As %TimeStamp [ InitialExpression = {##Class(%UTC).NowLocal()} ];

Index Extent [ Extent, Type = bitmap ];

Index TimeCreatedIdx On TimeCreated;

Index StatusIdx On Status [ Type = bitmap ];

Index ServiceIdx On Service;

Index UniqueIdx On (SumaryDate, SumaryName, Status) [ Unique ];

Storage Default
{
<Data name="ProcessingSumaryDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>SumaryDate</Value>
</Value>
<Value name="3">
<Value>Service</Value>
</Value>
<Value name="4">
<Value>Status</Value>
</Value>
<Value name="5">
<Value>Quantity</Value>
</Value>
<Value name="6">
<Value>TimeCreated</Value>
</Value>
<Value name="7">
<Value>SumaryName</Value>
</Value>
<Value name="8">
<Value>Size</Value>
</Value>
</Data>
<DataLocation>^confluenceA223.ProcessingS9084D</DataLocation>
<DefaultData>ProcessingSumaryDefaultData</DefaultData>
<IdLocation>^confluenceA223.ProcessingS9084D</IdLocation>
<IndexLocation>^confluenceA223.ProcessingS9084I</IndexLocation>
<StreamLocation>^confluenceA223.ProcessingS9084S</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
