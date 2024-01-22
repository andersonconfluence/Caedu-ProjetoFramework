/// Class for generic REST Operations
Class FrameworkCaedu.core.bo.rest.Operation Extends EnsLib.REST.Operation
{

Property HttpResponse As %Net.HttpResponse;

Property HttpRequest As %Net.HttpRequest;

Property Adapter As EnsLib.HTTP.OutboundAdapter;

Property URL As %String(MAXLEN = "");

/// Post Method
Method Post(pRequest As FrameworkCaedu.core.bo.rest.post.Request, Output pResponse As FrameworkCaedu.core.bo.rest.post.Response) As %Status
{
	Try
	{
		#Dim statusCode As %Status = $System.Status.OK()
		//
		Set statusCode = ..CallRestURL("POST", pRequest, .pResponse)
	}
	Catch(e)
	{
		Set statusCode = e.AsStatus()
		Set errorText = $System.Status.GetErrorText(statusCode)
	}
	Return statusCode
}

/// Get Method
Method Get(pRequest As FrameworkCaedu.core.bo.rest.get.Request, Output pResponse As FrameworkCaedu.core.bo.rest.get.Response) As %Status
{
		
	Try
	{
		#Dim statusCode As %Status = $System.Status.OK()
		//
		Set statusCode = ..CallRestURL("GET", pRequest, .pResponse)
	}
	Catch(e)
	{
		Set statusCode = e.AsStatus()
		;Set errorText  = $System.Status.GetErrorText(statusCode)
	}
	Return statusCode
}

/// Put Method
Method Put(pRequest As FrameworkCaedu.core.bo.rest.put.Request, Output pResponse As FrameworkCaedu.core.bo.rest.put.Response) As %Status
{
	Try
	{
		#Dim statusCode As %Status = $System.Status.OK()
		//
		Set statusCode = ..CallRestURL("PUT", pRequest, .pResponse)
	}
	Catch(e)
	{
		Set statusCode = e.AsStatus()
		Set errorText  = $System.Status.GetErrorText(statusCode)
	}
	Return statusCode
}

/// Delete Method
Method Delete(pRequest As FrameworkCaedu.core.bo.rest.delete.Request, Output pResponse As FrameworkCaedu.core.bo.rest.delete.Response) As %Status
{
	Try 
	{		
		#Dim statusCode As %Status = $System.Status.OK()
		//
		Set statusCode = ..CallRestURL("DELETE", pRequest, .pResponse)
	}
	Catch(e)
	{
		Set statusCode = e.AsStatus()
		Set errorText  = $System.Status.GetErrorText(statusCode)
	}		
	Return statusCode
}

/// Patch Method
Method Patch(pRequest As FrameworkCaedu.core.bo.rest.patch.Request, Output pResponse As FrameworkCaedu.core.bo.rest.patch.Response) As %Status
{
	Try 
	{		
		#Dim statusCode As %Status = $System.Status.OK()
		//
		Set statusCode = ..CallRestURL("PATCH", pRequest, .pResponse)
	}
	Catch(e)
	{
		Set statusCode = e.AsStatus()
		Set errorText  = $System.Status.GetErrorText(statusCode)
	}		
	Return statusCode
}

/// Generic Method for all methods
Method CallRestURL(httpMethod As %String, pRequest As FrameworkCaedu.core.bo.rest.genericoperation.Request, Output pResponse As FrameworkCaedu.core.bo.rest.genericoperation.Response) As %Status [ Private ]
{
	Try
	{
		#Dim statusCode As %Status                         				= $System.Status.OK()
		#Dim httpRequestVO As %String                      				= pRequest.RestRequestVO
		#Dim httpResponseVO As FrameworkCaedu.core.vo.RestResponse 	= ##Class(FrameworkCaedu.core.vo.RestResponse).%New()
		#Dim jsonResponse As %String                       				= ""
		#Dim stream As %Stream.Object                      				= ""
		//
		Set ..URL      = httpRequestVO.URL
		//
		Do ..SetRequestHeader(httpRequestVO.HttpHeaderArray)
		//
		Set httpRequestBody(1) = httpRequestVO.HttpRequestBody
		//
		Set statusCode     = ..Adapter.SendFormDataArray(.httpResponse, httpMethod, ..HttpRequest , "", .httpRequestBody, ..URL)
		
		
		Set ..HttpResponse = httpResponse
		Set jsonResponse   = ..GetHttpResponseBodyData(.stream)
		//
		If (jsonResponse '= "")
		{
			Set httpResponseVO.HttpResponseBody = jsonResponse
		}
		Else
		{
			Set httpResponseVO.HttpResponseStreamBody = stream
		}
		
		// response header
		If (httpRequestVO.IsResponseHeader) 
		{
			Set httpResponseVO.HttpResponseHeaderArray = ..GetHttpResponseHeaders()
		}
		
		Set httpResponseVO.HttpStatusCode = ..HttpResponse.StatusCode
		Set httpResponseVO.Status         = statusCode
		Set statusCode                    = pRequest.NewResponse(.pResponse)
		Set pResponse.RestResponseVO      = httpResponseVO
		Set pResponse.RestResponseVO 	  = httpResponseVO
		//

		Do pResponse.DoSpecifAction(pRequest)
		
	}
	Catch(e)
	{
		Set statusCode = e.AsStatus()
		Set errorText  = $System.Status.GetErrorText(statusCode)
	}
	
	Return statusCode
}

/// method that returns the response header
Method GetHttpResponseHeaders() As %ArrayOfDataTypes [ Private ]
{
	
	#Dim headerArray As %ArrayOfDataTypes = ##class(%ArrayOfDataTypes).%New()
	
	SET key=$ORDER(..HttpResponse.Headers(""))
    
	WHILE (key'="") {
     
	 	SET value = ..HttpResponse.Headers(key)
	  	
		DO headerArray.SetAt(value,key)
     	
     	SET key = $ORDER(..HttpResponse.Headers(key))
   
    }

	//			   
	Return headerArray
}

/// Method for get the Body Data Response
Method GetHttpResponseBodyData(ByRef pStream As %Stream.Object) As %String [ Private ]
{
	Set httpResponseBody = ""
	//
	If ($IsObject(..HttpResponse.Data))
	{
		If (..HttpResponse.Data.Size > 3641144)
		{
			Set pStream = ..HttpResponse.Data
			//
			Return ""
		}
		While ('..HttpResponse.Data.AtEnd)
		{
			Set httpResponseBody = httpResponseBody _ ..HttpResponse.Data.Read()
		}
	}
	Return httpResponseBody
}

/// Method for set the headers variables
Method SetRequestHeader(headerArray As %ArrayOfDataTypes) [ Private ]
{
	Set ..HttpRequest                = ##class(%Net.HttpRequest).%New()
	Set ..HttpRequest.ContentCharset = "UTF-8"
	Set ..HttpRequest.ContentType    = "application/json"
	//
	For 
	{
		Set value = headerArray.GetNext(.header) 
		//
		If header = "" 
		{
			Quit
		}
		//
		Do ..HttpRequest.SetHeader(header,value)	
	}
}

XData MessageMap
{
<MapItems>
	<MapItem MessageType="FrameworkCaedu.core.bo.rest.get.Request"> 
		<Method>Get</Method>
	</MapItem>
	<MapItem MessageType="FrameworkCaedu.core.bo.rest.post.Request"> 
		<Method>Post</Method>
	</MapItem>
	<MapItem MessageType="FrameworkCaedu.core.bo.rest.put.Request"> 
		<Method>Put</Method>
	</MapItem>
	<MapItem MessageType="FrameworkCaedu.core.bo.rest.patch.Request"> 
		<Method>Patch</Method>
	</MapItem>
	<MapItem MessageType="FrameworkCaedu.core.bo.rest.delete.Request"> 
		<Method>Delete</Method>
	</MapItem>
</MapItems>
}

}
