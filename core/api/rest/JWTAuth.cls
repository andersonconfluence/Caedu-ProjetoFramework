Class FrameworkCaedu.core.api.rest.JWTAuth Extends %CSP.REST
{

Parameter HandleCorsRequest As %Boolean = 1;

XData UrlMap
{
<Routes>
   <Route Url="/token" Method="POST" Call="GetToken" />
</Routes>
}

ClassMethod GetToken() As %Status
{
	Try
	{
		
		#Dim exception As %Exception.StatusException = ""
		#Dim statusCode As %Status                   = $System.Status.OK()
		#Dim %request As %CSP.Request                = %request
		#Dim %response As %CSP.Response              = %response
		#Dim objResponse As %DynamicObject = {}
		Set %response.Status = ..#HTTP200OK
		//
		Do ..SetResponseHeaders()
		
		Set payLoad = %request.Content.Read()
				
		Set authObj = ##class(%DynamicObject).%FromJSON(payLoad)
		
		Set statusToken = ##class(FrameworkCaedu.core.security.Util).GetJWTAuth(authObj.username,authObj.password, .jwtToken)
			
		If ($System.Status.IsError(statusToken))
		{
            Set %response.Status = ..#HTTP401UNAUTHORIZED
		}
			
		Write jwtToken
	}
	Catch (exception)
	{
        Set %response.Status = ..#HTTP500INTERNALSERVERERROR
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
