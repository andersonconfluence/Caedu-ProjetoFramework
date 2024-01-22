Class FrameworkCaedu.core.bo.http.Operation Extends Ens.BusinessOperation
{

Parameter ADAPTER = "EnsLib.HTTP.OutboundAdapter";

Property Adapter As EnsLib.HTTP.OutboundAdapter;

Parameter INVOCATION = "Queue";

Property ContentType As %String [ InitialExpression = "application/json; charset=UTF-8" ];

Parameter SETTINGS = "ContentType:Custom";

Method ChamadaPost(pRequest As FrameworkCaedu.core.bo.http.msg.ChamadaPostReq, Output pResponse As FrameworkCaedu.core.bo.http.msg.ChamadaPostResp) As %Status
{
	Set tSC = $$$OK
	Set pResponse = ##class(FrameworkCaedu.core.bo.http.msg.ChamadaPostResp).%New()
	
	Try
	{
		If (pRequest.Server = "")
		{
			Set pRequest.Server = ..Adapter.HTTPServer
		}
		
		If (pRequest.Port = "")
		{
			Set pRequest.Port	= ..Adapter.HTTPPort
		}
		
		If (pRequest.Url = "")
		{
			Set pRequest.Url = ..Adapter.URL	
		}
		
		Set tClassProxy = ##class(%Net.HttpRequest).%New()
		Set tClassProxy.ContentType = ..ContentType
		
		For i=1:1:pRequest.Headers.Count()
		{
			Set tValor = pRequest.Headers.GetAt(i)
			Do tClassProxy.SetHeader($PIECE(tValor,";",1),$PIECE(tValor,";",2))
		}
		
		Set tDados = ##class(%GlobalCharacterStream).%New()
		While 'pRequest.Contents.AtEnd
		{			
			Set tLine = pRequest.Contents.Read()
			
			Set tSC = tDados.Write(tLine)
		}	
		
		Do tDados.Rewind()
				
		Set tConteudo(1) = tDados
		
		
		If (pRequest.ComplementoUrl = "")
		{
			Set ..Adapter.URL = pRequest.Url
		}
		Else
		{
			Set tComplemento = ""
			For x=1:1:$Length(pRequest.ComplementoUrl, ";")
			{
				If (x = 1) {
					Set tComplemento = "?"_$Piece(pRequest.ComplementoUrl, ";", 1)
				} Else {
					Set tComplemento = tComplemento_"&"_$Piece(pRequest.ComplementoUrl, ";", x)
				}				
			}	
			Set ..Adapter.URL = pRequest.Url_tComplemento
		}
		
		If pRequest.UrlBase '= ""
		{
			Set ..Adapter.URL = pRequest.UrlBase_..Adapter.URL
		}
		
		Set ..Adapter.HTTPPort = pRequest.Port
		Set ..Adapter.HTTPServer = pRequest.Server
		
		#Dim tResp As %Net.HttpResponse
		Set tSC = ..Adapter.SendFormDataArray(.tResp,"POST",tClassProxy,,.tConteudo)
		$$$ThrowOnError(tSC)

		Set tBodyData = ##Class(%GlobalCharacterStream).%New()
		
		While ('tResp.Data.AtEnd)
		{
			Set tSC = tBodyData.Write(tResp.Data.ReadLine(14000))	
			$$$ThrowOnError(tSC)	
		}
		
		Set tSC = tBodyData.Rewind()
		$$$ThrowOnError(tSC)	
		
		Set pResponse.StatusMessage = "SUCESSO"
		Set pResponse.StatusCode 	= tResp.StatusCode
		Set pResponse.StatusLine	= tResp.StatusLine
		
		Set tSC = pResponse.Contents.CopyFrom(tBodyData)
		$$$ThrowOnError(tSC)

		Set tSC = tBodyData.Rewind()
		Set tSC = pResponse.Contents.CopyFrom(tBodyData)
		$$$ThrowOnError(tSC)
		
	}
	Catch (tException)
	{
		Set pResponse.StatusMessage = $System.Status.GetErrorText(tSC)
		Set pResponse.StatusCode 	= tResp.StatusCode
		Set pResponse.StatusLine 	= tResp.StatusLine
		Set pResponse.Contents		= tResp.Data
	}

	Quit $$$OK
}

XData MessageMap
{
<MapItems>
	<MapItem MessageType="FrameworkCaedu.core.bo.http.msg.ChamadaPostReq"> 
		<Method>ChamadaPost</Method>
	</MapItem>
</MapItems>
}

}
