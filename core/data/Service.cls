/// Representation of services used by instances
Class FrameworkCaedu.core.data.Service Extends (%Persistent, %XML.Adaptor)
{

/// Name of service
Property Name As %String(MAXLEN = 250) [ Required, SqlColumnNumber = 2 ];

/// Resource Path of service
Property ResourcePath As %String(MAXLEN = "") [ SqlColumnNumber = 3 ];

/// Business Host for service
Property TargetBusinessHost As %String(MAXLEN = 250) [ SqlColumnNumber = 4 ];

/// Request Class Name for Business Host used by service
Property TargetRequestClassName As %String(MAXLEN = 250) [ SqlColumnNumber = 5 ];

/// Parameters for request
Property Params As %String(MAXLEN = 250) [ SqlColumnNumber = 6 ];

/// Instance owner of service
Relationship Instance As FrameworkCaedu.core.data.Instance [ Cardinality = one, Inverse = Services ];

Index InstanceIndex On Instance;

Query GetResourcePathByServiceNameInstance(pInstance As %String, pServiceName As %String = "Login") As %SQLQuery [ SqlProc ]
{
	SELECT Serv.ResourcePath
		  ,Serv.Instance->Host
		  ,Serv.Instance->Port
		  ,Serv.Instance->HttpsEnabled
		  ,Serv.Params
		  ,Serv.ID
	FROM confluence_linker_core_data.Service AS Serv
	WHERE Serv.Instance->Name = :pInstance And Serv.Name = :pServiceName
}

Query GetHostInfoByServiceNameInstance(pInstance As %String, pServiceName As %String = "Login") As %SQLQuery [ SqlProc ]
{
	SELECT Serv.TargetBusinessHost
		  ,Serv.TargetRequestClassName
	FROM confluence_linker_core_data.Service AS Serv
	WHERE Serv.Instance->Name = :pInstance And Serv.Name = :pServiceName
}

Storage Default
{
<Data name="ServiceDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Name</Value>
</Value>
<Value name="3">
<Value>ResourcePath</Value>
</Value>
<Value name="4">
<Value>TargetBusinessHost</Value>
</Value>
<Value name="5">
<Value>TargetRequestClassName</Value>
</Value>
<Value name="6">
<Value>Instance</Value>
</Value>
<Value name="7">
<Value>Paramns</Value>
</Value>
<Value name="8">
<Value>Params</Value>
</Value>
</Data>
<DataLocation>^FrameworkCaeduA223.ServiceD</DataLocation>
<DefaultData>ServiceDefaultData</DefaultData>
<IdLocation>^FrameworkCaeduA223.ServiceD</IdLocation>
<IndexLocation>^FrameworkCaeduA223.ServiceI</IndexLocation>
<StreamLocation>^FrameworkCaeduA223.ServiceS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
