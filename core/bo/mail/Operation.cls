Class FrameworkCaedu.core.bo.mail.Operation Extends Ens.BusinessOperation
{

Parameter ADAPTER = "EnsLib.EMail.OutboundAdapter";

Property Adapter As EnsLib.EMail.OutboundAdapter;

Parameter INVOCATION = "Queue";

Method SendMail(pRequest As FrameworkCaedu.core.bo.mail.sendMail.Request, Output pResponse As FrameworkCaedu.core.bo.mail.sendMail.Response) As %Status
{
	Try
	{							
		
		Set status = $System.Status.OK()
		Set pResponse = ##class(FrameworkCaedu.core.bo.mail.sendMail.Response).%New()			
		
		Set msg = ##class(%Net.MailMessage).%New()
		
		For x=1:1:$Length(pRequest.Recipients,",")
		{
			Do msg.To.Insert($Piece(pRequest.Recipients,",",x))
		}
		
		Set msg.Subject = pRequest.Subject
		Set msg.IsHTML = pRequest.IsHtml
		Set msg.IsBinary = pRequest.IsBinary
		Set msg.Charset="iso-8859-1"
		
		Do msg.TextData.Write(pRequest.Text)
		
		Set status = ..Adapter.SendMail(msg)
		
		If $System.Status.IsError(status) Throw
		
		Set pResponse.StatusMessage = "Email enviado com sucesso"
		
	}
	Catch(exception)
	{
		Set status = exception.AsStatus()
		Set errorMessage = $System.Status.GetErrorText(status)
		Set pResponse.StatusMessage = errorMessage
	}
	
	Set pResponse.StatusCode = status
	return status
}

XData MessageMap
{
<MapItems>
	<MapItem MessageType="FrameworkCaedu.core.bo.mail.sendMail.Request"> 
		<Method>SendMail</Method>
	</MapItem>
</MapItems>
}

}
