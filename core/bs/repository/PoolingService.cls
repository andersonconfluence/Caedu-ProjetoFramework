Class FrameworkCaedu.core.bs.repository.PoolingService Extends Ens.BusinessService
{

Parameter ADAPTER = "Ens.InboundAdapter";

Property Adapter As Ens.InboundAdapter;

/// Service name used to query repository
Property ServiceName As %String;

/// Instance name used to query repository
Property InstanceName As %String;

Property RetryTimes As %Integer [ InitialExpression = 3 ];

/// Retry times of messages with error status
/// Define if call services sync or async
Property IsAsync As %Boolean [ InitialExpression = 1 ];

Parameter SETTINGS = "ServiceName:Linker,InstanceName:Linker,RetryTimes:Linker,IsAsync:Linker";

/// Check for all Services that has configured to be polled.
Method OnProcessInput(pInput As %RegisteredObject, Output pOutput As %RegisteredObject) As %Status
{
	Try
	{
		#Dim exception As %Exception.General = ""
		#Dim statusCode As %Status           = $System.Status.OK()
		#Dim spContext As %ProcedureContext  = ""
		//
		Set spContext = ##Class(%SQL.Statement).%ExecDirect(,"CALL confluence_linker_core_data.Repository_ListByServiceNameInstanceName(?, ?, ?)", ..ServiceName, ..InstanceName, ..RetryTimes)
		//
        While (spContext.%Next(.statusCode))
        {
        	If ($System.Status.IsError(statusCode))
        	{
        		Throw ##Class(%Exception.StatusException).CreateFromStatus(statusCode)
        	}
        	Set request                               = $ClassMethod(spContext.%Get("TargetRequestClassName"), "%New")
        	Set request.RestRequestVO                 = ##Class(FrameworkCaedu.core.vo.RestRequest).%New()
        	Set request.RestRequestVO.HttpRequestBody = spContext.%Get("Payload")
        	Set request.RestRequestVO.InstanceName    = spContext.%Get("InstanceName")
        	Set request.RestRequestVO.RepositoryId    = spContext.%Get("ID")
        	// 
        	#Dim targetBusinessHost As %String        = spContext.%Get("TargetBusinessHost")
        	#Dim repository As FrameworkCaedu.core.data.Repository = ##Class(FrameworkCaedu.core.data.Repository).%OpenId(spContext.%Get("ID")) 
        	//
        	Set repository.Status = 2
        	Set statusCode        = repository.%Save()
        	//
        	If ($System.Status.IsError(statusCode))
        	{        	
        		Throw ##Class(%Exception.StatusException).CreateFromStatus(statusCode)
        	}
        	Set ..%SessionId = "" // force to always create a new session     
        	
        	If ..IsAsync
        	{
	        	Set statusCode   = ..SendRequestAsync(targetBusinessHost, request, .tResponse)
        	}
        	Else
        	{   	
        		Set statusCode   = ..SendRequestSync(targetBusinessHost, request, .tResponse)
        	}
        	//
        	If ($System.Status.IsError(statusCode))
        	{        	
        		Throw ##Class(%Exception.StatusException).CreateFromStatus(statusCode)
        	}
        	
        	//Set repository = ##Class(FrameworkCaedu.core.data.Repository).%OpenId(spContext.%Get("ID"))
        	//Set repository.SessionId = ..%SessionId
        	//Set statusCode           = repository.%Save()
        	//
        	If ($System.Status.IsError(statusCode))
        	{        	
        		Throw ##Class(%Exception.StatusException).CreateFromStatus(statusCode)
        	}
        }
	}
	Catch(exception)
	{
		#Dim errorMessage As %String = exception.DisplayString()
		//
		$$$LOGERROR(errorMessage)
		//
		Set statusCode = exception.AsStatus()
		Set errorMessage = $System.Status.GetErrorText(statusCode)

		
		Throw exception
	}
	Return statusCode
}

}
