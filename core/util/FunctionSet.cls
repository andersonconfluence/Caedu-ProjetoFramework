Class FrameworkCaedu.core.util.FunctionSet Extends Ens.Rule.FunctionSet
{

/// pParameters is a comma delimited string 
ClassMethod GetResourcePathByServiceNameInstance(pInstance As %String, pServiceName As %String, pParameters As %String = "", pEscapeURL As %String = "", pDelimiter As %String = ",") As %String [ Final ]
{
	#Dim spContext As %ProcedureContext = ""
	#Dim resourcePath As %String        = ""
	//
	Set spContext = ##Class(%SQL.Statement).%ExecDirect(,"CALL confluence_linker_core_data.Service_GetResourcePathByServiceNameInstance(?,?) ", pInstance, pServiceName)
	//	
	If (spContext.%Next())
	{
		
		Set protocol     = $Select(spContext.%Get("HttpsEnabled"):"https",1:"http") 
		Set port         = spContext.%Get("Port")
		Set host         = spContext.%Get("Host")
		Set resourcePath = spContext.%Get("ResourcePath")
		Set param        = ##Class(%CSP.Page).EscapeURL(spContext.%Get("Params") ,"UTF8")
		Set param        = $Replace(param,"%00","")

		If ($ZStrip(param,"<>W") '= "") 
		{
			Set pParameters	 = spContext.%Get("Params")
		}
		
		If (port '= "80") && (port '= "443")
		{
			Set resourcePath = protocol _ "://" _ host _ ":" _ port _ resourcePath
		}
		Else
		{
			Set resourcePath = protocol _ "://" _ host _ resourcePath
		}
	}
	If (pParameters '= "")
	{
		Set resourcePath = ..BuildRestUrlParameters(resourcePath, pParameters, pEscapeURL, pDelimiter)
	}
	Return resourcePath
}

ClassMethod GetHostInfoByServiceNameInstance(pInstance As %String, pServiceName As %String) As %ArrayOfDataTypes [ Final ]
{
	#Dim spContext As %ProcedureContext = ""
	#Dim hostInfo As %ArrayOfDataTypes = ##class(%ArrayOfDataTypes).%New()
	//
	Set spContext = ##Class(%SQL.Statement).%ExecDirect(,"CALL confluence_linker_core_data.Service_GetHostInfoByServiceNameInstance(?,?) ", pInstance, pServiceName)
	//	
	If (spContext.%Next())
	{
		Do hostInfo.SetAt(spContext.%Get("TargetBusinessHost"),"TargetBusinessHost")
		Do hostInfo.SetAt(spContext.%Get("TargetRequestClassName"),"TargetRequestClassName")
	}
	Else
	{
	 	Throw ##Class(%Exception.General).%New("Host Info not found exception", $this , , "Instance: "_pInstance_" Service: "_pServiceName)	
	}
	
	Return hostInfo
}

ClassMethod BuildRestUrlParameters(pResourcePath As %String, pParameters As %String, pEscapeURL As %String = "", pDelimiter As %String = ",") As %String [ Final ]
{
	#Dim index As %Integer    = 1
	#Dim resourcePath         = pResourcePath
	#Dim parameter As %String = ""
	//
	
	For index = 1 : 1 : $Length(pParameters, pDelimiter)
	{
		Set parameter = $Piece(pParameters, pDelimiter, index)
		If (pEscapeURL = "Escape")
		{
			
			Set parameter = ##Class(%CSP.Page).EscapeURL(parameter ,"UTF8")
			Set parameter = $Replace(parameter, "%00", parameter, 1, 1)
		}
		
		Set resourcePath = $Replace(resourcePath, "*", parameter, 1, 1)
		

		If (pEscapeURL = "EscapePath")
		{			
			Set resourcePath = $Piece(resourcePath, "?", 1) _ "?" _ ##Class(%CSP.Page).EscapeURL($Piece(resourcePath, "?", 2) ,"UTF8")
		}
	}
	Return resourcePath
}

ClassMethod UpdateParamByServiceNameInstance(pInstance As %String, pServiceName As %String, pParameters As %String = "") As %Status [ Final ]
{
	Set status = $$$OK
	#Dim spContext As %ProcedureContext = ""
	//
	Set spContext = ##Class(%SQL.Statement).%ExecDirect(,"CALL confluence_linker_core_data.Service_GetResourcePathByServiceNameInstance(?,?) ", pInstance, pServiceName)
	//	
	If (spContext.%Next())
	{
		Set id = spContext.%Get("ID")
		Set service = ##class(FrameworkCaedu.core.data.Service).%OpenId(id)
		Set service.Params = pParameters
		
		Set status = service.%Save()
	}
	
	Return status
}

/*
Esse era o método original, porém falhava quando havia muitos caracteres especiais por mudar o tamanho
do pValue e não ir até o fim. Ajustado no método abaixo
ClassMethod EscapeJSON(pValue As %String) As %String
{
	For i = 1 : 1 : $Length(pValue)
	{
		Set char = $Extract(pValue,i)
		Set unicodeJSON = ..Lookup("UNICODE_JSON_DICT",char)
		if (unicodeJSON '= "")
		{
			Set $Extract(pValue,i) = unicodeJSON
		}
	}
	Return pValue
}
*/
ClassMethod EscapeJSON(pValue As %String) As %String
{
	Set strReturn = ""
	
	For i = 1 : 1 : $Length(pValue)
	{
		Set char = $Extract(pValue,i)
		Set unicodeJSON = ..Lookup("UNICODE_JSON_DICT",char)
		
		if (unicodeJSON '= "")
		{
			Set strReturn = strReturn_unicodeJSON
		}
		Else
		{
			Set strReturn = strReturn_char
		}
	}
	
	Return strReturn
}

}
