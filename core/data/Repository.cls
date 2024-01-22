///   Class to store all Payloads to be processed
Class FrameworkCaedu.core.data.Repository Extends %Persistent
{

/// Store entire JSON string to be processed
Property Payload As %String(MAXLEN = "") [ SqlColumnNumber = 2 ];

/// Reference to the service (is not a business service) configurarion that process the entry.
Property ProcessService As FrameworkCaedu.core.data.Service [ Required, SqlColumnNumber = 3 ];

/// Reference to the service (is not a business service) that create the entry.
Property CreateService As FrameworkCaedu.core.data.Service [ Required, SqlColumnNumber = 4 ];

/// IRIS SessionID used to trace message
Property SessionId As %Integer [ SqlColumnNumber = 5 ];

/// Control status
Property Status As %String(DISPLAYLIST = ",Created,Processing,Processed,Discarded,Error", VALUELIST = ",1,2,3,4,5") [ InitialExpression = 1, Required, SqlColumnNumber = 6 ];

/// Timestamp of creation
Property TimeCreated As %TimeStamp [ InitialExpression = {##Class(%UTC).NowLocal()}, SqlColumnNumber = 7 ];

/// Timestamp of end of process
Property TimeProcessed As %TimeStamp [ SqlColumnNumber = 8 ];

/// Message of processing
Property ProcessMessage As %String(MAXLEN = "") [ SqlColumnNumber = 9 ];

/// Lot code of list of message
Property LotCode As %String [ SqlColumnNumber = 10 ];

/// Times to retry to reprocess a a error processing
Property RetryTimes As %Integer [ SqlColumnNumber = 11 ];

Property MessageLogId As %Integer [ SqlColumnNumber = 12 ];

Index Extent [ Extent, Type = bitmap ];

Index TimeCreatedIdx On TimeCreated;

Index TimeProcessedIdx On TimeProcessed;

Index StatusIdx On Status [ Type = bitmap ];

Index ProcessServiceIdx On ProcessService;

Index CreateServiceIdx On CreateService;

/// Create a new entry to be processed
ClassMethod CreateEntry(pMessageLogId As %Integer, pPayload As %String, pProcessService As FrameworkCaedu.core.data.Service, pCreateService As FrameworkCaedu.core.data.Service) As FrameworkCaedu.core.data.Repository
{
	
	Try
	{
		#Dim exception As %Exception.General = ""
		#Dim statusCode As %Status           = $System.Status.OK()
		#Dim entry As Repository             = ..%New()
	
		//
		Set entry.Payload    		= pPayload
		Set entry.ProcessService    = pProcessService
		Set entry.CreateService 	= pCreateService
		Set entry.MessageLogId   	= pMessageLogId
		Set statusCode          	= entry.%Save()
		
		//
		If ($System.Status.IsError(statusCode))
		{
			Throw ##Class(%Exception.StatusException).CreateFromStatus(statusCode)
		}
	}
	Catch(exception)
	{
		Set tSC = exception.AsStatus()
		Set errorMessage = $System.Status.GetErrorText(tSC)
		Throw exception
	}
	
	Return entry
}

/// Finalize the entry
ClassMethod Finalize(pRepositoryId As %Integer, pSessionId As %Integer) As FrameworkCaedu.core.data.Repository
{
	
	Try
	{
		#Dim exception As %Exception.General = ""
		#Dim statusCode As %Status           = $System.Status.OK()
		#Dim entry As Repository             = ..%OpenId(pRepositoryId)
	
		//
		Set entry.TimeProcessed  = ##Class(%UTC).NowLocal()
		Set entry.SessionId		 = pSessionId
		Set entry.Status 		 = 3
		Set entry.ProcessMessage = ""
		Set statusCode           = entry.%Save()
		
		//
		If ($System.Status.IsError(statusCode))
		{
			Throw ##Class(%Exception.StatusException).CreateFromStatus(statusCode)
		}
	}
	Catch(exception)
	{
		Set tSC = exception.AsStatus()
		Set errorMessage = $System.Status.GetErrorText(tSC)
		Throw exception
	}
	
	Return entry
}

ClassMethod SetStatus(pRepositoryId As %Integer, pStatus As %String, pSessionId As %Integer, pProcessMessage As %String)
{
	Try
	{
		#Dim exception As %Exception.General = ""
		#Dim statusCode As %Status           = $System.Status.OK()
		#Dim entry As Repository             = ..%OpenId(pRepositoryId)
		#Dim retryTimes As %Integer          = +entry.RetryTimes
		//
		Set entry.ProcessMessage 	= pProcessMessage
		Set entry.Status       		= pStatus
		If pStatus = 1
		{
			Set entry.RetryTimes   		= 0
		}
		Else
		{
			Set entry.RetryTimes   		= $Increment(retryTimes)
		}
		Set entry.SessionId	   		= pSessionId
		Set entry.TimeProcessed  = ##Class(%UTC).NowLocal()
		Set statusCode         		= entry.%Save()
		//
		If ($System.Status.IsError(statusCode))
		{
			Throw ##Class(%Exception.StatusException).CreateFromStatus(statusCode)
		}
	}
	Catch(exception)
	{
		Set tSC = exception.AsStatus()
		Set errorMessage = $System.Status.GetErrorText(tSC)
		Throw exception
	}
}

Query ListByServiceNameInstanceName(pServiceName As %String, pInstanceName As %String, pRetryTimes As %Integer = 3) As %SQLQuery(SELECTMODE = "ODBC") [ SqlProc ]
{
	SELECT Id
	      ,ProcessService->Id As ServiceId
	      ,ProcessService->Instance->Name AS InstanceName
	      ,Payload
	      ,ProcessService->TargetBusinessHost
	      ,ProcessService->TargetRequestClassName
	FROM confluence_linker_core_data.Repository
	WHERE ProcessService->Name = :pServiceName AND 
	      ProcessService->Instance->Name = :pInstanceName AND 
	      ((%EXTERNAL(Status) = 'Created') OR ((%EXTERNAL(Status) = 'Error') AND (RetryTimes < :pRetryTimes)))
}

Storage Default
{
<Data name="RepositoryDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Payload</Value>
</Value>
<Value name="3">
<Value>ProcessService</Value>
</Value>
<Value name="4">
<Value>CreateService</Value>
</Value>
<Value name="5">
<Value>SessionId</Value>
</Value>
<Value name="6">
<Value>Status</Value>
</Value>
<Value name="7">
<Value>TimeCreated</Value>
</Value>
<Value name="8">
<Value>TimeProcessed</Value>
</Value>
<Value name="9">
<Value>ProcessMessage</Value>
</Value>
<Value name="10">
<Value>LotCode</Value>
</Value>
<Value name="11">
<Value>RetryTimes</Value>
</Value>
<Value name="12">
<Value>MessageLogId</Value>
</Value>
</Data>
<DataLocation>^confluence.linkA223.RepositoryD</DataLocation>
<DefaultData>RepositoryDefaultData</DefaultData>
<IdLocation>^confluence.linkA223.RepositoryD</IdLocation>
<IndexLocation>^confluence.linkA223.RepositoryI</IndexLocation>
<StreamLocation>^confluence.linkA223.RepositoryS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
