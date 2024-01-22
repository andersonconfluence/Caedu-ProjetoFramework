Class FrameworkCaedu.core.api.rest.Router Extends %CSP.REST
{

Parameter HandleCorsRequest As %Boolean = 1;

XData UrlMap
{
<Routes>
   <Route Url="/repository" Method="POST" Call="CreateRepository" />
   <Route Url="/repository/:repoId" Method="GET" Call="GetRepository" />
</Routes>
}

ClassMethod CreateRepository() As %Status
{
	Try
	{
		
		#Dim exception As %Exception.StatusException = ""
		#Dim statusCode As %Status                   = $System.Status.OK()
		#Dim %request As %CSP.Request                = %request
		#Dim %response As %CSP.Response              = %response
		#Dim businessService As Ens.BusinessService  = ""
		#Dim repoId As %String                       = ""
		#Dim objResponse As %DynamicObject = {}
		Set %response.Status = ..#HTTP201CREATED
		//
		Do ..SetResponseHeaders()
		//		
		Set statusCode = ##Class(Ens.Director).CreateBusinessService("Core REST Services", .businessService)
		//
		If ($System.Status.IsError(statusCode))
		{
			Return statusCode
		}
		
		Set repoVO = ##class(FrameworkCaedu.core.vo.Repository).%New()
		
		//Recupera o valor enviado no Header. O nome da variável de Header vem precedida de HTTP_
		Set repoVO.CreateServiceId  = %request.GetCgiEnv("HTTP_CREATE_SERVICE_ID")
		Set repoVO.ProcessServiceId = %request.GetCgiEnv("HTTP_PROCESS_SERVICE_ID")
		Set repoVO.MessageLogId     = $Case(%request.GetCgiEnv("HTTP_MESSAGELOG_ID"),"":0,:%request.GetCgiEnv("HTTP_MESSAGELOG_ID"))
		//Set repoVO.Payload 			= %request.Content.Read()
		
		Set payLoad = ""
		
		//Ajuste para pegar todos os dados recebidos e gravar no Payload
		While ('%request.Content.AtEnd)
		{
			Set payLoad = payLoad _ %request.Content.Read()
		}
		
		Set repoVO.Payload = payLoad
		
		Set statusCode = businessService.ProcessInput(repoVO, .repoId, "CreateRepository")
		//	
		If ($System.Status.IsError(statusCode))
		{
			Return statusCode
		}
		
		Set objResponse.RepositoryId = repoId
		Set %response.Status = ..#HTTP201CREATED
		
		//
		Write objResponse.%ToJSON()
	}
	Catch (exception)
	{
		Set statusCode = exception.AsStatus()
	}
	Return statusCode
}

ClassMethod SetResponseHeaders() [ Private ]
{
	#Dim %response As %CSP.Response  = %response
	//
	Set %response.CharSet     = "UTF-8"
	Set %response.ContentType = "applicaton/json"
}

/// Criação                              <br>       
/// Descrição    : Manipulador de solicitação CORS   <br>
/// O usuário deve substituir este método em sua página de login caso queira alterar o comportamento padrão.
/// Desenvolvedor: Anderson Soares      <br>
/// Dt Inclusão  : 22/01/2024           <br>
/// Atualizações                         <br>   
/// Data:  ID           :   Descrição       :   Desenvolvedor : 
ClassMethod OnHandleCorsRequest(url As %String) As %Status
{
    Try
    {
      #Dim statusCode As %Status                     = $System.Status.OK()
	    #Dim exception As %Exception.AbstractException = ""
	    #Dim %request As %CSP.Request                  = %request
	    #Dim %response As %CSP.Response                = %response
	    #Dim origin As %String                         = $Get(%request.CgiEnvs("HTTP_ORIGIN"))
	    #Dim headers As %String                        = "" 
	    #Dim method As %String                         = ""
		//
		If (origin '="")
		{
	        Do %response.SetHeaderIfEmpty("Access-Control-Allow-Origin", "*")	       
	        Do %response.SetHeaderIfEmpty("Access-Control-Allow-Credentials", "true")
		}
        // Allow requested headers
        Set headers=$Get(%request.CgiEnvs("HTTP_ACCESS_CONTROL_REQUEST_HEADERS"))
       	Do %response.SetHeaderIfEmpty("Access-Control-Allow-Headers",headers)
        //
        // Allow requested method
        Set method=$Get(%request.CgiEnvs("HTTP_ACCESS_CONTROL_REQUEST_METHOD"))
       	Do %response.SetHeaderIfEmpty("Access-Control-Allow-Methods",method)        
    }
    Catch (exception)
    {
        Set statusCode = exception.AsStatus()
    }
    Quit statusCode
}

}
