Class FrameworkCaedu.core.bs.PoolingService Extends Ens.BusinessService
{

Parameter ADAPTER = "Ens.InboundAdapter";

Property Adapter As Ens.InboundAdapter;

/// Service name used to query repository
Property ServiceName As %String;

/// Instance name used to query repository
Property InstanceName As %String;

/// Define if call services sync or async
Property IsAsync As %Boolean [ InitialExpression = 1 ];

Parameter SETTINGS = "ServiceName:Linker,InstanceName:Linker,IsAsync:Linker";

/// Check for all Services that has configured to be polled.
Method OnProcessInput(pInput As %RegisteredObject, Output pOutput As %RegisteredObject) As %Status
{
	Try
	{
		#Dim exception As %Exception.General = ""
		#Dim statusCode As %Status           = $System.Status.OK()
		
		//
		Set tArrHostInfo = ##class(FrameworkCaedu.core.util.FunctionSet).GetHostInfoByServiceNameInstance(..InstanceName,..ServiceName) 
        
       	Set request                               = $ClassMethod(tArrHostInfo.GetAt("TargetRequestClassName"), "%New")
       	Set request.RestRequestVO                 = ##Class(FrameworkCaedu.core.vo.RestRequest).%New()
       	Set request.RestRequestVO.InstanceName    = ..InstanceName

       	// 
       	#Dim targetBusinessHost As %String        = tArrHostInfo.GetAt("TargetBusinessHost")
       	
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
