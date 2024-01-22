Class FrameworkCaedu.core.bo.repository.Operation Extends Ens.BusinessOperation [ Language = objectscript ]
{

Parameter INVOCATION = "Queue";

Method Create(pRequest As FrameworkCaedu.core.bo.repository.create.Request, Output pResponse As FrameworkCaedu.core.bo.repository.create.Response) As %Status
{
	Set status = $System.Status.OK()
	Try
	{
		
		Set status = pRequest.NewResponse(.pResponse)
		Set createService = ##class(FrameworkCaedu.core.data.Service).%OpenId(pRequest.CreateServiceId)
		Set processService = ##class(FrameworkCaedu.core.data.Service).%OpenId(pRequest.ProcessServiceId)
		Set repository = ##class(FrameworkCaedu.core.data.Repository).CreateEntry(pRequest.MessageLogId,pRequest.Payload,processService,createService)
		
		//
		Set pResponse.RepositoryId = repository.%Id()
		
	}
	Catch(exception)
	{
		Set tSC = exception.AsStatus()
		Set errorMessage = $System.Status.GetErrorText(tSC)
		Throw exception
	}
	
	Return status
}

XData MessageMap
{
<MapItems>
	<MapItem MessageType="FrameworkCaedu.core.bo.repository.create.Request"> 
		<Method>Create</Method>
	</MapItem>
</MapItems>
}

}
