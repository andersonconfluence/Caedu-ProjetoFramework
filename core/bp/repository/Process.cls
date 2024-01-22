Class FrameworkCaedu.core.bp.repository.Process Extends Ens.BusinessProcess [ ClassType = persistent, Language = objectscript ]
{

Method OnRequest(pRequest As FrameworkCaedu.core.bp.repository.Request, Output pResponse As FrameworkCaedu.core.bp.repository.Response) As %Status
{
	Set status = $SYSTEM.Status.OK()
	Try
	{
		If pRequest.RequestAction = ""
		{
			Throw ##Class(%Exception.General).%New("RequestAction Not Found Exception", ..%ConfigName , , "Instance: "_pRequest.InstanceName)
		}
		

		Set tStatus = pRequest.NewResponse(.pResponse)
		
		Set tStatus = $Method($this, pRequest.RequestAction, pRequest, .pResponse)
				
	}
	Catch(e)
	{
		Set status = e.AsStatus()
		Set status = e.AsStatus()
		Set errorMessage = $System.Status.GetErrorText(status)
	}
	Return status
}

Method Create(pRequest As FrameworkCaedu.core.bp.repository.Request, ByRef pResponse As FrameworkCaedu.core.bp.repository.Response) As %Status
{
	Set status = $System.Status.OK()
	
	Set reqCreateRepo = ##class(FrameworkCaedu.core.bo.repository.create.Request).%New()
	Set reqCreateRepo.CreateServiceId 	= pRequest.CreateServiceId
	Set reqCreateRepo.ProcessServiceId 	= pRequest.ProcessServiceId
	Set reqCreateRepo.Payload 			= pRequest.Payload
	Set reqCreateRepo.MessageLogId 		= pRequest.MessageLogId
	
	Set status = ..SendRequestSync("Repository BO", reqCreateRepo, .respCreateRepo)
	
	Set pResponse.RepositoryId = respCreateRepo.RepositoryId
	
	Return status
}

Storage Default
{
<Type>%Storage.Persistent</Type>
}

}
