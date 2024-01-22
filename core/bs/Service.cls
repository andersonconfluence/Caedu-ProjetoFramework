Class FrameworkCaedu.core.bs.Service Extends Ens.BusinessService
{

Parameter ADAPTER;

Method OnProcessInput(pInput As %RegisteredObject, Output pOutput As %RegisteredObject, ByRef pHint As %String) As %Status
{
	Try
	{
		#Dim exception As %Exception.StatusException = ""
		#Dim statusCode As %Status                   = $System.Status.OK()
		// 
		Set pOutput = $Method($this, pHint, pInput)
	}
	Catch (exception)
	{
		Set statusCode = exception.AsStatus()
	}
	Return statusCode
}

Method CreateRepository(pRepoVO As FrameworkCaedu.core.vo.Repository) As %String
{
	Try
	{
		#Dim exception As %Exception.StatusException  = ""		
		#Dim statusCode As %Status                    = $System.Status.OK()
		
		#Dim request As FrameworkCaedu.core.bp.repository.Request   = ##Class(FrameworkCaedu.core.bp.repository.Request).%New()
		#Dim response As FrameworkCaedu.core.bp.repository.Response  = ""
		
		//
		Set request.RequestAction 		= "Create"
		Set request.Payload 			= pRepoVO.Payload
		Set request.CreateServiceId 	= pRepoVO.CreateServiceId
		Set request.ProcessServiceId 	= pRepoVO.ProcessServiceId
		Set request.MessageLogId     	= pRepoVO.MessageLogId
		
		Set statusCode = ..SendRequestSync("Core Repository CRUD" , request, .response)
		//
		If ($System.Status.IsError(statusCode))
		{
			Throw ##Class(%Exception.StatusException).CreateFromStatus(statusCode)
		}
		
	}
	Catch (exception)
	{
		Throw exception 
	}
	Return response.RepositoryId
}

}
